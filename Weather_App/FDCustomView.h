//
//  FDCustomView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger ,FDCustomViewSeparator) {
    FDCustomViewSeparatorNone        = 0,
    FDCustomViewSeparatorTop         = 1 << 0,
    FDCustomViewSeparatorLeft        = 1 << 1,
    FDCustomViewSeparatorBottom      = 1 << 2,
    FDCustomViewSeparatorRight       = 1 << 3,
    FDCustomViewSeparatorAll         = 1 << 4,
};
@interface FDCustomView : UIView

- (void) showSeparatorView:(FDCustomViewSeparator)type;

// 子类可以重写修改分割线颜色
- (UIColor *) customSeparatorColor;
@end

