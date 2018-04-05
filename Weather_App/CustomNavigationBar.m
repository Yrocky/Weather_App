//
//  CustomNavigationBar.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "CustomNavigationBar.h"
#import <objc/runtime.h>

static CGFloat MMLargeTitleExtraViewHeight = 48;
static CGFloat MMNormalNavigationBarHeight = 44;

#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

// 状态栏+正常状态下的导航栏
#define kMMNormalNavigationBarAndStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + MMNormalNavigationBarHeight)
// 状态栏+正常状态的导航栏+附加大标题
#define kMMLargeTitleNavigationBarTotalHeight (MMLargeTitleExtraViewHeight + kMMNormalNavigationBarAndStatusBarHeight)


@interface CustomNavigationBar ()

+ (instancetype) largeTitleNavigationBar;
- (void) _navigationBarAnimationWithOffset:(CGFloat)offset;
@end

@implementation CustomNavigationBar

+ (instancetype) largeTitleNavigationBar{
    CustomNavigationBar * largeTitle = [[CustomNavigationBar alloc] initWithFrame:(CGRect){
        CGPointZero,
        [UIScreen mainScreen].bounds.size.width,
        kMMLargeTitleNavigationBarTotalHeight
    }];
    largeTitle.backgroundColor = [UIColor orangeColor];
    return largeTitle;
}

- (void)configBottomLine:(UIColor *)lineColor lineHeight:(CGFloat)lineHeight{
    
}

- (void)_navigationBarAnimationWithOffset:(CGFloat)yOffset{
    
    CGFloat normalNavigationBarHeight = kMMNormalNavigationBarAndStatusBarHeight;
    CGFloat largeTitleExtraViewOffset = normalNavigationBarHeight;
    CGFloat smallTitleAlpha = 0;
    
    if (yOffset > 0) {// 向上滑动
        if (yOffset < MMLargeTitleExtraViewHeight) {// bigTitleView逐渐消失
            largeTitleExtraViewOffset = kMMNormalNavigationBarAndStatusBarHeight - yOffset;
        } else {// bigTitleView完全消失，显示smallTitleView
            largeTitleExtraViewOffset = kMMNormalNavigationBarAndStatusBarHeight - MMLargeTitleExtraViewHeight;// headViewNormalHeight - (self.bigTitleViewHeight - 0);
            smallTitleAlpha = 1;
        }
        
    }else{// 向下滑动
//        self.maxStretchMode = YES;// debug
//        self.maxOffsetY = 20;// debug
        if (self.maxStretchMode && fabs(yOffset) > self.maxOffsetY) {
            largeTitleExtraViewOffset = self.maxOffsetY + MMNormalNavigationBarHeight + 0;
            NSLog(@"++++:%f",largeTitleExtraViewOffset);
        }else{
            largeTitleExtraViewOffset -= yOffset;
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = largeTitleExtraViewOffset + MMLargeTitleExtraViewHeight;
    _navigationBarBottom = frame.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        
        self.frame = frame;
        //            [self.navView setNavViewAlpha:smallTitleAlpha];
        //            self.bigTitleView.hf_orgY = bigTitleTop;
        //            self.hf_height = bigTitleTop + self.bigTitleViewHeight;
    }];
}


@end


@implementation UIViewController (LargeTitleNavigationBar)

- (void) addNormalNavigationBar{
    self.largeTitleNavigationBar.barState = CustomNavigationBarNormalState;
    [self.largeTitleNavigationBar _navigationBarAnimationWithOffset:MMLargeTitleExtraViewHeight];
}

- (void) addLargeTitleNavigationBar{
    self.largeTitleNavigationBar.barState = CustomNavigationBarLargeTitleState;
    [self.largeTitleNavigationBar _navigationBarAnimationWithOffset:0];
}

- (void) adjustsScrollViewOffsetAndInsetForLargeTitleNavigationBar:(UIScrollView *)scrollView{
    
//    scrollView.contentInset = UIEdgeInsetsMake(MMLargeTitleExtraViewHeight, 0, 0, 0);
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, -MMLargeTitleExtraViewHeight)
                        animated:NO];
}

- (void) executeNavigationBarAnimationWithScrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset = scrollView.contentOffset.y + scrollView.contentInset.top;
    NSLog(@"yOffset:%f",yOffset);
    [self.largeTitleNavigationBar _navigationBarAnimationWithOffset:yOffset];
}

#pragma mark - getter and setter

- (CustomNavigationBar *) largeTitleNavigationBar {
    CustomNavigationBar *largeTitleNavigationBar = objc_getAssociatedObject(self, @selector(largeTitleNavigationBar));
    if (!largeTitleNavigationBar) {
        largeTitleNavigationBar = [CustomNavigationBar largeTitleNavigationBar];
        objc_setAssociatedObject(self, @selector(largeTitleNavigationBar), largeTitleNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:largeTitleNavigationBar];
    }
    
    return largeTitleNavigationBar;
}

@end
