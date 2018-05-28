//
//  NSArray+Algorithms.h
//  Weather_App
//
//  Created by user1 on 2018/5/22.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Algorithms)

+ (instancetype) emptyArrayWithCount:(NSInteger)count;

- (NSArray *) countingSortWithRange:(NSRange)range;

- (void) debugPrint;
@end

@interface NSMutableArray (Algorithms)

- (NSMutableArray *)naiveBubbleSort;
- (void) valuePulsAt:(NSInteger)index;
@end

