//
//  NSArray+Algorithms.m
//  Weather_App
//
//  Created by user1 on 2018/5/22.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "NSArray+Algorithms.h"

@implementation NSArray (Algorithms)

+ (instancetype)emptyArrayWithCount:(NSInteger)count{
    
    NSMutableArray * temp = [@[] mutableCopy];
    for (int i = 0; i < count; i ++) {
        [temp addObject:@(0)];
    }
    return [temp copy];
}

- (NSArray *) countingSortWithRange:(NSRange)range{
    
    NSInteger m = range.length;
    
    NSMutableArray * equal = [NSMutableArray emptyArrayWithCount:m];
    for (NSInteger i = 0 ; i < self.count ; i ++) {
        
        NSInteger equalIndex = [self[i] integerValue];
        [equal valuePulsAt:equalIndex];
    }
    
    NSMutableArray * less = [NSMutableArray emptyArrayWithCount:m];
    for (NSInteger i = 1; i < equal.count; i ++) {
        
        NSInteger sum = 0;
        for (NSInteger j = 1; j < i; j ++) {
            sum += [equal[j] integerValue];
        }
        
        less[i] = @(sum);
    }
    NSMutableArray * b = [NSMutableArray emptyArrayWithCount:self.count];
    
    for (NSInteger i = 0; i < self.count; i ++) {
        
        NSInteger lessIndex = [self[i] integerValue];
        
        NSInteger bIndex = [less[lessIndex] integerValue];
        
        b[bIndex] = @(lessIndex);
//        NSLog(@"a[%d]=%d;less[%d]=%d;b[%d]=%d",i,lessIndex,lessIndex,bIndex,bIndex,lessIndex);
        [less valuePulsAt:lessIndex];
    }
    return [b copy];
}

- (void) debugPrint{

    NSString * s = @"debug array:[";
    for (NSInteger i = 0; i < self.count; i ++) {
        s = [s stringByAppendingFormat:@"%@,",self[i]];
    }
    s = [s substringToIndex:s.length - 1];
    s = [s stringByAppendingString:@"]"];
    NSLog(@"%@",s);
}

@end


@implementation NSMutableArray (Algorithms)

+ (instancetype)emptyArrayWithCount:(NSInteger)count{
    
    NSMutableArray * temp = [@[] mutableCopy];
    for (int i = 0; i < count; i ++) {
        [temp addObject:@(0)];
    }
    return temp;
}

- (NSMutableArray *)naiveBubbleSort
{
    NSUInteger count = [self count];
    
    for (int i = 0; i < count; i++) {
        NSLog(@"for---%d",i);
        for (int j = 0; j < (count - 1); j++) {
            NSLog(@"for------%d",j);
            if ([self[j] compare:self[j + 1]] == NSOrderedDescending) {
                [self exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
            }
        }
    }
    
    return self;
}
- (void) valuePulsAt:(NSInteger)index{
    
    NSInteger count = [self[index] integerValue];
    self[index] = @(++count);
}

@end
