//
//  NSArray+Sugar.h
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Sugar)

- (id) first;

- (id) last;

- (id) sample;

- (NSArray *) map:(id (^)(id obj))handle;

- (void) each:(void(^)(id obj))handle;
- (void) eachWithIndex:(void(^)(id obj,NSInteger index))handle;

- (BOOL (^)(id obj)) have;

- (NSArray *) select:(BOOL (^)(id obj))handle;

- (NSArray *) intersect:(NSArray *)other;
- (NSArray *) union:(NSArray *)other;
- (NSArray *) difference:(NSArray *)other;
- (NSArray *) subtract:(NSArray *)other;
@end