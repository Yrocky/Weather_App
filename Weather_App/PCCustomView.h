//
//  PCCustomView.h
//  PointChat
//
//  Created by Rocky Young on 2017/10/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger ,PCCustomViewSeparator) {
    PCCustomViewSeparatorNone        = 0,
    PCCustomViewSeparatorTop         = 1 << 0,
    PCCustomViewSeparatorLeft        = 1 << 1,
    PCCustomViewSeparatorBottom      = 1 << 2,
    PCCustomViewSeparatorRight       = 1 << 3,
    PCCustomViewSeparatorAll         = 1 << 4,
};

@interface PCCustomView : UIView

- (void) showSeparatorView:(PCCustomViewSeparator)type;

// 子类可以重写修改分割线颜色
- (UIColor *) customSeparatorColor;
@end
