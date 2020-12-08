//
//  XXXModelAble.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XXXCellLayoutData;

// 抽象根据服务端映射的数据模型
@protocol XXXModelAble <NSObject>

@property (nonatomic ,strong) __kindof XXXCellLayoutData * layoutData;

@end

typedef id<XXXModelAble> XXXModel;

NS_ASSUME_NONNULL_END
