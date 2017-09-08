//
//  HLLCircularLoaderView.h
//  Weather_App
//
//  Created by user1 on 2017/8/24.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLCircularLoaderView : UIView

// 加载视图线的宽度 默认 2
@property (nonatomic ,assign) CGFloat circleLineWidth;

// 加载试图线的颜色 默认 红色
@property (nonatomic ,strong) UIColor * circleLineColor;

// 加载进程
@property (nonatomic ,assign) CGFloat progress;

+ (instancetype) circularLoaderView;

- (void) reset;
- (void) reveal;
@end
