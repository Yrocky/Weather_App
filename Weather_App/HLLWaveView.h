//
//  HLLWaveView.h
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLWaveView : UIView
/**
 *  波纹偏移
 */
@property (nonatomic ,assign) CGFloat offsetX;
/**
 *  波纹振幅 默认10
 */
@property (nonatomic ,assign) CGFloat waveAmplitude;
/**
 *  振幅周期 默认300
 */
@property (nonatomic ,assign) CGFloat waveCycle;
/**
 *  波纹速度 默认 0.1
 */
@property (nonatomic ,assign) CGFloat waveSpeed;
/**
 *  波纹颜色 默认红色
 */
@property (nonatomic, strong) UIColor * waveColor;

+ (instancetype) waveView;

- (void) start;
- (void) stop;
@end
