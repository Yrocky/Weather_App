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

// 请求 contentView 当前日期的前一日的数据
- (void) billContainerViewNeedUpdatePreContentView:(HomeBillContainerView *)containerView;

// 请求 contentView 当前日期的后一日的数据
- (void) billContainerViewNeedUpdateNextContentView:(HomeBillContainerView *)containerView;
@end

@interface HomeBillContainerView : UIView

@property (nonatomic ,weak) id<HomeBillContainerViewDelegate>delegate;
@property (nonatomic ,readonly ,weak) UIView * contentView;

- (void) configBillContentView:(__kindof UIView *)contentView;

@end
