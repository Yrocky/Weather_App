//
//  MMNoRetainTimer.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/11.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMTimerWrap<T> : NSObject

+ (instancetype) timerWith:(id)target;

- (MMTimerWrap *(^)(NSTimeInterval)) interval;
- (MMTimerWrap *(^)(SEL)) selector;
- (MMTimerWrap *(^)(BOOL)) repeats;
- (MMTimerWrap *(^)(T)) userInfo;
@end

// 这里使用泛型貌似没啥用，因为在selector方法中还需要在声明一下
@interface MMNoRetainTimer<T> : NSObject{
    NSTimeInterval _intervalValue;
    id _userInfo;
    NSTimer *_timer;
    __weak id _target;
    SEL _selector;
    BOOL _repeats;
    BOOL _isPause;
}
@property (nonatomic ,assign ,readonly) BOOL isPause;
@property (nonatomic ,assign ,readonly) SEL selector;
@property (nonatomic ,weak ,readonly) id target;
@property (strong, nonatomic ,readonly ,nullable) T userInfo;

+ (MMNoRetainTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                              target:(id)target
                                            selector:(SEL)selector
                                            userInfo:(nullable T)userInfo
                                             repeats:(BOOL)repeats;

+ (MMNoRetainTimer *) timerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)target
                                   selector:(SEL)selector
                                   userInfo:(nullable T)userInfo
                                    repeats:(BOOL)repeats;

+ (MMNoRetainTimer *) scheduledTimerWith:(MMTimerWrap<T> *)timerWrap;
+ (MMNoRetainTimer *) timerWith:(MMTimerWrap<T> *)timerWrap;

- (void) pause;
- (void) restart;

- (void) invalidate;

@end

NS_ASSUME_NONNULL_END
