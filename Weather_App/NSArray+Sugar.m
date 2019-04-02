//
//  NSArray+Sugar.m
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "NSArray+Sugar.h"
#import "NSObject+CodableProperties.h"

@implementation NSArray (Sugar)

- (id) mm_first{

    if (self.count) {
        return [self firstObject];
    }
    return nil;
}

- (id) mm_last{

    if (self.count) {
        return [self lastObject];
    }
    return nil;
}

- (id) mm_sample{

    if (self.count == 0)    return nil;
    
    return self[arc4random_uniform((UInt32)self.count)];
}

- (void) mm_each:(void (^)(id))handle{
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj);
    }];
}

- (void)mm_eachWithOptions:(void (^)(id))handle options:(NSEnumerationOptions)options{
    [self mm_each:handle options:options];
}

- (void) mm_each:(void (^)(id))handle options:(NSEnumerationOptions)options{
    @autoreleasepool{
        [self enumerateObjectsWithOptions:options usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            handle(obj);
        }];
    }
}

- (void) mm_eachWithIndex:(void(^)(id ,NSInteger))handle{

    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            handle(obj,idx);
        }];
    }
}

- (void) mm_eachWithStop:(BOOL(^)(id obj))handle{

    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            *stop = handle(obj);
        }];
    }
}

- (void) mm_eachWithIndexStop:(BOOL(^)(id obj ,NSUInteger index))handle{
    @autoreleasepool{
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            *stop = handle(obj ,idx);
        }];
    }
}
- (BOOL) mm_includes:(id)obj{

    return [self containsObject:obj];
}

- (BOOL (^)(id obj)) mm_have{

    return ^BOOL(id obj){
        return [self mm_includes:obj];
    };
}

- (NSArray *) mm_map:(id (^)(id))handle{

    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for (id obj in self) {
            [_self addObject:handle(obj) ? : [NSNull null]];
        }
    }
    return [_self copy];
}

- (NSArray *) mm_mapWithIndex:(id (^)(id,NSUInteger))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        NSUInteger index = 0;
        for (id obj in self) {
            [_self addObject:handle(obj,index) ? : [NSNull null]];
            index ++;
        }
    }
    return [_self copy];
}

- (NSArray *) mm_mapWithskip:(id (^)(id obj, BOOL *skip))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for( id obj in self ){
            
            BOOL skip = NO;
            
            id mapObj = handle(obj, &skip);
            
            if( !skip ){
                [_self addObject:mapObj];
            }
        }
    }
    return [_self copy];
}

- (NSArray *) mm_mapWithSkipIndex:(id (^)(id obj, BOOL *skip, NSUInteger idnex))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        NSUInteger index = 0;
        for( id obj in self ){
            
            BOOL skip = NO;
            
            id mapObj = handle(obj, &skip, index);
            
            if( !skip ){
                [_self addObject:mapObj];
            }
            index ++;
        }
    }
    return [_self copy];
}

- (NSArray *) mm_compactMap:(id (^)(id))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    @autoreleasepool{
        for (id obj in self) {
            id mappedObj = handle(obj);
            if (mappedObj) {
                [_self addObject:mappedObj];
            }
        }
    }
    return [_self copy];
}

- (NSArray *) mm_select:(BOOL (^)(id obj))handle{

    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return handle(evaluatedObject);
    }]];
}

- (NSArray *) mm_select:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber{
    
    if (pageSize > self.count) {
        return nil;
    }
    if (pageSize * (pageNumber - 1) >= self.count) {
        return nil;
    }
    NSRange range;
    if (pageSize * pageNumber >= self.count) {
        range = NSMakeRange(pageSize * (pageNumber - 1), self.count - pageSize * (pageNumber - 1));
    }else{
        range = NSMakeRange(pageSize * (pageNumber - 1), pageSize);
    }
    return [self subarrayWithRange:range];
}

- (NSArray *) mm_filter:(BOOL (^)(id obj))handle{

    return [self mm_select:handle];
}

