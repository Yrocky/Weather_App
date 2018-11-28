//
//  MMAnimatable.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class MMAnimationConfiguration;
@class MMAnimationPromise;
@class MMAnimationType;

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

- (MMAnimationPromise *) animateWith:(MMAnimationConfiguration *)config;
- (MMAnimationPromise *) delay:(NSTimeInterval)delay;
- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
             promise:(MMAnimationPromise *)promise;
- (void) autoRunAnimation;

@end


@interface UIView (MMAnimatable)

- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
          completion:(MMAnimatableCompletion)completion;

//- (void) slideAnimation:()
//func slide(_ way: AnimationType.Way,
//           direction: AnimationType.Direction,
//           configuration: AnimationConfiguration,
//           completion: AnimatableCompletion? = nil) {
//    let values = computeValues(way: way, direction: direction, configuration: configuration, shouldScale: false)
//    switch way {
//    case .in:
//        animateIn(animationValues: values, alpha: 1, configuration: configuration, completion: completion)
//    case .out:
//        animateOut(animationValues: values, alpha: 1, configuration: configuration, completion: completion)
//    }
//}
@end
NS_ASSUME_NONNULL_END
