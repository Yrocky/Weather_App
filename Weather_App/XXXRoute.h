//
//  XXXRoute.h
//  Weather_App
//
//  Created by skynet on 2019/12/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JLRoutes/JLRoutes.h>
#import "XXXRouteTemplate.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXRoute : NSObject

+ (JLRoutes *) core;

+ (void) registRoutes;
@end

NS_ASSUME_NONNULL_END
