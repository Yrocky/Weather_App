//
//  XXXResultSet.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXSection.h"

NS_ASSUME_NONNULL_BEGIN

/// 用来承载从service中获取的数据，是service数据和业务模型之间的转接层
@interface XXXResultSet : NSObject<XXXOperationIndexPathItemAble>

@property (nonatomic ,readonly) NSArray<XXXSection *> * data;

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,assign) NSInteger pageSize;

@end

// 为ResultSet提供的下标访问功能，外部不允许直接调用
@interface XXXResultSet (Subscript)

- (void) setObject:(XXXSection *)anObject atIndexedSubscript:(NSUInteger)index;
- (XXXSection *) objectAtIndexedSubscript:(NSUInteger)idx;
@end
NS_ASSUME_NONNULL_END
