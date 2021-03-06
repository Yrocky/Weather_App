//
//  MT_ViewNode.m
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_ViewNode.h"

@implementation MT_ViewNode

+ (__kindof MT_ViewNode * _Nonnull (^)(id<MT_Component> _Nonnull))create{
    return ^MT_ViewNode *(id<MT_Component> componet){
        return [[self alloc] initWithComponent:componet];
    };
}

- (instancetype) initWithComponent:(id<MT_Component>)component{
    self = [super init];
    if (self) {
        _component = MT_AnyComponent.make(component);
    }
    return self;
}

@end
