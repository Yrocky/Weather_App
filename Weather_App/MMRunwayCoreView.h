//
//  MMRunwayCoreView.h
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMRunwayCoreView;
@interface MMRunwayLabel : UILabel<NSCopying>

+ (instancetype)label;

- (CGSize) configAttributedString:(NSAttributedString *)attString;
- (CGSize) configText:(NSString *)text;
@end

@protocol MMRunwayCoreViewDelegate <NSObject>

@optional;
- (void) runwayCoreView:(MMRunwayCoreView *)runwayCoreView willStartDisplayItemView:(UIView *)itemView;
- (void) runwayCoreView:(MMRunwayCoreView *)runwayCoreView didFinishDisplayItemView:(UIView *)itemView;
- (void) runwayCoreViewDidFinishDisplayAllItemView:(MMRunwayCoreView *)runwayCoreView;
@end

@interface MMRunwayCoreView : UIView{

    CGFloat _speed;
    CGFloat _defaultSpace;
}

@property (nonatomic ,weak) id<MMRunwayCoreViewDelegate>delegate;

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

// 根据字符串添加一个使用内建的MMRunwayLabel构建的跑道视图
- (void) appendText:(NSString *)text;

// 根据属性字符串添加一个使用内建的MMRunwayLabel构建的跑道视图
- (void) appendAttributedString:(NSAttributedString *)attString;

// 添加一个使用自定义的MMRunwayLabel构建的跑道视图
- (void) appendRunwayLabel:(MMRunwayLabel *)runwayLabel;

// 添加一个自定义的视图作为跑道，需要提前设置好customView的size
- (void) appendCustomView:(UIView *)customView;

// 移除所有的跑道视图
- (void) removeAllRunwayView;
@end

