//
//  MMAnimator.h
//  Weather_App
//
//  Created by user1 on 2018/9/17.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MMAnimatorAnimationBlock)();
typedef void(^MMAnimatorCompletionBlock)(BOOL finished);


@class MMAnimator ,MMSpringAnimator ,MMKeyframeAnimator;
@protocol MMAnimator <NSObject>
@optional
- (id<MMAnimator>(^)(NSTimeInterval)) duration;
- (id<MMAnimator>(^)(NSTimeInterval)) delay;
- (id<MMAnimator>(^)(UIViewAnimationOptions)) options;
- (id<MMAnimator>) animations:(MMAnimatorAnimationBlock)animations;
- (id<MMAnimator>) completion:(MMAnimatorCompletionBlock)completion;

- (void) animate;
@end

@protocol MMSpringAnimator <MMAnimator>
- (id<MMSpringAnimator>(^)(CGFloat)) dampingRatio;
- (id<MMSpringAnimator>(^)(CGFloat)) velocity;
@end

@protocol MMKeyframeAnimator <MMAnimator>
- (id<MMKeyframeAnimator>(^)(UIViewKeyframeAnimationOptions)) keyFrameOptions;
@end

@interface MMAnimator : NSObject<MMAnimator>{
    NSTimeInterval _duration;
    NSTimeInterval _delay;
    UIViewAnimationOptions _options;
}
+ (instancetype) animator;
@end

@interface MMSpringAnimator : MMAnimator<MMSpringAnimator>{
    CGFloat _dampingRatio;
    CGFloat _velocity;
}
@end

@interface MMKeyframeAnimator : MMAnimator<MMKeyframeAnimator>{
    UIViewKeyframeAnimationOptions __options;
}
@end

@interface UIView (Animator)

+ (MMAnimator *) animator;
+ (MMSpringAnimator *) springAnimator;
+ (MMKeyframeAnimator *) keyframeAnimator;
@end
