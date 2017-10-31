//
//  FDDismissingAnimator.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDDismissingAnimator.h"
#import "YXEasing.h"
#import "MMGCD.h"
#import "UIView+MHCommon.h"

@implementation FDDismissingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return .5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 自己的view
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // 动画时间
    CGFloat duration = [self transitionDuration:transitionContext];
    
    // 开始点 + 结束点
    CGPoint startPoint = fromView.center;
    CGPoint endPoint   = CGPointMake(fromView.middleX,
                                     fromView.middleY + kScreenHeight);
    
    // 关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath              = @"position";
    keyAnimation.values               = [YXEasing calculateFrameFromPoint:startPoint
                                                                  toPoint:endPoint
                                                                     func:CubicEaseIn
                                                               frameCount:duration * 60.f];
    keyAnimation.duration             = duration;
    fromView.center                   = endPoint;
    [fromView.layer addAnimation:keyAnimation forKey:nil];
    
    [[MMGCDQueue mainQueue] execute:^{
        
        [transitionContext completeTransition:YES];
        
    } afterDelaySecs:duration];
}

@end
