//
//  XXXService.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXService.h"
#import "XXXResultSet.h"

@implementation XXXService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resultSet = [XXXResultSet new];
        _state = XXXServiceStateUnload;
    }
    return self;
}

- (void)loadMoreDataWithCompletion:(XXXServiceCompletionBlock)completion{
    // 子类重写，编写具体的网络请求
}

- (void)reloadDataWithCompletion:(XXXServiceCompletionBlock)completion{
    // 子类重写，编写具体的网络请求
}

- (void) addItem:(id<XXXModelAble>)item{
    [self.resultSet addItem:item];
}

- (void) insertItem:(id<XXXModelAble>)item atIndex:(NSInteger)index{
    [self.resultSet insertItem:item atIndex:index];
}

- (void) deleteItem:(id<XXXModelAble>)item{
    [self.resultSet deleteItem:item];
}

- (void) removeAllItems{
    [self.resultSet reset];
}

@end
