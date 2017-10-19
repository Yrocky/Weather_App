//
//  NSArray+Sugar.m
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "NSArray+Sugar.h"

@implementation NSArray (Sugar)

- (id)first{

    return [self firstObject];
}

- (id) last{

    return [self lastObject];
}

- (id) sample{

    if (self.count == 0)    return nil;
    
    return self[arc4random_uniform((UInt32)self.count)];
}

- (void) each:(void (^)(id))handle{

    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj);
    }];
}

- (void) each:(void (^)(id))handle options:(NSEnumerationOptions)options{

    [self enumerateObjectsWithOptions:options usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj);
    }];
}

- (void) eachWithIndex:(void(^)(id ,NSInteger))handle{

    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        handle(obj,idx);
    }];
}

- (BOOL) includes:(id)obj{

    return [self containsObject:obj];
}

- (BOOL (^)(id obj)) have{

    return ^BOOL(id obj){
        return [self includes:obj];
    };
}
- (NSArray *) mm_mapWithskip:(id (^)(id obj, BOOL *skip))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    
    for( id obj in self ){
        
        BOOL skip = NO;
        
        id mapObj = handle(obj, &skip);
        
        if( !skip ){
            [_self addObject:mapObj];
        }
    }
    return [_self copy];
}

- (NSArray *) map:(id (^)(id))handle{

    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id obj in self) {
        [_self addObject:handle(obj) ? : [NSNull null]];
    }
    return [_self copy];
}

- (NSArray *) mm_mapWithIndex:(id (^)(id,NSUInteger))handle{
    
    NSMutableArray * _self = [NSMutableArray arrayWithCapacity:self.count];
    
    NSUInteger index = 0;
    for (id obj in self) {
        [_self addObject:handle(obj,index) ? : [NSNull null]];
        index ++;
    }
    return [_self copy];
}
- (NSArray *) select:(BOOL (^)(id obj))handle{

    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return handle(evaluatedObject);
    }]];
}

- (NSArray *) filter:(BOOL (^)(id obj))handle{

    return [self select:handle];
}

- (NSArray *) compat{

    return [self select:^BOOL(id obj) {
        return obj != [NSNull null];
    }];
}

#pragma mark - 布尔运算

- (NSArray *) intersect:(NSArray *)other{

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}

- (NSArray *) union:(NSArray *)other{

    NSArray * tmp = [self subtract:other];
    
    return [tmp arrayByAddingObjectsFromArray:other];
}

- (NSArray *) difference:(NSArray *)other{

    NSArray * selfSubtractOther = [self subtract:other];
    NSArray * otherSubtractSelf = [other subtract:self];
    
    return [selfSubtractOther union:otherSubtractSelf];
}

- (NSArray *) subtract:(NSArray *)other{

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",other];
    
    return [self filteredArrayUsingPredicate:pred];
}
@end
