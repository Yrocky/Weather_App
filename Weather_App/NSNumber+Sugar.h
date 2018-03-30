//
//  NSNumber+Sugar.h
//  Weather_App
//
//  Created by user1 on 2018/1/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Sugar)

- (void)mm_times:(void (^)(void))block;

- (void)mm_timesWithIndex:(void (^)(NSUInteger index))block;

- (void)mm_upto:(int)number do:(void (^)(NSInteger index))block;

- (void)mm_downto:(int)number do:(void (^)(NSInteger index))block;

- (NSArray *)mm_arrayWithTimesIndex:(id (^)(NSUInteger index))block;
@end

