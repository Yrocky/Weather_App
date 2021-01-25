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
    __weak id _target;
    SEL _selector;
    BOOL _repeats;
    BOOL _isPause;
}

@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                 target:(id)target
                               selector:(SEL)selector
                               userInfo:(id)userInfo
                                repeats:(BOOL)repeats{
    _target = target;
    _selector = selector;
    BOOL async = NO;
    uint64_t intervalInNanoSecs = (uint64_t)(interval * NSEC_PER_SEC);
    uint64_t leewayInNanoSecs = (uint64_t)(0.0 * NSEC_PER_SEC);

    dispatch_queue_t queue = async ? dispatch_queue_create("com.single.timer", DISPATCH_QUEUE_CONCURRENT) : dispatch_get_main_queue();

    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, [self.class wallTimeWithDate:[NSDate dateWithTimeIntervalSinceNow:interval]], intervalInNanoSecs, leewayInNanoSecs);
    dispatch_source_set_event_handler(self.timer, ^{
        [self onTimer:nil];
        if (!repeats) {
            [self invalidate];
        }
    });
    dispatch_resume(self.timer);
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
//    [self invalidate];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_suspend(self.timer);
    }
    dispatch_semaphore_signal(self.semaphore);
    
    _isPause = YES;
}

- (void) restart{
    NSLog(@"[Timer] restart");
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_resume(self.timer);
    }
    dispatch_semaphore_signal(self.semaphore);
    
    _isPause = NO;
}

- (void) invalidate{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_semaphore_signal(self.semaphore);
}

+ (dispatch_time_t)wallTimeWithDate:(NSDate *)date {
    NSCParameterAssert(date != nil);

    double seconds = 0;
    double frac = modf(date.timeIntervalSince1970, &seconds);

    struct timespec walltime = {
        .tv_sec = (time_t)fmin(fmax(seconds, LONG_MIN), LONG_MAX),
        .tv_nsec = (long)fmin(fmax(frac * NSEC_PER_SEC, LONG_MIN), LONG_MAX)
    };

    return dispatch_walltime(&walltime, 0);
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
