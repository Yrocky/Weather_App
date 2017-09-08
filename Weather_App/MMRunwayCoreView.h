//
//  MMRunwayCoreView.h
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRunwayLabel : UILabel

+ (instancetype)label;

- (CGSize) configAttributedString:(NSAttributedString *)attString;
- (CGSize) configText:(NSString *)text;
@end

@class MMRunwayCoreView;

@protocol TXScrollLabelViewDelegate <NSObject>
@optional
- (void)scrollLabelView:(MMRunwayCoreView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index;

- (void) runwayCoreViewDidEndScroll:(MMRunwayCoreView *)runwayCoreView;
@end

@interface MMRunwayCoreView : UIScrollView{

    CGFloat _speed;
    CGFloat _defaultSpace;
    NSMutableArray * _runwayViews;
}

/**
 *  初始化跑道视图
 *
 *  @param speed        移动10px需要的时间
 *  @param defauleSpace 每个视图之间的默认间距
 *
 *  @return 跑道视图
 */
- (instancetype) initWithSpeed:(CGFloat)speed
                  defaultSpace:(CGFloat)defauleSpace;

// 使用内建的MMRunwayLabel构建滚动视图
- (void) appendText:(NSString *)text;

// 使用内建的MMRunwayLabel构建滚动视图
- (void) appendAttributedString:(NSAttributedString *)attString;

// 使用自定义的MMRunwayLabel构建滚动视图
- (void) appendRunwayLabel:(MMRunwayLabel *)runwayLabel;

// 需要customView的bounds
- (void) appendCustomView:(UIView *)customView;

@end

@interface UIView (TXFrame)
/** 设置x值 */
@property (assign, nonatomic) CGFloat tx_x;
/** 设置y值 */
@property (assign, nonatomic) CGFloat tx_y;
/** 设置width */
@property (assign, nonatomic) CGFloat tx_width;
/** 设置height */
@property (assign, nonatomic) CGFloat tx_height;
/** 设置size */
@property (assign, nonatomic) CGSize  tx_size;
/** 设置origin */
@property (assign, nonatomic) CGPoint tx_origin;
/** 设置center */
@property (assign, nonatomic) CGPoint tx_center;
/** 设置center.x */
@property (assign, nonatomic) CGFloat tx_centerX;
/** 设置center.y */
@property (assign, nonatomic) CGFloat tx_centerY;
/** 设置bottom */
@property (assign, nonatomic) CGFloat tx_bottom;
@end
