//
//  CustomNavigationBar.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "CustomNavigationBar.h"
#import <objc/runtime.h>

CGFloat const MMLargeTitleExtraViewHeight = 60;
static CGFloat MMNormalNavigationBarHeight = 44;

#define kMMNormalNavigationBarAndStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + MMNormalNavigationBarHeight)
#define kMMLargeTitleNavigationBarTotalHeight (MMLargeTitleExtraViewHeight + kMMNormalNavigationBarAndStatusBarHeight)


@interface CustomNavigationBar ()

- (void) _navigationBarAnimationWithOffset:(CGFloat)offset;
@end

@implementation CustomNavigationBar

- (void)_navigationBarAnimationWithOffset:(CGFloat)offset{
    
    CGFloat normalNavigationBarHeight = kMMNormalNavigationBarAndStatusBarHeight;
    CGFloat largeTitleExtraViewOffset = normalNavigationBarHeight;
    CGFloat smallTitleAlpha = 0;
    
    if (offset > 0) {// 向上滑动
        if (offset < MMLargeTitleExtraViewHeight) {// bigTitleView逐渐消失
            largeTitleExtraViewOffset = kMMNormalNavigationBarAndStatusBarHeight - offset;
        } else {// bigTitleView完全消失，显示smallTitleView
            largeTitleExtraViewOffset = kMMNormalNavigationBarAndStatusBarHeight - MMLargeTitleExtraViewHeight;// headViewNormalHeight - (self.bigTitleViewHeight - 0);
            smallTitleAlpha = 1;
        }
        
    }else{// 向下滑动
        self.maxStretchMode = YES;
        self.maxOffsetY = 20;// debug
        if (self.maxStretchMode && fabs(offset) > self.maxOffsetY) {
            largeTitleExtraViewOffset = self.maxOffsetY + MMNormalNavigationBarHeight + 0;
            NSLog(@"++++:%f",largeTitleExtraViewOffset);
        }else{
            largeTitleExtraViewOffset -= offset;
        }
    }
    
    //    [UIView animateWithDuration:0.1 animations:^{
    //
    //        [self.navView setNavViewAlpha:smallTitleAlpha];
    //        self.bigTitleView.hf_orgY = bigTitleTop;
    //        self.hf_height = bigTitleTop + self.bigTitleViewHeight;
    //    }];
}


@end


@implementation UIViewController (LargeTitleNavigationBar)


- (void) adjustsScrollViewOffsetAndInsetForLargeTitleNavigationBar:(UIScrollView *)scrollView{
    
    scrollView.contentInset = UIEdgeInsetsMake(MMLargeTitleExtraViewHeight, 0, 0, 0);
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, -MMLargeTitleExtraViewHeight)
                        animated:NO];
}

- (void) executeNavigationBarAnimationWithScrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset = scrollView.contentOffset.y + scrollView.contentInset.top;
    [self.largeTitleNavigationBar _navigationBarAnimationWithOffset:yOffset];
}

#pragma mark - getter and setter

- (CustomNavigationBar *)largeTitleNavigationBar
{
    id largeTitleNavigationBar = objc_getAssociatedObject(self, @selector(largeTitleNavigationBar));
    if (! largeTitleNavigationBar) {
        largeTitleNavigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20 + 44 + 60)];
        //        [self setDynamicNavView:object];
    }
    return largeTitleNavigationBar;
}

- (void)setLargeTitleNavigationBar:(CustomNavigationBar *)largeTitleNavigationBar
{
    objc_setAssociatedObject(self, @selector(largeTitleNavigationBar), largeTitleNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
