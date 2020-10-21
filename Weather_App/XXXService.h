//
//  XXXService.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XXXResultSet;
@protocol XXXModelAble;

typedef void(^XXXServiceCompletionBlock)(XXXResultSet *resultSet, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, XXXServiceState) {
    XXXServiceStateUnload, //未载入状态
    XXXServiceStateLoading, //网络载入中
    XXXServiceStateLoaded, //网络载入完成
};

/// 在VM中负责进行数据的获取，除了可以进行网络请求，还可以进行数据库、文件I/O等操作
@interface XXXService : NSObject{
    XXXServiceState _state;
    XXXResultSet * _resultSet;
}

@property (nonatomic ,strong ,readonly) XXXResultSet * resultSet;
@property (nonatomic ,assign ,readonly) XXXServiceState state;

- (void) reloadDataWithCompletion:(XXXServiceCompletionBlock)completion;
- (void) loadMoreDataWithCompletion:(XXXServiceCompletionBlock)completion;

@end

/// 对数据的增删改查，存在一些业务是对服务端的数据进行进一步的处理
@interface XXXService (Operation)

- (void) addItem:(id<XXXModelAble>)item;

- (void) insertItem:(id<XXXModelAble>)item atIndex:(NSInteger)index;

- (void) deleteItem:(id<XXXModelAble>)item;

- (void) removeAllItems;
@end

NS_ASSUME_NONNULL_END
