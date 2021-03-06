//
//  XXXService.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXResultSet.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
