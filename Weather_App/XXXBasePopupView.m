//
//  XXXBasePopupView.m
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXBasePopupView.h"
#import "Masonry.h"

static NSString * XXXBasePopupCustomShowAnimationKey = @"custom.show.animation";
static NSString * XXXBasePopupCustomDismissAnimationKey = @"custom.dismiss.animation";

@interface XXXBasePopupView (Animation)
- (void) showAnimation;
- (void) dismissAnimation;
- (void) finishDismiss;
@end

@interface XXXBasePopupView (Private)

- (void)_addSubContentView:(XXXPopupLayoutType)layoutType
      contentViewWidthType:(XXXPopupContentSizeType)widthType
                     width:(CGFloat)width
                heightType:(XXXPopupContentSizeType)heightType
                    height:(CGFloat)height;

- (UIColor *) touchMaskViewColor;
@end

@interface XXXBasePopupView()<UIGestureRecognizerDelegate,CAAnimationDelegate>{
    BOOL _inAnimation;
    
    BOOL _isWrapperViewController;
    XXXPopupLayoutType _wrapperLayoutType;
}
@property (nonatomic ,strong ,readwrite) UIView * viewControllerWrapperView;
@end

@implementation XXXBasePopupView

-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        self.showAnimationDuration = 0.3;
        self.dismissAnimationDuration = 0.3;
        
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
    
    [self _addSubContentView:self.layoutType
        contentViewWidthType:self.contentViewWidthType
                       width:[self contentViewFixedWidth]
                  heightType:self.contentViewHeightType
                      height:[self contentViewFixedHeight]];
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
    
    XXXPopupLayoutType layoutType = _isWrapperViewController ? _wrapperLayoutType : self.layoutType;
    
    if (layoutType == XXXPopupLayoutTypeTop) {
        return XXXPopupTransitStyleFromTop;
    } else if (layoutType == XXXPopupLayoutTypeBottom) {
        return XXXPopupTransitStyleFromBottom;
    } else if (layoutType == XXXPopupLayoutTypeCenter) {
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

- (CAAnimation *) customShowAnimation{
    return nil;
}

- (CAAnimation *) customDismissAnimation{
    return nil;
}

@end

@implementation XXXBasePopupView (Animation)

- (void) showAnimation{
    
    CAAnimation * customAnimation = [self customShowAnimation];
    if (customAnimation) {
        customAnimation.delegate = self;
        customAnimation.removedOnCompletion = NO;
        [self.contentView.layer addAnimation:customAnimation
                                      forKey:XXXBasePopupCustomShowAnimationKey];
        [UIView animateWithDuration:customAnimation.duration animations:^{
            self.contentView.alpha = 1.0f;
            self->_touchMaskView.alpha = 1;
        }];
        return;
    }
    
    [self contentViewDismissLocation];
    _inAnimation = YES;
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.contentView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
        self->_touchMaskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self finishShow];
    }];
}

- (void) dismissAnimation{
    
    CAAnimation * customAnimation = [self customDismissAnimation];
    if (customAnimation) {
        customAnimation.removedOnCompletion = NO;
        customAnimation.delegate = self;
        [self.contentView.layer addAnimation:customAnimation
                                      forKey:XXXBasePopupCustomDismissAnimationKey];
        [UIView animateWithDuration:customAnimation.duration animations:^{
            self->_touchMaskView.alpha = 0;
        }];
        return;
    }
    
    [UIView animateWithDuration:self.dismissAnimationDuration animations:^{
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
    if (self.contentView.layer.animationKeys.count) {
        [self.contentView.layer removeAllAnimations];
    }
}

- (void) finishDismiss{
    _inAnimation = NO;
    if (self.bDismissedCallback) {
        self.bDismissedCallback();
    }
    [self removeFromSuperview];
    if (self.contentView.layer.animationKeys.count) {
        [self.contentView.layer removeAllAnimations];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{
    _inAnimation = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _inAnimation = NO;
    
    if ([self.contentView.layer animationForKey:XXXBasePopupCustomShowAnimationKey] == anim) {
        [self finishShow];
    }
    if ([self.contentView.layer animationForKey:XXXBasePopupCustomDismissAnimationKey]  == anim) {
        [self finishDismiss];
    }
}

@end

@implementation XXXBasePopupView (Private)

- (void)_addSubContentView:(XXXPopupLayoutType)layoutType
      contentViewWidthType:(XXXPopupContentSizeType)widthType
                     width:(CGFloat)width
                heightType:(XXXPopupContentSizeType)heightType
                    height:(CGFloat)height{

    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.restorationIdentifier = @"popupView.contentView";
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (layoutType == XXXPopupLayoutTypeTop) {
                make.top.centerX.equalTo(self);
            } else if (layoutType == XXXPopupLayoutTypeBottom) {
                make.centerX.bottom.equalTo(self);
            } else if (layoutType == XXXPopupLayoutTypeCenter) {
                make.center.equalTo(self);
            }
            
            if (widthType == XXXPopupContentSizeFixed) {
                make.width.mas_equalTo(width);
            }
            
            if (heightType == XXXPopupContentSizeFixed) {
                make.height.mas_equalTo(height);
            }
        }];
    }
}

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

    [self wrapViewController:vc
                  layoutType:XXXPopupLayoutTypeBottom
             contentViewSize:CGSizeMake([UIScreen.mainScreen bounds].size.width, fixedHeight)];
}

- (void) wrapViewController:(UIViewController *)vc
                 layoutType:(XXXPopupLayoutType)layoutType
            contentViewSize:(CGSize)contentViewSize{
    if (vc && [vc isKindOfClass:[UIViewController class]]) {

        _isWrapperViewController = YES;
        _wrapperLayoutType = layoutType;
        
        self.viewControllerWrapperView = vc.view;
        self.viewControllerWrapperView.restorationIdentifier = @"popupView.vc.wrapperView";
        
        [self _addSubContentView:layoutType
            contentViewWidthType:XXXPopupContentSizeFixed
                           width:contentViewSize.width
                      heightType:XXXPopupContentSizeFixed
                          height:contentViewSize.height];
        [self.contentView addSubview:self.viewControllerWrapperView];
        [self.viewControllerWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}
@end
