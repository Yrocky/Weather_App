//
//  MMGCD.h
//  Weather_App
//
//  Created by user1 on 2017/10/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - GCD 关于group的封装

@interface MMGCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

- (void)execute:(dispatch_block_t)block;
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end

#pragma mark - GCD 关于队列的封装

@interface MMGCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (MMGCDQueue *)mainQueue;
+ (MMGCDQueue *)globalQueue;
+ (MMGCDQueue *)highPriorityGlobalQueue;
+ (MMGCDQueue *)lowPriorityGlobalQueue;
+ (MMGCDQueue *)backgroundPriorityGlobalQueue;

- (instancetype)initSerial;
- (instancetype)initSerialWithLabel:(NSString *)label;
- (instancetype)initConcurrent;
- (instancetype)initConcurrentWithLabel:(NSString *)label;

- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;
- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta;
- (void)suspend;
- (void)resume;

- (void)execute:(dispatch_block_t)block inGroup:(MMGCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(MMGCDGroup *)group;

@end
