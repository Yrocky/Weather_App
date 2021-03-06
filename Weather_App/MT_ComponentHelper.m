//
//  MT_ComponentHelper.m
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_ComponentHelper.h"
#import "UIView+MT_ComponentRenderable.h"

@implementation MT_Spacing{
    CGFloat _height;
}

+ (MT_Spacing * _Nonnull (^)(CGFloat))create{
    return ^MT_Spacing*(CGFloat height){
        MT_Spacing * me = [MT_Spacing new];
        me->_height = height;
        return me;
    };
}
- (id<MT_Content>)renderContent{
    return UIView.new;
}

- (void)renderInContent:(UIView *)content{
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetWidth(bounds), _height);
}

@end
