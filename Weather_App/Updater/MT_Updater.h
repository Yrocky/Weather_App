//
//  MT_Updater.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Adapter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MT_Updater <NSObject>

- (void) prepare:(id)target adapter:(id<MT_Adapter>)adapter;
- (void) performUpdates:(id)target adapter:(id<MT_Adapter>)adapter data:(NSArray<MT_Section *> *)data;
@end

NS_ASSUME_NONNULL_END
