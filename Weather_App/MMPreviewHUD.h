//
//  MMPreviewHUD.h
//  Weather_App
//
//  Created by Rocky Young on 2017/9/14.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMPreviewHUD : UIView

+ (void) showHUD:(NSString *)text inView:(UIView *)view target:(id)target action:(SEL)action;
+ (void) showHUD:(NSString *)text inViewController:(UIViewController *)v action:(SEL)action;

@end

