//
//  QLLiveComponent+Private.h
//  Weather_App
//
//  Created by rocky on 2020/7/10.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveComponent.h"
#import "QLLiveModelEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLLiveComponent ()

@property (nonatomic, weak, readwrite) id<QLLiveModuleDataSourceAble> dataSource;

@end

NS_ASSUME_NONNULL_END