- (NSArray *) mm_compat{

    return [self mm_select:^BOOL(id obj) {
        return obj != [NSNull null];
    }];
}

- (NSArray *) mm_merge:(NSArray *)other{

    NSMutableArray * _self = [NSMutableArray arrayWithArray:self];
    [_self addObjectsFromArray:other];
    return [_self copy];
}

- (NSArray *) mm_distinctUnion2{
    @autoreleasepool {
        NSMutableArray * _self = [@[] mutableCopy];
        [self mm_each:^(id  _Nonnull obj) {
            if (!_self.mm_have(obj)) {
                [_self addObject:obj];
            }
        }];
        return [_self copy];
    }
}

- (NSArray *) mm_distinctUnion{
    return [self mm_distinctUnionWithKey:@"self"];
}

- (NSArray *) mm_distinctUnionWithKey:(NSString *)key{
    
    NSAssert([[[self mm_sample] mm_getAllProperties] containsObject:key] ||
             [key isEqualToString:@"self"],
             @"the `key` must be one of properties with T class or is `self`");
    
    NSString * keyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@",key];
    return [self valueForKeyPath:keyPath];
}


- (NSArray *) mm_append:(NSArray *)other{
    NSMutableArray * _self = [self mutableCopy];
    
    [_self mm_each:^(id  _Nonnull obj) {
        if (!_self.mm_have(obj)) {
            [_self addObject:obj];
        }
    }];
    
    return [_self copy];
}
#pragma mark - 布尔运算

- (NSArray *) mm_intersect:(NSArray *)other{

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}

- (NSArray *) mm_union:(NSArray *)other{

    NSArray * tmp = [self mm_subtract:other];
    
    return [tmp arrayByAddingObjectsFromArray:other];
}

- (NSArray *) mm_difference:(NSArray *)other{

    NSArray * selfSubtractOther = [self mm_subtract:other];
    NSArray * otherSubtractSelf = [other mm_subtract:self];
    
    return [selfSubtractOther mm_union:otherSubtractSelf];
}

- (NSArray *) mm_subtract:(NSArray *)other{

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}

- (NSArray *) mm_intersect:(BOOL(^)(id obj))filter other:(NSArray *)other{

    return [[self mm_filter:filter] mm_intersect:other];
}

- (NSArray *) mm_sort:(NSComparisonResult (^)(id, id))handle{
    
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (handle) {
            return handle(obj1,obj2);
        }
        return NSOrderedAscending;
    }];
}

- (NSString *) mm_join {
    return [self componentsJoinedByString:@""];
}

- (NSString *) mm_join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}
@end

@implementation NSNumber (Sugar)

- (void) mm_enumerate:(void(^)(NSInteger index))action{
    
    NSInteger _self = [self integerValue];
    
    for (NSInteger i = 0; i < _self; i ++) {
        if (action) {
            action(i);
        }
    }
}
@end

@implementation NSArray (MM_Safe)

- (NSArray *)mm_subarray:(NSInteger)count{
    
    if (count <= self.count) {
        return [self subarrayWithRange:NSMakeRange(0, count)];
    }
    return self;
}

- (NSArray *) mm_range:(NSRange)range{
    if (nil == self) {
        return nil;
    }
    if (range.location >= self.count) {
        return nil;
    }
    if (range.location + range.length >= self.count) {
        range.length = self.count - 1 - range.location;
    }
    return [self subarrayWithRange:range];
}

- (NSArray<NSArray *> *) mm_sliceSubarray:(NSInteger)offset{
    
    if (nil == self) {
        return nil;
    }
    
    if (offset < self.count) {
        
        NSMutableArray * _selfM = [NSMutableArray array];
        NSInteger count = (self.count - 1) / offset + 1;
        for (NSInteger index = 0; index < count; index ++) {
            NSArray * rangeArray = [self mm_range:NSMakeRange(index * offset, offset)];
            if (rangeArray) {
                [_selfM addObject:rangeArray];
            }
        }
        return [_selfM copy];
    }
    return @[self];
}

@end

