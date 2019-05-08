//
//  MMStack.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/28.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMStack.h"

@implementation MMStack{
    NSMutableArray<id> *_arr;
}

- (instancetype)init{
    if (self = [super init]) {
        _arr = [NSMutableArray array];
    }
    return self;
}

- (id)top{
    @synchronized (_arr) {
        if (_arr.count) {
            return [_arr lastObject];
        } else {
            return nil;
        }
    }
}

- (id)bottom{
    @synchronized (_arr) {
        if (_arr.count) {
            return [_arr firstObject];
        } else {
            return nil;
        }
    }
}

- (void)push:(id)value{
    @synchronized (_arr) {
        [_arr addObject:value];
    }
}

- (id)pop{
    @synchronized (_arr) {
        id value = [_arr lastObject];
        [_arr removeLastObject];
        return value;
    }
}

- (id)peekStack:(NSUInteger)index{
    id value = _arr[_arr.count - 1 - index];
    return value;
}

- (void)shrinkStack:(NSUInteger)shrinkSize{
    @synchronized (_arr) {
        [_arr removeObjectsInRange:NSMakeRange(_arr.count - shrinkSize, shrinkSize)];
    }
}

- (NSUInteger)size{
    return _arr.count;
}

- (void)clear{
    @synchronized (_arr) {
        [_arr removeAllObjects];
    }
}

- (NSString *)description{
    return [_arr description];
}
@end
