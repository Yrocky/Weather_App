//
//  UIColor+Common.h
//  PointChat
//
//  Created by Rocky Young on 2017/10/1.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)
#pragma mark - Class Method

/**
 *  根据Hex字符串生成颜色实例，FF0000 = redColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  根据Hex字符串以及alpha生成颜色实例，FF0000 = redColor
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

/**
 *   返回一个随机颜色实例
 */
+ (UIColor *)randomColor;

/**
 *  根据RGBHex返回颜色实例，16711680 = redColor
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

@end
