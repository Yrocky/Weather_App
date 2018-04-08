//
//  BillKeyboardView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/6.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillKeyboardView;
@protocol BillKeyboardViewDelegate<NSObject>

- (void) billKeyboardViewOutput:(BillKeyboardView *)keyboardView text:(NSString *)text;
- (void) billKeyboardViewDidDone:(BillKeyboardView *)keyboardView;
@end

@interface BillKeyboardView : UIView

@end
