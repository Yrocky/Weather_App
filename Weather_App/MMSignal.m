//
//  MMSignal.m
//  FishDaily
//
//  Created by Rocky Young on 2018/8/21.
//  Copyright © 2018年 Rocky Young. All rights reserved.
//

#import "MMSignal.h"

@interface MMSignal ()

@end

static NSInteger nuber;

@implementation MMSignal

- (void)dealloc{
    NSLog(@"MMSignal dealloc");
}
- (instancetype)initWithValue:(id)value{
    self = [super init];
    if (self) {
        
        nuber = &array[2];
        
        NSLog(@"array:%d",&array[2]);
//        nuber = array[2];
        NSLog(@"nuber:%ld",(long)nuber);
        _value = value;
        _queue = dispatch_queue_create("com.swift.let.token", NULL);
        _subscribers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSInteger) subscriber:(void (^)(id value))subscriber{
    
    return [self subscribeNext:NO subscriber:subscriber];
}

- (NSInteger)subscribeNext:(BOOL)hasInitialValue subscriber:(void (^)(id value))subscriber{
    
    __block NSInteger token = 0;
    dispatch_sync(self.queue, ^{
        
        NSUInteger max = 0;
        for (NSNumber * number in self.subscribers.allKeys) {
            max = number.integerValue >= max ? number.integerValue : max;
        }
        token = max + 1;
        self.subscribers[@(token)] = subscriber;
        
        if (hasInitialValue && subscriber) {
            subscriber(self.value);
        }
    });
    return token;
}

- (void) unscrible:(NSInteger)token{
    dispatch_sync(self.queue, ^{
        self.subscribers[@(token)] = nil;
    });
}

- (NSInteger) bind:(MMSignal<id> *)signal{
    return [signal subscriber:^(id value) {
        [self update:value];
    }];
}

- (void) bindTo:(NSObject *)control forKeyPath:(NSString *)keyPath{
    [self subscribeNext:YES subscriber:^(id value) {
        [control setValue:value forKeyPath:keyPath];
    }];
}

- (void) unbind:(NSInteger)token{
    [self unscrible:token];
}

- (void)update:(id)newValue{
    dispatch_sync(self.queue, ^{
        _value = newValue;
        [self.subscribers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            void (^subscriber)(id) = obj;
            subscriber(newValue);
        }];
    });
}

- (id)peek{
    return self.value;
}

- (MMSignal *) map:(id(^)(id value))m{
    return [[MMSignal alloc] initWithValue:m(self.value)];
}

- (MMSignal<id>*) filter:(BOOL(^)(id value))f{
    if (f(self.value)) {
        return self;
    }
    return nil;
}
@end
