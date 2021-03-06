//
//  QLLiveModuleDataSource+Private.h
//  Weather_App
//
//  Created by rocky on 2020/8/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveModuleDataSource.h"
#import "QLLiveModelEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLLiveModuleDataSource ()

@property (nonatomic ,strong) id<QLLiveModelEnvironment> environment;

@end

NS_ASSUME_NONNULL_END
