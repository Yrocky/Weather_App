//
//  XXXResultSet.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXResultSet.h"

@implementation XXXResultSet

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
    }
    return self;
}

- (void) reset{

    _index = 0;
    [_items removeAllObjects];
}

- (void) addItem:(id<XXXModelAble>)item{
    if (item) {
        [_items addObject:item];
    }
}

- (void) addItems:(NSArray *)items{
    if (0 != items.count) {
        [_items addObjectsFromArray:items];
    }
}

- (void) insertItem:(id<XXXModelAble>)item atIndex:(NSInteger)index{
    if (item && index < _items.count) {
        [_items insertObject:item atIndex:index];
    }
}

- (void) deleteItem:(id<XXXModelAble>)item{
    if (item) {
        [_items removeObject:item];
    }
}

@end
