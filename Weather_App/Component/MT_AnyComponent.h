//
//  MT_AnyComponent.h
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_AnyComponent : NSObject<MT_Component>

@property (nonatomic ,copy) NSString * reuseIdentifier;

@property (class, readonly) MT_AnyComponent *(^make)(id<MT_Component> component);

@end

@interface UIView (MT_Content)<MT_Content>
@end

@interface UIViewController (MT_Content)<MT_Content>
@end
NS_ASSUME_NONNULL_END
