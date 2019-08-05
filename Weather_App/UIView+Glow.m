//
//  UIView+Glow.m
//  CategoryDemo
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 Young Rocky. All rights reserved.
//

#import "UIView+Glow.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation UIView (Glow)


+ (void)load{
    NSLog(@"+load UIView(Glow)");
}

#pragma mark -
#pragma mark Runtime

static char* GLOWVIEW_KEY = "GLOWVIEW";

- (UIView *)glowView
{
    return objc_getAssociatedObject(self, GLOWVIEW_KEY);
}

- (void)setGlowView:(UIView*)glowView
{
    objc_setAssociatedObject(self, GLOWVIEW_KEY, glowView, OBJC_ASSOCIATION_RETAIN);
}


#define XXXUIViewGetter(__name__)\
- (UIView *)__name__ {\
    return objc_getAssociatedObject(self, __name__##_key);\
}\

#define XXXUIViewSetter(__name__)\
- (void)set##__name__:(UIView *)__name__ {\
    objc_setAssociatedObject(self, __name__##_key, __name__, OBJC_ASSOCIATION_RETAIN);\
}


#pragma mark -
#pragma mark API

- (void)startGlowingWithColor:(UIColor *)color intensity:(CGFloat)intensity
{
    [self startGlowingWithColor:color fromIntensity:0.1 toIntensity:intensity repeat:YES];
}

- (void)startGlowingWithColor:(UIColor*)color fromIntensity:(CGFloat)fromIntensity toIntensity:(CGFloat)toIntensity repeat:(BOOL)repeat
{
    [self startGlowingWithColor:color fromIntensity:0.1 toIntensity:toIntensity repeat:YES duration:1];
}

- (void)startGlowingWithColor:(UIColor*)color fromIntensity:(CGFloat)fromIntensity toIntensity:(CGFloat)toIntensity repeat:(BOOL)repeat duration:(CGFloat)dur
{
    if ([self glowView])
    {
        return;
    }
    
    UIImage* image;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [color setFill];
    
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1.0];
    
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    UIView *glowView = [[UIImageView alloc] initWithImage:image];
    
//    [self.superview insertSubview:glowView aboveSubview:self];
    [self.superview insertSubview:glowView belowSubview:self];
    
    glowView.center = self.center;
    
    
    glowView.alpha = 0;
    glowView.layer.shadowColor = color.CGColor;
    glowView.layer.shadowOffset = CGSizeZero;
    glowView.layer.shadowRadius = 10;
    glowView.layer.shadowOpacity = 1.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(fromIntensity);
    animation.toValue = @(toIntensity);
    animation.repeatCount = repeat ? HUGE_VAL : 0;
    animation.duration = dur;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [glowView.layer addAnimation:animation forKey:@"pulse"];
    [self setGlowView:glowView];
}

- (void)glowOnceAtLocation:(CGPoint)point inView:(UIView *)view
{
    [self startGlowingWithColor:[UIColor whiteColor] fromIntensity:0 toIntensity:0.6 repeat:NO];
    
    [self glowView].center = point;
    [view addSubview:[self glowView]];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self stopGlowing];
    });
}

- (void)glowOnce
{
    [self startGlowing];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self stopGlowing];
    });
    
}


- (void)startGlowing
{
    [self startGlowingWithColor:[UIColor whiteColor] intensity:0.6];
}

- (void)stopGlowing
{
    [[self glowView] removeFromSuperview];
    [self setGlowView:nil];
}

@end
