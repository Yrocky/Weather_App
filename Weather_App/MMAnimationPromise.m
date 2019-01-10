//
//  MMAnimationPromise.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimationPromise.h"
#import "MMAnimationConfiguration.h"
#import "MMAnimatable.h"

@interface MMAnimationPromise ()

@property (nonatomic ,strong) UIView<MMAnimatable> * view;
@property (nonatomic ,assign) CGFloat delayForNextAnimation;
@property (nonatomic ,strong) NSMutableArray * animationList;
@property (nonatomic ,copy) MMAnimatableCompletion completion;
@end

@implementation MMAnimationPromise

- (instancetype)initWithView:(UIView<MMAnimatable> *)view{
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (void) animationCompletiond{
    if (self.animationList.count) {
        [self.animationList removeObjectAtIndex:0];
        if (self.animationList.count) {
            //            view.doAnimation(currentAnimation.type, configuration: currentAnimation.configuration, promise: self)
        }else if (self.completion){
            self.completion();
        }
    }
}
- (void) completion:(MMAnimatableCompletion)completion{
    self.completion = completion;
}

- (MMAnimationPromise *) thenAnimationWith:(MMAnimationConfiguration *)config{
    
    
    if (self.animationList.count == 1) {
        //        view.doAnimation(animation, configuration: animTuple.configuration, promise: self)
    }
    self.delayForNextAnimation = 0.0;
    return self;
}

- (MMAnimationPromise*(^)(NSTimeInterval)) delay{
    return ^MMAnimationPromise* (NSTimeInterval delay) {
        self.delayForNextAnimation = delay;
        return self;
    };
}
@end

