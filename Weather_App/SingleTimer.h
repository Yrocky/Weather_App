//
//  SingleTimer.h
//  Weather_App
//
//  Created by rocky on 2021/1/18.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TimerObserver <NSObject>

- (NSString *) uniqueId;

@optional
- (void) onTimer;
@end

@interface SingleTimer : NSObject

- (instancetype) initWithInterval:(NSTimeInterval)intervalValue;

- (void) addTimerObserver:(id<TimerObserver>)observer;
- (void) removeTimerObserver:(id<TimerObserver>)observer;
@end

NS_ASSUME_NONNULL_END
