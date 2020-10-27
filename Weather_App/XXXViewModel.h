//
//  XXXViewModel.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXService.h"
#import "XXXCellLayoutData.h"
#import "XXXCellAble.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XXXPrelayoutCompletionBlock)(NSArray <XXXCellLayoutData *> *layoutDatas, NSError * __nullable error);

/// 负责控制器中绝大部分的任务，发起service、处理数据
@interface XXXViewModel : NSObject<XXXOperationItemAble>{
    __kindof XXXService * _service;
}

@property (nonatomic ,strong) __kindof XXXService * service;

@property (nonatomic ,strong ,readonly) NSError * error;

@property (nonatomic ,strong ,readonly) NSMutableArray<__kindof XXXCellLayoutData *> * layoutDatas;

/// 根据`XXXModelAble`创建对应的`LayoutData`
/// 子类要在这个方法中做主要的业务：布局、数据赋值等
- (__kindof XXXCellLayoutData *) refreshCellDataWithMetaData:(id<XXXModelAble>)metaData;

@end

// 使用新的resultSet更新layoutDatas
@interface XXXViewModel (RefreshModel)

- (void) refreshModelWithResultSet:(XXXResultSet *)resultSet;

- (void) asyncRefreshModelWithResultSet:(XXXResultSet *)resultSet
                             completion:(XXXPrelayoutCompletionBlock)completion;
@end

/// 发起网络、数据库等服务
@interface XXXViewModel (Service)

- (void) reloadDataWithCompletion:(XXXPrelayoutCompletionBlock)completion;

- (void) loadMoreDataWithCompletion:(XXXPrelayoutCompletionBlock)completion;

@end


NS_ASSUME_NONNULL_END
