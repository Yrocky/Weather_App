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

@interface MMAnimationTuple : NSObject{
    MMAnimationType * _type;
    MMAnimationConfiguration * _configuration;
}
@property (nonatomic ,strong ,readonly) MMAnimationType * type;
@property (nonatomic ,strong ,readonly) MMAnimationConfiguration * configuration;
+ (instancetype) tupleWith:(MMAnimationType *)type configuration:(MMAnimationConfiguration *)configuration;
@end
@implementation MMAnimationTuple
+ (instancetype) tupleWith:(MMAnimationType *)type configuration:(MMAnimationConfiguration *)configuration{
    return [[MMAnimationTuple alloc] initWith:type configuration:configuration];
}
- (instancetype) initWith:(MMAnimationType *)type configuration:(MMAnimationConfiguration *)configuration{
    self = [super init];
    if (self) {
        _type = type;
        _configuration = configuration;
    }
    return self;
}
@end

@interface MMAnimationPromise ()

@property (nonatomic ,strong) UIView<MMAnimatable> * view;
@property (nonatomic ,assign) CGFloat delayForNextAnimation;
@property (nonatomic ,strong) NSMutableArray<MMAnimationTuple *> * animationList;
@property (nonatomic ,copy) MMAnimatableCompletion completion;
@end

@implementation MMAnimationPromise

- (instancetype)initWithView:(UIView<MMAnimatable> *)view{
    self = [super init];
    if (self) {
        self.view = view;
        self.animationList = [@[] mutableCopy];
    }
    return self;
}

- (void) animationCompletiond{
    if (self.animationList.count) {
        [self.animationList removeObjectAtIndex:0];
        if (self.animationList.count) {
            MMAnimationTuple * currentAnimation = self.animationList.firstObject;
            [self.view doAnimation:currentAnimation.type
                     configuration:currentAnimation.configuration
                           promise:self];
        }else if (self.completion){
            self.completion();
        }
    }
}
- (void) completion:(MMAnimatableCompletion)completion{
    self.completion = completion;
}

- (MMAnimationPromise *) thenAnimation:(MMAnimationType *)animation config:(MMAnimationConfiguration *)config{
    
    MMAnimationTuple * tuple = [MMAnimationTuple tupleWith:animation configuration:config];
    [self.animationList addObject:tuple];
    if (self.animationList.count == 1) {
        [self.view doAnimation:animation configuration:config promise:self];
    }
    self.delayForNextAnimation = 0.0;
    return self;
}

- (MMAnimationPromise *) thenAnimationWith:(MMAnimationConfiguration *)config{
    
    MMAnimationTuple * tuple = [MMAnimationTuple tupleWith:nil configuration:nil];
    [self.animationList addObject:tuple];
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

