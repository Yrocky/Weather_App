//
//  QLLiveComponentLayout+Private.h
//  Weather_App
//
//  Created by rocky on 2020/7/13.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveComponentLayout.h"
#import "QLLiveModelEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLLiveComponentLayout ()
@property (nonatomic ,strong ,readwrite) id<QLLiveModelEnvironment> environment;
@end

NS_ASSUME_NONNULL_END
