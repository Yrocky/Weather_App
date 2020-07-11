//
//  MMAnimationPromise.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMAnimatable.h"

NS_ASSUME_NONNULL_BEGIN

@class MMAnimationConfiguration;

@interface MMAnimationPromise : NSObject

- (instancetype) initWithView:(UIView<MMAnimatable>*)view;
- (MMAnimationPromise*(^)(NSTimeInterval)) delay;

- (MMAnimationPromise *) thenAnimation:(MMAnimationType *)animation config:(MMAnimationConfiguration *)config;
- (void) animationCompletiond;
- (void) completion:(MMAnimatableCompletion)completion;
@end

NS_ASSUME_NONNULL_END
