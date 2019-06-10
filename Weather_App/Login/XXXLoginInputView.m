//
//  XXXLoginInputView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXLoginInputView.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@implementation XXXLoginInputView

- (instancetype) initWithPlaceholder:(NSString *)placeholder{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _textField = [UITextField new];
        _textField.placeholder = placeholder;
        _textField.textColor = [UIColor orangeColor];
        _textField.font = [UIFont systemFontOfSize:16];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(5, 12, 5, 12));
        }];
        
        UIView * lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:@"c9c9c9"];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.left.right.equalTo(_textField);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (NSString *)text{
    return _textField.text;
}

- (void) setupKeybordType:(UIKeyboardType)type{
    _textField.keyboardType = type;
}
@end
