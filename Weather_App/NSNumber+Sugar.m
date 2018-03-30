//
//  NSNumber+Sugar.m
//  Weather_App
//
//  Created by user1 on 2018/1/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "NSNumber+Sugar.h"

@implementation NSNumber (Sugar)

- (void)mm_times:(void (^)(void))block {
    for (int i = 0; i < self.integerValue; i++)
        block();
}

- (void)mm_timesWithIndex:(void (^)(NSUInteger))block {
    for (NSUInteger i = 0; i < self.unsignedIntegerValue; i++)
        block(i);
}

- (void)mm_upto:(int)number do:(void (^)(NSInteger))block {
    for (NSInteger i = self.integerValue; i <= number; i++)
        block(i);
}

- (void)mm_downto:(int)number do:(void (^)(NSInteger))block {
    for (NSInteger i = self.integerValue; i >= number; i--)
        block(i);
}

- (NSArray *)mm_arrayWithTimesIndex:(id (^)(NSUInteger index))block{
    
    NSMutableArray * temp = [NSMutableArray array];
    [self mm_timesWithIndex:^(NSUInteger index) {
        [temp addObject:block(index)];
    }];
    return [temp copy];
}
@end
