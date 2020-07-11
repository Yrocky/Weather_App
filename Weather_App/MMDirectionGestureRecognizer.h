//
//  MMDirectionGestureRecognizer.h
//  Weather_App
//
//  Created by Rocky Young on 2018/10/29.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , MMDirectionGestureRecognizerDirection) {
    
    MMDirectionGestureRecognizerUp = 1 << 0,
    MMDirectionGestureRecognizerDown = 1 << 1,
    MMDirectionGestureRecognizerLeft = 1 << 2,
    MMDirectionGestureRecognizerRight = 1 << 3,
    MMDirectionGestureRecognizerUnknown = 1 << 4,
};

// 自定义手势，通过手指的移动，计算大致的滑动方向
@interface MMDirectionGestureRecognizer : UIGestureRecognizer

@property (nonatomic ,assign) CGFloat hysteresisOffset;///<滞后的距离，默认为10pt
@property (nonatomic ,assign ,readonly) MMDirectionGestureRecognizerDirection direction;
@property (nonatomic ,assign ,readonly) CGFloat offset;///<在当前方向上移动的距离

@end
