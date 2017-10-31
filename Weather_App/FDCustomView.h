//
//  FDCustomView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const FDDidShowAlertViewNotification;
extern NSString * const FDDidDismissAlertViewNotification;

@interface FDCustomView : UIView

// 子类重写，对颜色进行修改
- (UIColor *) themeColor;// themeColor，绿色
- (UIColor *) grayColor;// 在弹出AlertView的时候替换themeColor的颜色

// 子类重写，在AlertView弹出来的时候不显示绿色，改为灰色
- (void) onShowAlertViewGrayThemeAction;

// 子类重写，在AlertView弹出来的时候显示绿色
- (void) onDismissAlertViewGreenThemeAction;
@end

