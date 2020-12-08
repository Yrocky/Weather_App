//
//  XXXSection.m
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "XXXSection.h"

@interface XXXSection ()
@property (nonatomic ,strong) NSMutableArray<XXXModel> * items;
@end

@implementation XXXSection

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
    }
    return self;
}

#pragma mark - XXXOperationSetItemAble

- (void) addItem:(XXXModel)item{
    if (item) [_items addObject:item];
}

- (void) addItems:(NSArray<XXXModel> *)items{
    if (items.count) [_items addObjectsFromArray:items];
}

- (void) insertItem:(XXXModel)item atIndex:(NSInteger)index{
    self[index] = item;
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

- (void) removeAllItems{
    [_items removeAllObjects];
}

- (XXXModel) itemAtIndex:(NSInteger)index{
    return self[index];
}

#pragma mark - Subscript

- (void)setObject:(XXXModel)anObject atIndexedSubscript:(NSUInteger)index{
    
    if (!anObject) return;
    
    const NSUInteger length = [_items count];
    
    if (index > length) return;
    
    if (index == length){
        [_items addObject:anObject];
    } else {
        [_items replaceObjectAtIndex:index withObject:anObject];
    }
}

- (XXXModel)objectAtIndexedSubscript:(NSUInteger)idx{
    
    if (idx >= [_items count]) return nil;
    
    return [_items objectAtIndex:idx];
}

#pragma mark - getter

- (NSArray *)list{
    return _items.copy;
}
@end
