//
//  MMViewModel.m
//  FishDaily
//
//  Created by Rocky Young on 2018/8/21.
//  Copyright © 2018年 Rocky Young. All rights reserved.
//

#import "MMViewModel.h"
#import "NSArray+Sugar.h"

// 模拟服务器端的数据
static NSMutableArray<MMTodoItem *> * items;

@implementation MMViewModel

- (void)dealloc{
    NSLog(@"MMViewModel dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.todos = [[MMSignal alloc] initWithValue:@[]];
        self.finisheds = [[MMSignal alloc] initWithValue:@[]];
        items = [NSMutableArray array];
        [self addTodo:@"default" complete:nil];
    }
    return self;
}
- (NSInteger) todoCount{
    return self.todos.peek.count;
}

- (NSInteger) finishedTodoCount{
    return self.finisheds.peek.count;
}

- (void) updateTodo{
    
    // 模拟网络请求，1秒后更新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.todos update:[items filter:^BOOL(MMTodoItem *obj) {
            return NO == obj.isFinished.peek.boolValue;
        }]];
        
        [self.finisheds update:[items filter:^BOOL(MMTodoItem *obj) {
            return YES == obj.isFinished.peek.boolValue;
        }]];
    });
}

- (void)addTodo:(NSString *)name complete:(void (^)(BOOL))cb{
    
    // 模拟网络请求，1秒后更新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [items addObject:[MMTodoItem item:NO name:name]];
        [self updateTodo];
    });
}

- (void) checkTodo:(NSUInteger)index finished:(BOOL)finished{
    
    NSArray<MMTodoItem *> *source;
    if (YES == finished) {// todo->finished
        source = self.todos.peek;
    }else{// finished->todo
        source = self.finisheds.peek;
    }
    if (index >= source.count) {
        return;
    }
    MMTodoItem * changedStatusItem = source[index];
    [changedStatusItem.isFinished update:@(finished)];
    
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTodo];
    });
}

- (void) deleteTodo:(NSUInteger)index{
    if (index < self.todos.peek.count) {
        [items removeObject:self.todos.peek[index]];
        [self updateTodo];
    }
}

- (void) deleteFinished:(NSUInteger)index{
    if (index < self.finisheds.peek.count) {
        [items removeObject:self.finisheds.peek[index]];
        [self updateTodo];
    }
}
@end

@implementation MMTodoItem
+ (instancetype) item:(BOOL)finished name:(NSString *)name{
    MMTodoItem * item = [[MMTodoItem alloc] init];
    item.isFinished = [[MMSignal alloc] initWithValue:@(finished)];
    item.name = [[MMSignal alloc] initWithValue:name];
    return item;
}
- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ : %d", [self name].peek, self.isFinished.peek.boolValue];
}
- (NSString *)description{
    return [self debugDescription];
}
@end
