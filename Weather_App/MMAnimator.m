//
//  MMAnimator.m
//  Weather_App
//
//  Created by user1 on 2018/9/17.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMAnimator.h"

@interface MMAnimator()

@property (nonatomic ,copy) MMAnimatorAnimationBlock animations;
@property (nonatomic ,copy) MMAnimatorCompletionBlock completion;

@end
@implementation MMAnimator
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}
+ (instancetype) animator{
    return [[[self class] alloc] init];
}

- (instancetype) init{
    self = [super init];
    if (self) {
        self.duration(1.25f)
        .delay(0.0f)
        .options(UIViewAnimationOptionCurveEaseInOut);
    }
    return self;
}

- (id<MMAnimator>(^)(NSTimeInterval)) duration{
    return ^MMAnimator *(NSTimeInterval duration){
        _duration = duration;
        return self;
    };
}
- (id<MMAnimator>(^)(NSTimeInterval)) delay{
    return ^MMAnimator *(NSTimeInterval delay){
        _delay = delay;
        return self;
    };
}
- (id<MMAnimator>(^)(UIViewAnimationOptions)) options{
    return ^MMAnimator *(UIViewAnimationOptions options){
        _options = options;
        return self;
    };
}

- (id<MMAnimator>) animations:(MMAnimatorAnimationBlock)animations{
    self.animations = animations;
    return self;
}

- (id<MMAnimator>) completion:(MMAnimatorCompletionBlock)completion{
    self.completion = completion;
    return self;
}

- (void) animate{
    [UIView animateWithDuration:_duration delay:_delay options:_options
                     animations:self.animations completion:self.completion];
}
@end

@implementation MMSpringAnimator

- (instancetype) init{
    self = [super init];
    if (self) {
        self.dampingRatio(0.0f)
        .velocity(0.0f);
    }
    return self;
}

- (id<MMSpringAnimator>(^)(CGFloat)) dampingRatio{
    return ^MMSpringAnimator *(CGFloat dampingRatio){
        _dampingRatio = dampingRatio;
        return self;
    };
}
- (id<MMSpringAnimator>(^)(CGFloat)) velocity{
    return ^MMSpringAnimator *(CGFloat velocity){
        _velocity = velocity;
        return self;
    };
}
- (void) animate{
    
    [UIView animateWithDuration:_duration delay:_delay
         usingSpringWithDamping:_dampingRatio initialSpringVelocity:_velocity
                        options:_options animations:self.animations completion:self.completion];
}
@end

@implementation MMKeyframeAnimator

- (instancetype) init{
    self = [super init];
    if (self) {
        self.keyFrameOptions(UIViewKeyframeAnimationOptionCalculationModeLinear);
    }
    return self;
}

- (id<MMKeyframeAnimator>(^)(UIViewKeyframeAnimationOptions)) keyFrameOptions{
    return ^MMKeyframeAnimator *(UIViewKeyframeAnimationOptions options){
        __options = options;
        return self;
    };
}

- (void) animate{
    
    [UIView animateKeyframesWithDuration:_duration delay:_delay options:__options
                              animations:self.animations completion:self.completion];
}
@end

@implementation UIView (Animator)

+ (MMAnimator *) animator{
    return [MMAnimator animator];
}

+ (MMSpringAnimator *) springAnimator{
    return [MMSpringAnimator animator];
}

+ (MMKeyframeAnimator *) keyframeAnimator{
    return [MMKeyframeAnimator animator];
}
@end
