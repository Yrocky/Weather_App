//
//  SingleTimer.m
//  Weather_App
//
//  Created by rocky on 2021/1/18.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import "SingleTimer.h"
#import <objc/runtime.h>
#include <pthread.h>

@protocol _TimerTokenAble <NSObject>
- (void)dispose;
@end

@interface _TimerDisposeBag : NSObject
- (NSMutableArray<id<_TimerTokenAble>> *)tokens;
- (void)addToken:(id<_TimerTokenAble>)token;
@end

@interface _TimerToken : NSObject<_TimerTokenAble>

@property (nonatomic ,copy) void(^onDispose)(NSString * uniqueId);

- (instancetype) initWithKey:(NSString *)uniqueId;

@end

@interface _TimerObserver : NSObject
@property (nonatomic ,weak) NSObject<TimerObserver> * object;
@end

@interface NSObject (SingleTimer)
@property (nonatomic ,strong ,readonly) _TimerDisposeBag * disposeBag;
@end

@interface _SingleInnerTimer : NSObject{
    NSTimeInterval _intervalValue;
    id _userInfo;
    NSTimer *_timer;
    __weak id _target;
    SEL _selector;
    BOOL _repeats;
    BOOL _isPause;
}

+ (_SingleInnerTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                target:(id)target
                                              selector:(SEL)selector
                                              userInfo:(nullable id)userInfo
                                               repeats:(BOOL)repeats;
- (void) pause;
- (void) restart;
- (void) invalidate;
@end

@interface _TimerCollection : NSObject{
    pthread_mutex_t _accessLock;
}
@property (nonatomic ,strong) NSMutableDictionary<NSString*, _TimerObserver*> *timerObserverStorage;
- (BOOL) containsObserverForKey:(NSString *)key;
- (void) addObserver:(_TimerObserver *)observer forKey:(NSString *)key;
- (BOOL) removeObserverForKey:(NSString *)key;
- (NSArray<_TimerObserver *> *) allObserves;
@end

@implementation SingleTimer{
    _SingleInnerTimer *_timer;
    BOOL _observerDidChange;
    _TimerCollection *_collection;
}

- (void)dealloc{
    NSLog(@"SingleTimer dealloc");
}

- (instancetype) init{
    return [self initWithInterval:1];
}

- (instancetype) initWithInterval:(NSTimeInterval)intervalValue{
    self = [super init];
    if (self) {
        // timer
        _timer = [_SingleInnerTimer scheduledTimerWithTimeInterval:intervalValue target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [_timer pause];
        
        // storage
        _collection = [_TimerCollection new];
    }
    return self;
}

- (void) pause{
    [_timer pause];
}

- (void) restart{
    [_timer restart];
}

- (void) invalidate{
    [_timer invalidate];
}

- (void) addTimerObserver:(id<TimerObserver>)observer{
    
    NSString * key = [NSString stringWithFormat:@"%@_%@",observer.class, observer.uniqueId];

    if ([_collection containsObserverForKey:key]) {
        return;
    }
    if (_collection.allObserves.count == 0) {
        [self restart];
    }
    __weak typeof(self) weakSelf = self;

    __block _TimerObserver * innerObserver = [_TimerObserver new];
    innerObserver.object = observer;
    
    _TimerToken * token = [[_TimerToken alloc] initWithKey:key];
    token.onDispose = ^(NSString *uniqueId) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf removeObserverForKey:uniqueId];
    };
    [innerObserver.object.disposeBag addToken:token];
    [_collection addObserver:innerObserver forKey:key];
}

- (void) removeTimerObserver:(id<TimerObserver>)observer{
    NSLog(@"remove observer");
    NSString * key = [NSString stringWithFormat:@"%@_%@",observer.class, observer.uniqueId];
    [self removeObserverForKey:key];
}

- (void) removeObserverForKey:(NSString *)key{
    [_collection removeObserverForKey:key];
    if (_collection.allObserves.count == 0) {
        [self pause];
    }
}

- (void) onTimer:(_SingleInnerTimer *)timer{

    NSArray<_TimerObserver *> * allObserves = [_collection allObserves];
    [allObserves enumerateObjectsUsingBlock:^(_TimerObserver * observer, NSUInteger idx, BOOL * _Nonnull stop) {
        [observer.object onTimer];
    }];
}

@end

@implementation _SingleInnerTimer

+ (_SingleInnerTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                              target:(id)target
                                            selector:(SEL)selector
                                            userInfo:(nullable id)userInfo
                                             repeats:(BOOL)repeats{
    _SingleInnerTimer * timer = [_SingleInnerTimer new];
    [timer scheduledTimerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats];
    return timer;
}

- (void) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                 target:(id)target
                               selector:(SEL)selector
                               userInfo:(id)userInfo
                                repeats:(BOOL)repeats{
    _intervalValue = interval;
    _repeats = repeats;
    _target = target;
    _selector = selector;
    _userInfo = userInfo;
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:userInfo
                                             repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];//UITrackingRunLoopMode
}

