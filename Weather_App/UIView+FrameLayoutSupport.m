//
//  UIView+FrameLayoutSupport.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/27.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "UIView+FrameLayoutSupport.h"

@implementation UIView (FrameLayoutSupport)

- (UIView *(^)(UIView *))equalTo{
    return ^UIView *(UIView *other){
        return self;
    };
}

- (void (^)(CGFloat))offset{
    return ^void(CGFloat offset){
        
    };
}
@end
