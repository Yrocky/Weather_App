//
//  FDPresentingAnimator.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDPresentingAnimator.h"
#import "YXEasing.h"
#import "UIView+MHCommon.h"
#import "MMGCD.h"

@implementation FDPresentingAnimator

// 转场动画时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 1.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 另一个view
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.y         = kScreenHeight;
    
    // 管理容器
    UIView *container = [transitionContext containerView];
    
    // 容器中添加推出的view
    [container addSubview:toView];
    
    // 动画时间
    CGFloat duration = [self transitionDuration:transitionContext];
    
    // 开始点 + 结束点
    CGPoint startPoint = toView.center;
    CGPoint endPoint   = container.center;
    
    // 关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath              = @"position";
    keyAnimation.values               = [YXEasing calculateFrameFromPoint:startPoint
                                                                  toPoint:endPoint
                                                                     func:ExponentialEaseOut
                                                               frameCount:duration * 60.f];
    keyAnimation.duration             = duration;
    toView.center                     = container.center;
    [toView.layer addAnimation:keyAnimation forKey:nil];
    
    [[MMGCDQueue mainQueue] execute:^{
        
        [transitionContext completeTransition:YES];
        
    } afterDelaySecs:duration];
}


@end
