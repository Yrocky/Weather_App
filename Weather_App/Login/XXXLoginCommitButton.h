//
//  XXXLoginCommitButton.h
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXLoginCommitButton : UIButton{
    CAGradientLayer * _gradientLayer;
}
- (void) setupTitle:(NSString *)title;
- (void) showGradient:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
