//
//  MMNoRetainTimer.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/11.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMNoRetainTimer.h"

@interface MMTimerWrap ()
@property (nonatomic ,assign ,readwrite) NSTimeInterval intervalValue;
@property (nonatomic ,assign ,readwrite) SEL selectorValue;
@property (nonatomic ,assign ,readwrite) BOOL repeatsValue;
@property (nonatomic ,strong ,readwrite) id userInfoValue;
@property (nonatomic ,strong ,readwrite) id target;
@end

@implementation MMNoRetainTimer

- (void)dealloc{
    NSLog(@"%@ dealloc",self);
}

+ (MMNoRetainTimer *) scheduledTimerWith:(MMTimerWrap *)timerWrap{
    return [self scheduledTimerWithTimeInterval:timerWrap.intervalValue
                                         target:timerWrap.target
                                       selector:timerWrap.selectorValue
                                       userInfo:timerWrap.userInfoValue
                                        repeats:timerWrap.repeatsValue];
}

+ (MMNoRetainTimer *) timerWith:(MMTimerWrap *)timerWrap{
    return [self timerWithTimeInterval:timerWrap.intervalValue
                                target:timerWrap.target
                              selector:timerWrap.selectorValue
                              userInfo:timerWrap.userInfoValue
                               repeats:timerWrap.repeatsValue];
}

+ (MMNoRetainTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                              target:(id)target
                                            selector:(SEL)selector
                                            userInfo:(id)userInfo
                                             repeats:(BOOL)repeats{
    MMNoRetainTimer * timer = [MMNoRetainTimer new];
    [timer scheduledTimerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats];
    return timer;
}

+ (MMNoRetainTimer *) timerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)target
                                   selector:(SEL)selector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats{
    MMNoRetainTimer * timer = [MMNoRetainTimer new];
    [timer timerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats];
    return timer;
}

- (void) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                 target:(id)target
                               selector:(SEL)selector
                               userInfo:(id)userInfo
                                repeats:(BOOL)repeats{
    _target = target;
    _selector = selector;
    _userInfo = userInfo;
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:userInfo
                                             repeats:repeats];
}

- (void) timerWithTimeInterval:(NSTimeInterval)interval
                        target:(id)target
                      selector:(SEL)selector
                      userInfo:(id)userInfo
                       repeats:(BOOL)repeats{
    
    _target = target;
    _selector = selector;
    _userInfo = userInfo;
    _timer = [NSTimer timerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:userInfo
                                    repeats:repeats];
}

- (void) onTimer:(NSTimer *)timer{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (self.selector && [self.target respondsToSelector:self.selector]) {// for safe
        [self.target performSelector:self.selector withObject:self];
    }
#pragma clang diagnostic pop
}

- (void) invalidate{
    [_timer invalidate];
}
@end

@implementation MMTimerWrap

+ (instancetype)timerWith:(id)target{
    
    MMTimerWrap * _self = [MMTimerWrap new];
    _self.target = target;
    _self.interval(0).repeats(NO);
    return _self;
}

- (MMTimerWrap * _Nonnull (^)(NSTimeInterval))interval{
    return ^MMTimerWrap *(NSTimeInterval interval){
        self.intervalValue = interval;
        return self;
    };
}
- (MMTimerWrap * _Nonnull (^)(SEL _Nonnull))selector{
    return ^MMTimerWrap *(SEL selector){
        self.selectorValue = selector;
        return self;
    };
}
- (MMTimerWrap * _Nonnull (^)(BOOL)) repeats{
    return ^MMTimerWrap *(BOOL repeats){
        self.repeatsValue = repeats;
        return self;
    };
}
- (MMTimerWrap * _Nonnull (^)(id _Nonnull))userInfo{
    return ^MMTimerWrap *(id userInfo){
        self.userInfoValue = userInfo;
        return self;
    };
}
@end