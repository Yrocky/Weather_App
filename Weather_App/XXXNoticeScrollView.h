//
//  XXXNoticeScrollView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/23.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,XXXNoticeScrollDirection) {
    XXXNoticeScrollDirectionVertical,///<垂直翻滚
    XXXNoticeScrollDirectionHorizontal,///<水平翻滚
};

@class XXXNoticeScrollView;
@protocol XXXNoticeScrollViewDelegate <NSObject>

- (void) noticeScrollView:(XXXNoticeScrollView *)view didSelected:(UIView *)contentView at:(NSInteger)index;
@end

///<没有重用机制，使用场景为那些简单几个视图轮询滚动的地方
@interface XXXNoticeScrollView : UIView

@property (nonatomic ,weak) id<XXXNoticeScrollViewDelegate> delegate;

@property (nonatomic ,assign) NSTimeInterval duration;///<动画的时间
@property (nonatomic ,assign) XXXNoticeScrollDirection direction;///<default vertical

@property (nonatomic ,assign) BOOL canGestureScroll;///<是否可以使用手势滑动视图

- (instancetype) initWithTimeInterval:(NSTimeInterval)timeInterval;///<视图切换的间隔时间

- (NSInteger) contentViewCount;
- (BOOL) containContentView:(UIView *)contentView;

- (void) addContentView:(UIView *)contentView;
- (void) addContentViews:(NSArray<UIView *> *)contentViews;

- (void) removeContentView:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END
