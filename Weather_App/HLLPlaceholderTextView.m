//
//  HLLPlaceholderTextView.m
//  CategoryDemo
//
//  Created by Rocky Young on 16/8/9.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import "HLLPlaceholderTextView.h"
#import "UILabel+ContentSize.h"

#ifndef kDefaultMargin

#define kDefaultMargin     8
#endif

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;
NSInteger const UILabel_PlaceHolderLabel_Tag = 10;

@interface UIPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation UIPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        _placeholder = @"";
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        _placeholder = @"";
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:UILabel_PlaceHolderLabel_Tag] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:UILabel_PlaceHolderLabel_Tag] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        UIEdgeInsets insets = self.textContainerInset;
        if (_placeHolderLabel == nil )
        {
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left+5,insets.top,self.bounds.size.width - (insets.left +insets.right+10),1.0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = UILabel_PlaceHolderLabel_Tag;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [_placeHolderLabel setFrame:CGRectMake(insets.left+5,
                                               insets.top,
                                               self.bounds.size.width - (insets.left +insets.right+10),
                                               CGRectGetHeight(_placeHolderLabel.frame))];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:UILabel_PlaceHolderLabel_Tag] setAlpha:1];
    }
    
    [super drawRect:rect];
}
- (void)setPlaceholder:(NSString *)placeholder{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
}

@end


@implementation UILimitTextView

- (void)setLimitLength:(NSInteger)limitLength
{
    if (!_limitText)
    {
        _limitText = [[UILabel alloc] init];
        _limitText.backgroundColor = [UIColor clearColor];
        _limitText.font = [UIFont systemFontOfSize:14];
        _limitText.textColor = [UIColor lightTextColor];
        _limitText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_limitText];
    }
    
    if (limitLength > 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChangeNotification" object:nil];
    }
    _limitLength = limitLength;
    
    [self updateLimitText];
    
}

// 监听字符变化，并处理
- (void)onTextViewEditChanged:(NSNotification *)obj
{
    if (_limitLength > 0)
    {
        UITextView *textField = self;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > _limitLength)
            {
                NSLog(@"onTextViewEditChanged-超过最大字数限制");
                
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limitLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:_limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limitLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}




- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0)
    {
        // 表求增加
        if (self.text.length + text.length > _limitLength)
        {
            NSLog(@"shouldChangeTextInRange-超过最大字数限制");
            return NO;
        }
    }
    
    return YES;
}

- (void)updateLimitText
{
    NSInteger curLength = self.text.length;
    
    if (curLength > _limitLength)
    {
        NSLog(@"弹出提示框-超过最大字数限制");
        
        _limitText.text = [NSString stringWithFormat:@"%ld/%ld", (long)_limitLength, (long)_limitLength];
    }
    else
    {
        _limitText.text = [NSString stringWithFormat:@"%ld/%ld", (long)curLength, (long)_limitLength];
    }
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_limitText)
    {
        CGSize contentSize = self.contentSize;
        
        if (contentSize.height < self.bounds.size.height)
        {
            contentSize = self.bounds.size;
        }
        else
        {
            // 处理contentoffset的问题
        }
        
        CGSize textSize = [_limitText textSizeIn:contentSize];
        CGRect rect = CGRectMake(0, 0, textSize.width + kDefaultMargin, textSize.height + kDefaultMargin);
        rect.origin.x += contentSize.width - rect.size.width - kDefaultMargin;
        rect.origin.y += contentSize.height - rect.size.height - kDefaultMargin;
        _limitText.frame = rect;
    }
}
@end
