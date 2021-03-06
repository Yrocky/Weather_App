//
//  MT_ViewNode.h
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_AnyComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_ViewNode : NSObject

@property (nonatomic ,strong ,readonly) MT_AnyComponent * component;

@property (class, readonly) __kindof MT_ViewNode *(^create)(id<MT_Component> component);

@end

NS_ASSUME_NONNULL_END
