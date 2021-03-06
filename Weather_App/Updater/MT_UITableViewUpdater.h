//
//  MT_UITableViewUpdater.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Updater.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_UITableViewUpdater : NSObject<
MT_Updater>

@property (nonatomic ,copy) void(^bCompletion)(void);
@end

NS_ASSUME_NONNULL_END
