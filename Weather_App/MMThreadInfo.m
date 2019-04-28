//
//  MMThreadInfo.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/26.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMThreadInfo.h"

@implementation MMThreadInfo
- (instancetype)initWithThreadID:(uint64_t)tid number:(NSUInteger)number name:(NSString *)name{
    NSAssert(name != nil, @"name must be not nil");
    self = [super init];
    if (self != nil) {
        self->_tid = tid;
        self->_number = number;
        self->_name = [name copy];// 为了确保name不会被改变，这里使用了一次copy
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@: %zu %#llx %@", [self class], (size_t) self->_number, self->_tid, self->_name];
}

@end
