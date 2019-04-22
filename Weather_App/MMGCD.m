//
//  MMGCD.m
//  Weather_App
//
//  Created by user1 on 2017/10/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGCD.h"

#pragma mark - GCD 关于队列的封装

static MMGCDQueue *mainQueue;
static MMGCDQueue *globalQueue;
static MMGCDQueue *highPriorityGlobalQueue;
static MMGCDQueue *lowPriorityGlobalQueue;
static MMGCDQueue *backgroundPriorityGlobalQueue;

@interface MMGCDQueue ()

@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;

@end

@implementation MMGCDQueue

+ (MMGCDQueue *)mainQueue {
    
    return mainQueue;
}

+ (MMGCDQueue *)globalQueue {
    
    return globalQueue;
}

+ (MMGCDQueue *)highPriorityGlobalQueue {
    
    return highPriorityGlobalQueue;
}

+ (MMGCDQueue *)lowPriorityGlobalQueue {
    
    return lowPriorityGlobalQueue;
}

+ (MMGCDQueue *)backgroundPriorityGlobalQueue {
    
    return backgroundPriorityGlobalQueue;
}

#pragma mark 初始化
// 该方法会在程序首次使用该类 之前 调用，并且只调用一次。他是运行期间有system调用的，不要自己调用！！
+ (void)initialize {
    
    if (self == [MMGCDQueue self])  {
        
        mainQueue                     = [MMGCDQueue new];
        globalQueue                   = [MMGCDQueue new];
        highPriorityGlobalQueue       = [MMGCDQueue new];
        lowPriorityGlobalQueue        = [MMGCDQueue new];
        backgroundPriorityGlobalQueue = [MMGCDQueue new];
        
        mainQueue.dispatchQueue                     = dispatch_get_main_queue();
        globalQueue.dispatchQueue                   = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        highPriorityGlobalQueue.dispatchQueue       = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        lowPriorityGlobalQueue.dispatchQueue        = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        backgroundPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
}
// 默认是串行队列
- (instancetype)init {
    
    return [self initSerial];
}

- (instancetype)initSerial {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (instancetype)initSerialWithLabel:(NSString *)label {
    
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (instancetype)initConcurrent {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (instancetype)initConcurrentWithLabel:(NSString *)label {
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark 操作

- (void)execute:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), self.dispatchQueue, block);
}

- (void)suspend {
    
    dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
    
    dispatch_resume(self.dispatchQueue);
}

#pragma mark 关于Group

- (void)execute:(dispatch_block_t)block inGroup:(MMGCDGroup *)group {
    
    NSParameterAssert(block);
    [group enter];
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)notify:(dispatch_block_t)block inGroup:(MMGCDGroup *)group {
    
    NSParameterAssert(block);
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}


@end

#pragma mark - GCD 关于group的封装

@interface MMGCDGroup ()

@property (strong, nonatomic, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation MMGCDGroup

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchGroup = dispatch_group_create();
    }
    
    return self;
}

- (void)execute:(dispatch_block_t)block{
    
    [self enter];
    if (block) {
        block();
    }
}

- (void)enter {
    
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end

