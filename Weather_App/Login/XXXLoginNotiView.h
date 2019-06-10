//
//  XXXLoginNotiView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXLoginNotiView : UIView{
    UILabel *_textLabel;
    NSTimeInterval _time;
}
+ (instancetype) notiWith:(NSString *)text;
///<默认2.5s消失
- (instancetype) dismissAfter:(NSTimeInterval)time;

- (void) show;
@end

NS_ASSUME_NONNULL_END
