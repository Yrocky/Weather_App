//
//  CustomNavigationBar.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,CustomNavigationBarState) {
    
    CustomNavigationBarNormalState = 1001,// 正常状态
    CustomNavigationBarLargeTitleState,// 大标题
    CustomNavigationBarNormalToLargeTitleState,// 正常状态到大标题过渡
    CustomNavigationBarLargeTitleToNormalState// 大标题到正常状态过渡
};

@interface CustomNavigationBar : UIView

@property (nonatomic, strong) NSString *title; //设置导航标题
@property (nonatomic, strong) NSString *backButtonTitle;//设置导航返回名称

@property (nonatomic ,assign) CustomNavigationBarState barState;

@property (nonatomic, assign) CGFloat maxOffsetY;
//设置最大拉伸模式后，大标题显示最多只能拉伸至`maxOffsetY`像素，相应的UIScrollView也需要限制最大偏移量
@property (nonatomic, assign) BOOL maxStretchMode;

@property (nonatomic ,strong) UIButton * leftBarButton;
@property (nonatomic ,strong) UIButton * rightBarButton;

@property (nonatomic ,strong ,readonly) UIView * customTitleView;
@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,assign) CGFloat navigationBarHeight;
@property (nonatomic ,assign ,readonly) CGFloat navigationBarBottom;

//+ (instancetype) normalNavigationBar;
//+ (instancetype) largeTitleNavigationBar;

- (void) configBottomLine:(UIColor *)lineColor lineHeight:(CGFloat)lineHeight;

/**
 可以手动设置使用默认 通用正常导航
 */
- (void) handleDefaultNormalNavigationBar;

/**
 在滚代理方法里面获取偏移量
 根据变化偏移量设置导航UI效果animation
 
 @param yOffset 变化偏移量
 */
- (void) dynamicNavViewAnimationWithYoffset:(CGFloat)yOffset;


@end

@interface UIViewController (LargeTitleNavigationBar)

@property (nonatomic ,strong ,readonly) CustomNavigationBar * largeTitleNavigationBar;

//- (void) fixed
- (void) addNormalNavigationBar;
- (void) addLargeTitleNavigationBar;

/**
 为了位移的流畅性，内部需要将scrollView进行contentOffset以及contentInset进行修改
 
 @param scrollView scrollView及其子类
 
 @note 如果`导航栏不需要滚动`或者`scrollView滚动的时候导航栏不滚动`可以不调用这个方法进行设置
 */
- (void) adjustsScrollViewOffsetAndInsetForLargeTitleNavigationBar:(UIScrollView *)scrollView;

/**
 当scrollView滚动的时候，对largeTitleNavigationBar进行相应的位移动画
 
 @param scrollView scrollView及其子类
 */
- (void) executeNavigationBarAnimationWithScrollViewDidScroll:(UIScrollView *)scrollView;

@end
