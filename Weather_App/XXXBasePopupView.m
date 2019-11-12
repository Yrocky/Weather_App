//
//  XXXBasePopupView.m
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXBasePopupView.h"
#import "Masonry.h"

@interface XXXBasePopupView (Animation)
- (void) showAnimation;
- (void) dismissAnimation;
- (void) finishDismiss;
@end

@interface XXXBasePopupView (PrivateCustomer)
- (UIColor *) touchMaskViewColor;
@end

@interface XXXBasePopupView()<UIGestureRecognizerDelegate>{
    BOOL _inAnimation;
}
@property (nonatomic ,strong ,readwrite) UIView * viewControllerWrapperView;
@end

@implementation XXXBasePopupView

-(void)dealloc{
    NSLog(@"XXXBasePopupView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        self.dismissOnMaskTouched = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(dismiss)];
        tap.delegate = self;
        UIView * touchMaskView = [UIView new];
        touchMaskView.restorationIdentifier = @"popupView.touchMaskView";
        touchMaskView.alpha = 0;
        touchMaskView.backgroundColor = [self touchMaskViewColor];
        [touchMaskView addGestureRecognizer:tap];
        [self addSubview:touchMaskView];
        [touchMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _touchMaskView = touchMaskView;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.dismissOnMaskTouched;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return touch.view == _touchMaskView;
}

#pragma mark - API

- (void) clearContentViewCornerRadius{
    _contentView.layer.cornerRadius = 0.0f;
}

- (void) addSubContentView{
    
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.restorationIdentifier = @"popupView.contentView";
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.layoutType == XXXPopupLayoutTypeTop) {
                make.top.centerX.equalTo(self);
            } else if (self.layoutType == XXXPopupLayoutTypeBottom) {
                make.centerX.bottom.equalTo(self);
            } else if (self.layoutType == XXXPopupLayoutTypeCenter) {
                make.center.equalTo(self);
            }
            
            if (self.contentViewWidthType == XXXPopupContentSizeFixed) {
                make.width.mas_equalTo([self contentViewFixedWidth]);
            }
            
            if (self.contentViewHeightType == XXXPopupContentSizeFixed) {
                make.height.mas_equalTo([self contentViewFixedHeight]);
            }
        }];
    }
}

- (void) showIn:(UIView *)view{
    
    if (view && !_inAnimation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [view addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [self showAnimation];
        });
    }
}

- (void) dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animation{
    if (_inAnimation) {
        return;
    }
    _inAnimation = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animation) {
            [self dismissAnimation];
        } else {
            self.contentView.alpha = 0.0f;
            self->_touchMaskView.alpha = 0.0f;
            [self finishDismiss];
        }
    });
}
@end

@implementation XXXBasePopupView (CustomeUI)

- (XXXPopupTransitStyle) transitStyle{
    if (self.layoutType == XXXPopupLayoutTypeTop) {
        return XXXPopupTransitStyleFromTop;
    } else if (self.layoutType == XXXPopupLayoutTypeBottom) {
        return XXXPopupTransitStyleFromBottom;
    } else if (self.layoutType == XXXPopupLayoutTypeCenter) {
        return XXXPopupTransitStyleShrinkInOut;
    }
    return XXXPopupTransitStyleDefault;
}

- (XXXPopupLayoutType) layoutType{
    return XXXPopupLayoutTypeBottom;
}

- (XXXPopupMaskColorType)touchMaskViewColorType{
    return XXXPopupMaskColorClear;
}

- (XXXPopupContentSizeType) contentViewWidthType{
    return XXXPopupContentSizeFixed;
}

- (CGFloat) contentViewFixedWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

- (XXXPopupContentSizeType)contentViewHeightType{
    return XXXPopupContentSizeFixed;
}

- (CGFloat) contentViewFixedHeight{
    return 100;
}
@end

@implementation XXXBasePopupView (Animation)

- (void) showAnimation{
    
    [self contentViewDismissLocation];
    
    _inAnimation = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
        self->_touchMaskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self finishShow];
    }];
}

- (void) dismissAnimation{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self contentViewDismissLocation];
        self->_touchMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self finishDismiss];
    }];
}

- (void) contentViewDismissLocation{
    
    XXXPopupTransitStyle transitStyle = self.transitStyle;

    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (transitStyle == XXXPopupTransitStyleFromBottom) {
        self.contentView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } else if (transitStyle == XXXPopupTransitStyleFromTop) {
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    } else if (transitStyle == XXXPopupTransitStyleFromLeft) {
        self.contentView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
    } else if (transitStyle == XXXPopupTransitStyleFromRight) {
        self.contentView.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
    } else if (transitStyle == XXXPopupTransitStyleShrinkInOut) {
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } else {// default
        self.contentView.alpha = 0.0f;
    }
}
- (void) finishShow{
    _inAnimation = NO;
    if (self.bShowedCallback) {
        self.bShowedCallback();
    }
}

- (void) finishDismiss{
    _inAnimation = NO;
    if (self.bDismissedCallback) {
        self.bDismissedCallback();
    }
    [self removeFromSuperview];
}
@end

@implementation XXXBasePopupView (PrivateCustomer)

- (UIColor *) touchMaskViewColor{
    switch ([self touchMaskViewColorType]) {
        case XXXPopupMaskColorClear: return [UIColor clearColor];
        case XXXPopupMaskColorWhite: return [UIColor colorWithWhite:1 alpha:0.5];
        case XXXPopupMaskColorBlurWhite: return [UIColor colorWithWhite:1 alpha:0.5];
        case XXXPopupMaskColorBlack: return [UIColor colorWithWhite:0 alpha:0.5];
        case XXXPopupMaskColorBlurBlack: return [UIColor colorWithWhite:0 alpha:0.5];
    }
    return [UIColor clearColor];
}

@end

@implementation XXXBasePopupView (WrapperViewController)

- (void)wrapViewController:(UIViewController *)vc fixedHeight:(CGFloat)fixedHeight{
    
    if (vc && [vc isKindOfClass:[UIViewController class]]) {
        self.viewControllerWrapperView = vc.view;
        [self addSubContentView];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(fixedHeight);
        }];
        [self.contentView addSubview:self.viewControllerWrapperView];
        [self.viewControllerWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

@end
