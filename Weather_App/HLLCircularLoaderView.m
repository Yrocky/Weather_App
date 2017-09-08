//
//  HLLCircularLoaderView.m
//  Weather_App
//
//  Created by user1 on 2017/8/24.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLCircularLoaderView.h"

@interface HLLCircularLoaderView ()<CAAnimationDelegate>

@property (nonatomic ,strong) CAShapeLayer * circlePathLayer;
@property (nonatomic ,assign) CGFloat circleRadius;

@end

@implementation HLLCircularLoaderView

+ (instancetype) circularLoaderView{

    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self config];
    }
    return self;
}

- (void) config{

    //
    self.circleRadius = 20;
    
    self.circleLineWidth = 2;
    self.circleLineColor = [UIColor redColor];
    
    //
    self.circlePathLayer = [CAShapeLayer layer];
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.lineWidth = self.circleLineWidth;
    self.circlePathLayer.fillColor = [UIColor clearColor].CGColor;
    self.circlePathLayer.strokeColor = self.circleLineColor.CGColor;
    [self.layer addSublayer:self.circlePathLayer];
    
    //
    self.backgroundColor = [UIColor whiteColor];
    
    //
    self.progress = 0;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.path = self.circlePath.CGPath;
}

- (void) reveal{

    // 1
    self.backgroundColor = [UIColor clearColor];
    self.progress = 1;
    // 2
    [self.circlePathLayer removeAnimationForKey:@"strokeWidth"];
    // 3
    [self.circlePathLayer removeFromSuperlayer];
    self.superview.layer.mask = self.circlePathLayer;
    
    // 1
    CGPoint center = CGPointMake(CGRectGetMidY(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat finalRadius = sqrt((center.x*center.x) + (center.y*center.y));
    CGFloat radiusInset = finalRadius - self.circleRadius;
    CGRect outerRect = CGRectInset([self circleFrame], -radiusInset, -radiusInset);
    CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerRect].CGPath;
    
    // 2
    CGPathRef fromPath = self.circlePathLayer.path;
    CGFloat fromLineWidth = self.circlePathLayer.lineWidth;
    
    CABasicAnimation * lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.fromValue = @(fromLineWidth);
    lineWidthAnimation.toValue = @(2*finalRadius);
    
    CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(fromPath);
    pathAnimation.toValue = (__bridge id _Nullable)(toPath);
    
    // 5
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1.25;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.animations = @[pathAnimation, lineWidthAnimation];
    [groupAnimation setRemovedOnCompletion:NO];
    [groupAnimation setFillMode:kCAFillModeForwards];
    groupAnimation.delegate = self;
    
    [self.circlePathLayer addAnimation:groupAnimation forKey:@"strokeWidth"];
}

- (void) reset{

    [self.circlePathLayer removeAllAnimations];
    self.superview.layer.mask = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor whiteColor];
    }];
    self.circlePathLayer.lineWidth = self.circleLineWidth;
    self.circlePathLayer.path = self.circlePath.CGPath;
    [self.layer addSublayer:self.circlePathLayer];
    
    self.progress = 0;
}

#pragma mark - Private M

- (CGRect) circleFrame{

    CGRect circleFrame = CGRectMake(0, 0, 2 * self.circleRadius, 2 * self.circleRadius);
    
    CGRect circlePathBounds = self.circlePathLayer.bounds;
    circleFrame.origin.x = CGRectGetMidX(circlePathBounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(circlePathBounds) - CGRectGetMidY(circleFrame);
    
    return circleFrame;
}

- (UIBezierPath *) circlePath{

    return [UIBezierPath bezierPathWithOvalInRect:[self circleFrame]];
}

#pragma mark - Setter & Getter M

- (CGFloat)progress{

    return self.circlePathLayer.strokeEnd;
}
- (void)setProgress:(CGFloat)progress {

    if (progress > 1) {
        self.circlePathLayer.strokeEnd = 1;
    }
    else if (progress < 0){
        self.circlePathLayer.strokeEnd = 0;
    }
    else{
        self.circlePathLayer.strokeEnd = progress;
    }
}

- (void)setCircleLineWidth:(CGFloat)circleLineWidth{

    _circleLineWidth = circleLineWidth;
    self.circlePathLayer.lineWidth = circleLineWidth;
}

- (void)setCircleLineColor:(UIColor *)circleLineColor{
 
    _circleLineColor = circleLineColor;
    self.circlePathLayer.strokeColor = circleLineColor.CGColor;
}

#pragma mark - CAAnimationDelegate M

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (self.superview) {
        self.progress = 0;
        [self.circlePathLayer removeAllAnimations];
        self.superview.layer.mask = nil;
    }
}
@end
