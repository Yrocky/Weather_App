//
//  MMRunwayCoreView.h
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRunwayLabel : UILabel<NSCopying>

+ (instancetype)label;

- (CGSize) configAttributedString:(NSAttributedString *)attString;
- (CGSize) configText:(NSString *)text;
@end

@interface MMRunwayCoreView : UIScrollView{

    CGFloat _speed;
    CGFloat _defaultSpace;
}
/**
 *  初始化跑道容器视图
 *
 *  @param speed        移动10px需要的时间
 *  @param defauleSpace 每个跑道视图之间的默认间距
 *
 *  @return 跑道容器视图
 */
- (instancetype) initWithSpeed:(CGFloat)speed
                  defaultSpace:(CGFloat)defauleSpace;

// 添加一个使用内建的MMRunwayLabel构建的跑道视图
- (void) appendText:(NSString *)text;

// 添加一个使用内建的MMRunwayLabel构建的跑道视图
- (void) appendAttributedString:(NSAttributedString *)attString;

// 添加一个使用自定义的MMRunwayLabel构建的跑道视图
- (void) appendRunwayLabel:(MMRunwayLabel *)runwayLabel;

// 添加一个自定义的视图作为跑道，需要customView的bounds
- (void) appendCustomView:(UIView *)customView;

// 移除所有的跑道视图
- (void) removeAllRunwayView;
@end

