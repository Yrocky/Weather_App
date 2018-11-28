//
//  MMAnimationConfiguration.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMAnimationTimingFunctionType;
NS_ASSUME_NONNULL_BEGIN

@interface MMAnimationConfiguration : NSObject

@property (nonatomic ,assign ,readonly) CGFloat dampingValue;///<0.7
@property (nonatomic ,assign ,readonly) CGFloat velocityValue;///<0.7
@property (nonatomic ,assign ,readonly) NSTimeInterval durationValue;///<0.7
@property (nonatomic ,assign ,readonly) NSTimeInterval delayValue;///<0
@property (nonatomic ,assign ,readonly) CGFloat forceValue;///<摩擦系数:1
@property (nonatomic ,strong ,readonly) CAMediaTimingFunction * timingFunctionValue;

- (MMAnimationConfiguration*(^)(CGFloat)) damping;
- (MMAnimationConfiguration*(^)(CGFloat)) velocity;
- (MMAnimationConfiguration*(^)(NSTimeInterval)) duration;
- (MMAnimationConfiguration*(^)(NSTimeInterval)) delay;
- (MMAnimationConfiguration*(^)(CGFloat)) force;
- (MMAnimationConfiguration*(^)(CAMediaTimingFunction *)) timingFunction;

- (UIViewAnimationOptions) options;
@end

NS_ASSUME_NONNULL_END
