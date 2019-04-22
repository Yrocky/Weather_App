//
//  MMAnimatable.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMAnimationConfiguration.h"
#import "MMAnimationType.h"

NS_ASSUME_NONNULL_BEGIN

@class MMAnimationPromise;

typedef void(^MMAnimatableCompletion)();
typedef void(^MMAnimatableExecution)();

@protocol MMAnimatable <NSObject>

@optional
@property (nonatomic ,assign) NSUInteger animationType;
@property (nonatomic ,assign) BOOL autoRun;
@property (nonatomic ,assign) NSTimeInterval duration;
@property (nonatomic ,assign) NSTimeInterval delay;
@property (nonatomic ,assign) CGFloat damping;
@property (nonatomic ,assign) CGFloat velocity;
@property (nonatomic ,assign) CGFloat force;
@property (nonatomic ,assign) NSUInteger timingFunction;

- (MMAnimationPromise *) animationWith:(MMAnimationType *)animationType
                         configuration:(MMAnimationConfiguration *)config;
- (MMAnimationPromise *) delay:(NSTimeInterval)delay;
- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
             promise:(MMAnimationPromise *)promise;
- (void) autoRunAnimation;

@end


@interface UIView (MMAnimatable)<MMAnimatable>

- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
          completion:(MMAnimatableCompletion)completion;
@end

NS_ASSUME_NONNULL_END
