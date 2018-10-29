//
//  MMSignal.h
//  FishDaily
//
//  Created by Rocky Young on 2018/8/21.
//  Copyright © 2018年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MMSignalWith(_object_) ([[MMSignal alloc] initWithValue:_object_])
#define MMEmptySignal ([[MMSignal alloc] initWithValue:nil])

@interface MMSignal<ObjectType> : NSObject{
    NSMutableDictionary <NSNumber *,void(^)(ObjectType value)>* _subscribers;
}

@property (nonatomic ,strong ,readonly) ObjectType value;
@property (nonatomic ,strong) dispatch_queue_t queue;
@property (nonatomic ,strong ,readonly) NSMutableDictionary <NSNumber *,void(^)(ObjectType value)>* subscribers;

- (instancetype)initWithValue:(ObjectType)value;

- (NSInteger) subscriber:(void (^)(ObjectType value))subscriber;
- (void) unscrible:(NSInteger)token;

- (NSInteger) bind:(MMSignal<ObjectType> *)signal;
- (void) bindTo:(NSObject *)control forKeyPath:(NSString *)keyPath;
- (void) unbind:(NSInteger)token;

- (void) update:(ObjectType)newValue;
- (ObjectType) peek;

- (MMSignal *) map:(id(^)(ObjectType value))m;
- (MMSignal<ObjectType> *) filter:(BOOL(^)(ObjectType value))f;
@end
static int *arr = NULL;
static int *array[178] = {2};

