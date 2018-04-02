//
//  HomeBillContainerView.h
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeBillContainerView;
@protocol HomeBillContainerViewDelegate <NSObject>

// 用来设置可加载日期区间的最小值
- (BOOL) allowBillContainerViewLoadPreContentView:(HomeBillContainerView *)containterView;

// 用来设置可加载日期区间的最大值
- (BOOL) allowBillContainerViewLoadNextContentView:(HomeBillContainerView *)containterView;

// 请求 contentView 当前日期的前一日的数据
- (void) billContainerViewNeedUpdatePreContentView:(HomeBillContainerView *)containerView;

// 请求 contentView 当前日期的后一日的数据
- (void) billContainerViewNeedUpdateNextContentView:(HomeBillContainerView *)containerView;
@end

@interface HomeBillContainerView : UIView

@property (nonatomic ,weak) id<HomeBillContainerViewDelegate>delegate;

- (void) configBillContentView:(__kindof UIView *)contentView;

- (void) moveContentViewFromLeftSide;
- (void) moveContentViewFromRightSide;
@end
