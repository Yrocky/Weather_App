//
//  KXBeautySlider.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautySlider.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface KXBeautySlider ()

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *sufCoverView;

@property (nonatomic, strong) CAGradientLayer *sliderLayer;

@property (nonatomic, strong) UIImageView *thumView;



@property (nonatomic, assign) CGFloat thumHeight;

@end

@implementation KXBeautySlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame Height:(CGFloat)height type:(KXSliderType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _thumHeight = height;
        [self addSubview:self.sliderView];
        [self.sliderView.layer addSublayer:self.sliderLayer];
        [self.sliderView addSubview:self.coverView];
        [self.sliderView addSubview:self.sufCoverView];
        
        [self addSubview:self.thumView];
        [self addSubview:self.tipLabel];
        
        self.bgColor = [UIColor colorWithHexString:@"#F0F0F0"];
        [self layoutUI];
    }
    return self;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
    
    [self changeSliderProgress];
    if (_type == KXSliderType_mid) {
         self.tipLabel.text = [NSString stringWithFormat:@"%d", (int)(_progress * 100 - 50)];
    } else {
        self.tipLabel.text = [NSString stringWithFormat:@"%d", (int)(_progress * 100)];
    }
   
    if (_progressDidChanged) {
        _progressDidChanged(_progress);
    }
}

- (void)changeSliderProgress
{
    CGFloat w = self.sliderView.bounds.size.width;
    CGFloat x = _progress * w;
    CGRect frame = self.sliderView.bounds;
    
    if (_type == KXSliderType_mid) {
        if (_progress > 0.5) {
            CGRect perFrame = frame;
            perFrame.size.width = w * 0.5;
            self.coverView.frame = perFrame;
            CGRect sufFrame = frame;
            sufFrame.origin.x = x;
            sufFrame.size.width = w - x;
            self.sufCoverView.frame = sufFrame;
        } else {
            CGRect perFrame = frame;
            perFrame.size.width = x;
            self.coverView.frame = perFrame;
            CGRect sufFrame = frame;
            sufFrame.origin.x = w * 0.5;
            sufFrame.size.width = w * 0.5;
            self.sufCoverView.frame = sufFrame;
        }
    } else {
        frame.origin.x = x;
        frame.size.width = w - x;
        self.coverView.frame = frame;
    }
    self.thumView.center = CGPointMake(x, self.frame.size.height * 0.5);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)layoutUI
{
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    self.sliderView.frame = CGRectMake(0, (h - 4) / 2.0, w, 4);
    self.sliderLayer.frame = self.sliderView.bounds;
     [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(30, 15));
         make.bottom.mas_equalTo(self.thumView.mas_top).mas_offset(-5);
         make.centerX.mas_equalTo(self.thumView.mas_centerX);
     }];
     
    _thumView.frame = CGRectMake(0, (h - _thumHeight) / 2.0, _thumHeight, _thumHeight);
    
    _thumView.layer.cornerRadius = self.thumView.bounds.size.height * 0.5;
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (bgColor) {
        self.coverView.backgroundColor = bgColor;
        self.sufCoverView.backgroundColor = bgColor;
    }
}

- (void)setTipsColor:(UIColor *)tipsColor
{
    if (tipsColor) {
        self.tipLabel.textColor = tipsColor;
    }
}

- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.layer.masksToBounds = YES;
        _sliderView.layer.cornerRadius = 4 * 0.5;
    }
    return _sliderView;
}

- (void)setType:(KXSliderType)type
{
    _type = type;
    if (_type == KXSliderType_mid) {
        _sufCoverView.hidden = NO;
        _sliderLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFAC47"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor];
        _sliderLayer.locations = @[@(0), @(0.5), @(1)];
    } else {
        _sufCoverView.hidden = YES;
        _sliderLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFAC47"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor];
        _sliderLayer.locations = @[@(0), @(1)];
    }
}

- (CAGradientLayer *)sliderLayer
{
    if (!_sliderLayer) {
        _sliderLayer = [[CAGradientLayer alloc] init];
        if (_type == KXSliderType_mid) {
            _sliderLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FFAC47"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor];
            _sliderLayer.locations = @[@(0), @(0.5), @(1)];
        } else {
            _sliderLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFAC47"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#FF3255"].CGColor];
            _sliderLayer.locations = @[@(0), @(1)];
        }
        
        _sliderLayer.startPoint = CGPointMake(0, 1);
        _sliderLayer.endPoint = CGPointMake(1, 1);
    }
    return _sliderLayer;
}


- (UIImage *)getThumbImage
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor redColor];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}


- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
    }
    return _coverView;
}

- (UIView *)sufCoverView
{
    if (!_sufCoverView) {
        _sufCoverView = [[UIView alloc] init];
    }
    return _sufCoverView;
}

- (UIImageView *)thumView
{
    if (!_thumView) {
        _thumView = [[UIImageView alloc] init];
        _thumView.image = [UIImage imageNamed:@"meiyan_jindu_shoub"];
        _thumView.contentMode = UIViewContentModeScaleAspectFill;
        _thumView.clipsToBounds = YES;
        _thumView.layer.masksToBounds = YES;
    }
    return _thumView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        _tipLabel.hidden = YES;
        _tipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipLabel;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    CGPoint pt = [touches.anyObject locationInView:self];
    CGRect frame =self.thumView.frame;
    CGFloat minX = frame.size.width * 0.5;
    CGFloat maxX = self.frame.size.width - minX;
    CGFloat x = pt.x;
    x = x > maxX ? maxX : x < 0 ? 0 : x;
        
    self.progress = x / maxX;
    self.tipLabel.hidden = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.tipLabel.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KXSliderEnded" object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KXSliderBegan" object:nil];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = CGRectInset(self.bounds, -10, -20);
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }
    return NO;
}



@end
