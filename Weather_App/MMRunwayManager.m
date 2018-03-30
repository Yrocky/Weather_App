//
//  MMRunwayManager.m
//  Weather_App
//
//  Created by user1 on 2018/3/28.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMRunwayManager.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>
#import <QuartzCore/QuartzCore.h>
#import "MMRunwayCoreView.h"

@interface _MMRunwayQueue : NSObject{
    NSMutableArray * _array;
}
@property (nonatomic ,assign) NSInteger maxLength;
- (NSInteger) length;
- (BOOL) isEmpty;
- (void) enqueue:(id)element;
- (id) dequeue;
- (id) fornt;
- (void) clear;
- (BOOL) isFull;
@end

@implementation _MMRunwayQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
        _maxLength = NSIntegerMax;
    }
    return self;
}
- (NSInteger) length{
    return _array.count;
}

- (BOOL) isEmpty{
    return self.length == 0;
}
- (void) enqueue:(id)element{
    if (element && !self.isFull) {
        [_array addObject:element];
    }
}

- (id) dequeue{
    
    if (self.isEmpty) {
        return nil;
    }
    id first = [self fornt];
    [_array removeObjectAtIndex:0];// O(n)
    return first;
}

- (id) fornt{
    if (self.isEmpty) {
        return nil;
    }
    return [_array firstObject];
}

- (void) clear{
    [_array removeAllObjects];
}

- (BOOL) isFull{
    return self.maxLength <= self.length;
}
@end

// 为了兼容多个跑道：普通跑道、超级跑道，将queue、cache的逻辑放到这里面，
// 在MMRunwayManager内根据业务需要添加对应的跑道管理类
// 对外暴露相应的接口即可
@interface _MMRunwayManagerCore: NSObject

@property (nonatomic ,strong) _MMRunwayQueue * queue;
@property (nonatomic ,strong) _MMRunwayQueue * cache;
@property (nonatomic ,assign) NSInteger maxQueueLength;
@property (nonatomic ,copy) void(^bSendOutModel)(id model);

// debug
- (NSString *) queueAndCacheInfo;

- (void) receiveSocketActionWith:(id)model;
- (void) completedRunwayViewDisplay;
- (void) removeAllRunwayData;
@end

@implementation _MMRunwayManagerCore
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[_MMRunwayQueue alloc] init];
        self.cache = [[_MMRunwayQueue alloc] init];
    }
    return self;
}

- (NSString *) queueAndCacheInfo{
    return [NSString stringWithFormat:@"queue<%ld>,cache<%ld>",(long)_queue.length,(long)_cache.length];
}

- (void)setMaxQueueLength:(NSInteger)maxQueueLength{
    _maxQueueLength = maxQueueLength;
    _queue.maxLength = maxQueueLength;
}

- (void)receiveSocketActionWith:(id)model{
    
    // 从socket接收到一条跑道信息，内部判断queue是否已经满了，
    if (!_queue.isFull) {
        
        // 如果没有满则加入到queue中
        [_queue enqueue:model];
        
        // 然后生成对应的singlelineview，并且将lineview发出去
        if (self.bSendOutModel) {
            self.bSendOutModel(model);
        }
    }else{
        // 如果已经满了，则将json加入到cache中，不生成对应的lineview
        [_cache enqueue:model];
    }
}

- (void)completedRunwayViewDisplay{
    
    [_queue dequeue];
    
    if (!_cache.isEmpty) {// 如果缓存中有数据
        
        id model = [_cache dequeue];
        [_queue enqueue:model];
        
        if (self.bSendOutModel) {
            self.bSendOutModel(model);
        }
    }
}
- (void) removeAllRunwayData{
    [_queue clear];
    [_cache clear];
}
@end

static MMRunwayManager *_sharedRunwayMgr = nil;

@interface MMRunwayManager()

@property (nonatomic ,strong) _MMRunwayManagerCore * normalRunway;// 普通跑道
@property (nonatomic ,strong) _MMRunwayManagerCore * proRunway;// 超级跑道

@end

@implementation MMRunwayManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak __typeof(&*self)weakSelf = self;
        self.normalRunway = [[_MMRunwayManagerCore alloc] init];
        self.normalRunway.maxQueueLength = 3;
        self.normalRunway.bSendOutModel = ^(id model) {
            [weakSelf _createNormalSingleLineViewAndSendItOutWith:model];
        };
        
        self.proRunway = [[_MMRunwayManagerCore alloc] init];
        self.proRunway.maxQueueLength = 1;
        self.proRunway.bSendOutModel = ^(id model) {
          [weakSelf _createProSingleLineViewAndSendItOutWith:model];
        };
        
    }
    return self;
}

+ (instancetype)runwayManager{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void) normalRunwayReceiveSocketAction:(id)model{
    [self.normalRunway receiveSocketActionWith:model];
}
- (void) normalRunwayCompletedOneSingleLineViewDisplay{
    [self.normalRunway completedRunwayViewDisplay];
}
- (void) normalRunwayRemoveAllData{
    [self.normalRunway removeAllRunwayData];
}

- (void) proRunwayReceiveSocketAction:(id)model{
    [self.proRunway receiveSocketActionWith:model];
}
- (void) proRunwayCompletedOneSingleLineViewDisplay{
    [self.proRunway completedRunwayViewDisplay];
}
- (void) proRunwayRemoveAllData{
    [self.proRunway removeAllRunwayData];
}
- (void) removeAllRunwayData{
    [self normalRunwayRemoveAllData];
    [self proRunwayRemoveAllData];
}

- (void) _createNormalSingleLineViewAndSendItOutWith:(id)model{
    
    if (self.bRunwayGenerateNormalSingleLineView) {
        UIView * singleLineView = self.bRunwayGenerateNormalSingleLineView(model);
        if (self.delegate && [self.delegate respondsToSelector:@selector(runwayManager:didSendNormalSingleLineView:)]) {
            [self.delegate runwayManager:self didSendNormalSingleLineView:singleLineView];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:MMRunwayManagerSendNormalSingleLineViewNotification
                                                                object:singleLineView];
        }
    }
}
- (void) _createProSingleLineViewAndSendItOutWith:(id)model{
    
    if (self.bRunwayGenerateProSingleLineView) {
        
        UIView * singleLineView = self.bRunwayGenerateProSingleLineView(model);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(runwayManager:didSendProSingleLineView:)]) {
            [self.delegate runwayManager:self didSendProSingleLineView:singleLineView];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:MMRunwayManagerSendNormalProSingleLineViewNotification
                                                                object:singleLineView];
        }
    }
}

- (NSString *) queueAndCacheInfo{

    return [NSString stringWithFormat:@"noemal:%@\npro:%@",_normalRunway.queueAndCacheInfo,_proRunway.queueAndCacheInfo];
}
@end
