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

@interface MMRunwayCoreView : UIScrollView{

    CGFloat _speed;
    CGFloat _defaultSpace;
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