- (void) timerWithTimeInterval:(NSTimeInterval)interval
                        target:(id)target
                      selector:(SEL)selector
                      userInfo:(id)userInfo
                       repeats:(BOOL)repeats{
    _intervalValue = interval;
    _repeats = repeats;
    _target = target;
    _selector = selector;
    _userInfo = userInfo;
    _timer = [NSTimer timerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:userInfo
                                    repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void) onTimer:(NSTimer *)timer{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (_selector && [_target respondsToSelector:_selector]) {// for safe
        [_target performSelector:_selector withObject:self];
    }
#pragma clang diagnostic pop
}

- (void) pause{
    NSLog(@"[Timer] pause");
    [self invalidate];
    _timer = nil;
    _isPause = YES;
}

- (void) restart{
    NSLog(@"[Timer] restart");
    if (_isPause) {
        [self scheduledTimerWithTimeInterval:_intervalValue
                                      target:_target
                                    selector:_selector
                                    userInfo:_userInfo
                                     repeats:_repeats];
        _isPause = NO;
    }
}

- (void) invalidate{
    [_timer invalidate];
}

@end

@implementation _TimerToken{
    NSString *_uniqueId;
    BOOL _isDisposed;
}

- (instancetype)initWithKey:(NSString *)uniqueId{
    if (self = [super init]) {
        _uniqueId = uniqueId;
        _isDisposed = NO;
    }
    return self;
}

- (void)dispose{
    @synchronized(self){
        if (_isDisposed) {
            return;
        }
        _isDisposed = YES;
    }
    if (self.onDispose) {
        self.onDispose(_uniqueId);
    }
}
@end

@implementation _TimerDisposeBag{
    NSMutableArray<id<_TimerTokenAble>> *_tokens;
}

- (NSMutableArray<id<_TimerTokenAble>> *)tokens{
    if (!_tokens) {
        _tokens = [[NSMutableArray alloc] init];
    }
    return _tokens;
}

- (void)addToken:(id<_TimerTokenAble>)token{
    @synchronized(self) {
        [self.tokens addObject:token];
    }
}

- (void)dealloc{
    @synchronized(self) {
        for (id<_TimerTokenAble> token in self.tokens) {
            if ([token respondsToSelector:@selector(dispose)]) {
                [token dispose];
            }
        }
    }
}
@end

@implementation _TimerObserver

@end

@implementation _TimerCollection

- (instancetype)init{
    if (self = [super init]) {
        _timerObserverStorage = [[NSMutableDictionary alloc] init];
        pthread_mutex_init(&_accessLock, NULL);
    }
    return self;
}

- (void)lockAndDo:(void(^)(void))block{
    @try{
        pthread_mutex_lock(&_accessLock);
        block();
    }@finally{
        pthread_mutex_unlock(&_accessLock);
    }
}

- (id)lockAndFetch:(id(^)(void))block{
    id result;
    @try{
        pthread_mutex_lock(&_accessLock);
        result = block();
    }@finally{
        pthread_mutex_unlock(&_accessLock);
    }
    return result;
}

- (BOOL) containsObserverForKey:(NSString *)key{
    __block BOOL contains = NO;
    __weak typeof(self) weakSelf = self;

    [self lockAndDo:^{
        __strong typeof(self) strongSelf = weakSelf;
        
        contains = [strongSelf.timerObserverStorage.allKeys containsObject:key];
    }];
    return contains;
}

- (void)addObserver:(_TimerObserver *)observer forKey:(NSString *)key{

    __weak typeof(self) weakSelf = self;

    [self lockAndDo:^{
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf.timerObserverStorage setObject:observer forKey:key];
    }];
}

- (BOOL)removeObserverForKey:(NSString *)key{

    __weak typeof(self) weakSelf = self;

    NSNumber * result = [self lockAndFetch:^id{
        __strong typeof(self) strongSelf = weakSelf;
       
        if ([strongSelf.timerObserverStorage.allKeys containsObject:key]) {
            [strongSelf.timerObserverStorage removeObjectForKey:key];
            return @(YES);
        }
        return @(NO);
    }];
    return result.boolValue;
}

- (NSArray<_TimerObserver *> *) allObserves{
    __block NSArray * result;
    __weak typeof(self) weakSelf = self;

    [self lockAndDo:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        result = [strongSelf.timerObserverStorage allValues];
    }];
    return result;
}
@end

static const char single_timer_dispose_bag_context;

@implementation NSObject (SingleTimer)

- (_TimerDisposeBag *)disposeBag{
    _TimerDisposeBag * bag = objc_getAssociatedObject(self, &single_timer_dispose_bag_context);
    if (!bag) {
        bag = [[_TimerDisposeBag alloc] init];
        objc_setAssociatedObject(self, &single_timer_dispose_bag_context, bag, OBJC_ASSOCIATION_RETAIN);
    }
    return bag;
}
@end
