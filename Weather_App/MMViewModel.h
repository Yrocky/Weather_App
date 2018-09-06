//
//  MMViewModel.h
//  FishDaily
//
//  Created by Rocky Young on 2018/8/21.
//  Copyright © 2018年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSignal.h"

@interface MMTodoItem : NSObject
@property (nonatomic ,strong) MMSignal<NSNumber *> *isFinished;
@property (nonatomic ,strong) MMSignal<NSString *> *name;
+ (instancetype) item:(BOOL)finished name:(NSString *)name;
@end

@interface MMViewModel : NSObject
@property (nonatomic ,strong) MMSignal<NSArray<MMTodoItem *> *> *todos;
@property (nonatomic ,strong) MMSignal<NSArray<MMTodoItem *> *> *finisheds;
@property (nonatomic ,strong) MMSignal<NSNumber *> *showIndicator;

- (void) updateTodo;
- (void) addTodo:(NSString *)name complete:(void(^)(BOOL finished))cb;
- (void) checkTodo:(NSUInteger)index finished:(BOOL)finished;
- (void) deleteTodo:(NSUInteger)index;
- (void) deleteFinished:(NSUInteger)index;

- (NSInteger) todoCount;
- (NSInteger) finishedTodoCount;
- (NSUInteger) numberOfRowsInSection:(NSUInteger)section;
- (NSString *) titleForHeaderInSection:(NSUInteger)section;
@end
