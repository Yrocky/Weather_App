//
//  MT_ComponentHelper.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_Spacing : NSObject<MT_Component>

@property (class, readonly) MT_Spacing *(^create)(CGFloat height);

@end

NS_ASSUME_NONNULL_END
