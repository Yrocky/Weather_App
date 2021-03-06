//
//  MT_Group.h
//  Weather_App
//
//  Created by rocky on 2020/12/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_AnyComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_Group : NSObject

@property (class, readonly) MT_Group *(^create)(NSArray<id<MT_Component>> *components);

@end

NS_ASSUME_NONNULL_END
