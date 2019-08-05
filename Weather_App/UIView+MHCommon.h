//
//  UIView+MHCommon.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIScreen width.
 */
#define  kScreenWidth   [UIScreen mainScreen].bounds.size.width

/**
 *  UIScreen height.
 */
#define  kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define XXXCGPointProperty(__name__) @property (nonatomic) CGPoint __name__;

/**
 *  UIView 通用Category
 */
@interface UIView (MHCommon)

/**
 *	@brief	删除所有子对象
 */
- (void)removeAllSubviews;


XXXCGPointProperty(viewTop);

@property (nonatomic) CGPoint viewOrigin;
@property (nonatomic) CGSize  viewSize;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic, readonly) CGFloat middleX;
@property (nonatomic, readonly) CGFloat middleY;
@property (nonatomic, readonly) CGPoint middlePoint;

// 添加子视图在最上层
- (void)addSubviewOrBringToFront:(UIView *)subview;

/**
 *  快速修改对象的单个属性值
 *
 *  @param view  要修改的view、imageView、button、...
 *  @param key   要修改的属性，例如：@"x",@"y",@"w",@"h"
 *  @param value 被修改属性的新值
 */
- (void)frameSet:(NSString *)key value:(CGFloat)value;

/**
 *  快速修改对象的多个属性值
 *
 *  @param view   要修改的view、imageView、button、...
 *  @param key1   要修改的属性1，例如：@"x",@"y",@"w",@"h"
 *  @param value1 属性1的新值
 *  @param key2   要修改的属性2，例如：@"x",@"y",@"w",@"h"
 *  @param value2 属性2的新值
 */
- (void)frameSet:(NSString *)key1 value1:(CGFloat)value1 key2:(NSString *)key2 value2:(CGFloat)value2;


// 添加线
- (void)addLine:(CGRect)rect;


- (void)addLine:(UIColor *)color inRect:(CGRect)rect;

//设置view圆角
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end

@interface UIView (Line)

+ (instancetype) lineView;
@end

@interface CALayer (HSFrame)
@property (nonatomic ,assign) CGFloat hs_x;
@property (nonatomic ,assign) CGFloat hs_y;
@property (nonatomic ,assign) CGFloat hs_width;
@property (nonatomic ,assign) CGFloat hs_height;
@property (nonatomic ,assign) CGSize hs_size;

@end
