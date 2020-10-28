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

- (void) removeAllItems{
    _index = 0;
    [_items removeAllObjects];
}

- (void) addItem:(XXXModel)item{
    if (item) {
        [_items addObject:item];
    }
}

- (void) addItems:(NSArray<XXXModel> *)items{
    if (0 != items.count) {
        [_items addObjectsFromArray:items];
    }
}

- (void) insertItem:(XXXModel)item atIndex:(NSInteger)index{
    if (item && index < _items.count) {
        [_items insertObject:item atIndex:index];
    }
}

- (void) deleteItem:(XXXModel)item{
    if (item) {
        [_items removeObject:item];
    }
}

- (void) deleteItemAtIndex:(NSInteger)index{
    if (index < _items.count) {
        [_items removeObjectAtIndex:index];
    }
}

- (XXXModel)itemAtIndex:(NSInteger)index{
    if (index < _items.count) {
        return [_items objectAtIndex:index];
    }
    return nil;
}

@end
