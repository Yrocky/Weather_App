//
//  UIView+AutoLayoutSupport.h
//  Weather_App
//
//  Created by user1 on 2017/8/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ADKLayoutAttribute) {
    ADKLayoutAttributeTop = 1 << 0,
    ADKLayoutAttributeBottom = 1 << 1,
    ADKLayoutAttributeLeading = 1 << 2,
    ADKLayoutAttributeTrailing = 1 << 3,
    ADKLayoutAttributeWidth = 1 << 4,
    ADKLayoutAttributeHeight = 1 << 5,
    ADKLayoutAttributeLeft = 1 << 6,
    ADKLayoutAttributeRight = 1 << 7,
};

@interface UIView (AutoLayoutSupport)

@property (assign, nonatomic) CGFloat initializedMargin;

- (void)ADKHideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes;

- (void)ADKHideViewWidth;
- (void)ADKUnhideViewWidth;

- (void)ADKHideViewHeight;
- (void)ADKUnhideViewHeight;

- (void)ADKHideTopConstraint;
- (void)ADKUnhideTopConstraint;

- (void)ADKHideBottomConstraint;
- (void)ADKUnhideBottomConstraint;

- (void)ADKHideLeadingConstraint;
- (void)ADKUnhideLeadingConstraint;

- (void)ADKHideTrailingConstraint;
- (void)ADKUnhideTrailingConstraint;

- (void)ADKHideLeftConstraint;
- (void)ADKUnhideLeftConstraint;

- (void)ADKHideRightConstraint;
- (void)ADKUnhideRightConstraint;

///<相当于将left、right、top、bottom、width、height约束都设置为0
- (void) ADKHide;
- (void) ADKShow;

- (void)ADKSetConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute;

- (NSLayoutConstraint *)ADKConstraintForAttribute:(NSLayoutAttribute)attribute;

@end
