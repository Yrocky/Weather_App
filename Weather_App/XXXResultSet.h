//
//  XXXResultSet.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXOperationItemAble.h"

NS_ASSUME_NONNULL_BEGIN

/// 用来承载从service中获取的数据，是service数据和业务模型之间的转接层
@interface XXXResultSet : NSObject<XXXOperationItemAble>

@property (nonatomic ,readonly) NSMutableArray<XXXModel> * items;

@property (nonatomic ,assign) NSInteger index;

@property (nonatomic ,assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END
