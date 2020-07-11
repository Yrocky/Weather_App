//
//  MMGradientView.h
//  memezhibo
//
//  Created by user1 on 2017/8/28.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMGradientView : UIView{    
    CAGradientLayer * _gradientLayer;
}
@property (nonatomic ,strong) NSArray <UIColor *>* colors;
@property (nonatomic ,strong) NSArray <UIColor *>* highlightColors;

@property (nonatomic ,strong) NSArray <NSNumber *>* locations;
@property (nonatomic) CGPoint startPoint;// 0,0
@property (nonatomic) CGPoint endPoint;// 1,0

@property (nonatomic ,assign ,readonly) BOOL isHighlighted;

+ (instancetype) gradientView;
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
@end

@interface MMBlurGradientView : MMGradientView{
    UIVisualEffectView *_blurEffectView;
}
+ (instancetype) blurGradientView:(UIBlurEffectStyle)style;
- (instancetype) initWithBlurEffectStyle:(UIBlurEffectStyle)style;
@end
