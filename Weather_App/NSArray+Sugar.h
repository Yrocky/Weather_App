//
//  NSArray+Sugar.h
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<T> (Sugar)

- (T) mm_first;

- (T) mm_last;

- (T) mm_sample;

- (NSArray *) mm_map:(id (^)(T obj))handle;
- (NSArray *) mm_mapWithskip:(id (^)(T obj, BOOL *skip))handle;
- (NSArray *) mm_mapWithIndex:(id (^)(T obj,NSUInteger index))handle;
- (NSArray *) mm_mapWithSkipIndex:(id (^)(T obj, BOOL *skip, NSUInteger idnex))handle;

- (NSArray *) mm_compactMap:(id (^)(T obj))handle;

- (void) mm_each:(void(^)(T obj))handle;
- (void) mm_eachWithOptions:(void (^)(T))handle options:(NSEnumerationOptions)options;
- (void) mm_eachWithIndex:(void(^)(T obj,NSInteger index))handle;

- (void) mm_eachWithStop:(BOOL(^)(T obj))handle;
- (void) mm_eachWithIndexStop:(BOOL(^)(T obj ,NSUInteger index))handle;

- (BOOL (^)(T obj)) mm_have;

- (NSArray<T> *) mm_select:(BOOL (^)(T obj))handle;
- (NSArray<T> *) mm_filter:(BOOL (^)(T obj))handle;
- (NSArray<T> *) mm_select:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber;

///< same as addFromArray:
- (NSArray<T> *) mm_merge:(NSArray<T> *)other;
//- (NSArray *) mm_special:(NSString *(^)(id obj))handle1 merge:(NSArray *)other special:(NSString * (^)(id obj))handle;

- (NSArray<T> *) mm_distinctUnion2;
///<distinct union objectives, default is `@distinctUnionOfObjects.self`
- (NSArray<T> *) mm_distinctUnion;
///<base on `T.key` for distinct union objectives ,`key` is one of properties from T
- (NSArray<T> *) mm_distinctUnionWithKey:(NSString *)key;

///<self：[a,b,c,d,e] other:[x,d,y,e,o,m] result:[a,b,c,d,e,x,y,o,m] ,base on `isEqual:`
- (NSArray<T> *) mm_append:(NSArray<T> *)other;

#pragma mark - 布尔运算
///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[1,4]
- (NSArray<T> *) mm_intersect:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[1,2,3,4,6,7,8]
- (NSArray<T> *) mm_union:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[2,3,6,7,8]
- (NSArray<T> *) mm_difference:(NSArray<T> *)other;

///< self:[1,2,3,4] oher:[1,4,6,7,8] result:[2,3]
- (NSArray<T> *) mm_subtract:(NSArray<T> *)other;

///< mm_intersect:函数的变形，可以选取哪些成员参与到布尔运算中
- (NSArray<T> *) mm_intersect:(BOOL(^)(T obj))filter other:(NSArray<T> *)other;

#pragma mark - 排序
///< 排序
- (NSArray<T> *) mm_sort:(NSComparisonResult (^)(T obj1, T obj2))handle;

- (NSString *) mm_join;
- (NSString *) mm_join:(NSString *)separator;
@end

@interface NSNumber (Sugar)

- (void) mm_enumerate:(void(^)(NSInteger index))action;
@end

@interface NSArray (MM_Safe)

- (NSArray *)mm_subarray:(NSInteger)count;
// @[].count = 34 ,offset = 10 ,result is @[@[0-9],@[10-19],@[20-29],@[30-33]]
- (NSArray<NSArray *> *) mm_sliceSubarray:(NSInteger)offset;
@end
