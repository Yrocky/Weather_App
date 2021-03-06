//
//  EaseCycleScrollView.h
//  Weather_App
//
//  Created by rocky on 2020/7/27.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EaseCycleScrollAxis) {
    EaseCycleScrollAxisHorizontal,
    EaseCycleScrollAxisVertical,
};

@class EaseCycleScrollConfig;
@protocol EaseCycleScrollViewDelegate;

@interface EaseCycleScrollView : UIView

@property (nonatomic ,weak) id<EaseCycleScrollViewDelegate> delegate;

- (instancetype) initWithConfig:(EaseCycleScrollConfig *)config;

- (void) registScrollItemView:(Class)itemViewClazz;

- (void) setupDataSource:(NSArray *)dataSource atIndex:(NSInteger)index;

/// 移除数据
- (void) remove:(id)data;
- (void) removeDatas:(NSArray *)datas;
- (void) removeDataAt:(NSInteger)index;

///<在当前数据后面插入一条数据，并滚动到该数据处
- (void) insertNewData:(id)newData;

///<替换当前数据为新的数据
- (void) updateWithNewData:(id)newData;

///<是否允许滑动
- (void) allowScroll:(BOOL)allow;
@end

@interface EaseCycleScrollConfig : NSObject

@property (nonatomic ,assign) EaseCycleScrollAxis axis;
@property (nonatomic ,assign) CGFloat spacing;
@property (nonatomic ,assign) CGFloat padding;
@end

@protocol EaseCycleScrollViewDelegate <NSObject>

@optional

///< 添加的唯一内容视图，类似于直播间滑动
- (__kindof UIView *)cycleScrollViewShouldAddContentView:(EaseCycleScrollView *)view;

///< 页面切换的视图，类似于bannerView
- (void) cycleScrollViewUpdateItemView:(__kindof UIView *)itemView withData:(id)data;

///< 将要切换
- (void) cycleScrollView:(EaseCycleScrollView *)view
         willBeginToggleData:(id)data;
///< 切换
- (void) cycleScrollView:(EaseCycleScrollView *)view
               didToggleData:(id)data atIndex:(NSUInteger)index;
///< 完成切换
- (void) cycleScrollView:(EaseCycleScrollView *)view
         didFinishToggleData:(id)data;

@end
NS_ASSUME_NONNULL_END
