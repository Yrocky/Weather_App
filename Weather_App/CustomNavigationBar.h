//
//  CustomNavigationBar.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const MMLargeTitleExtraViewHeight;

@interface CustomNavigationBar : UIView

@property (nonatomic, strong) NSString *title; //设置导航标题
@property (nonatomic, strong) NSString *backButtonTitle;//设置导航返回名称

@property (nonatomic, assign) CGFloat maxOffsetY;
//设置最大拉伸模式后，大标题显示最多只能拉伸至`maxOffsetY`像素，相应的UIScrollView也需要限制最大偏移量
@property (nonatomic, assign) BOOL maxStretchMode;

@end

@interface UIViewController (LargeTitleNavigationBar)

@property (nonatomic ,strong ,readonly) CustomNavigationBar * largeTitleNavigationBar;

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
