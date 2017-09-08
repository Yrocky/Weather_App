//
//  HLLSegmentView.h
//  Weather_App
//
//  Created by user1 on 2017/8/23.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,DraggingState) {
    DraggingStateNone,
    DraggingStateDragging,
    DraggingStateCancel
};

@interface HLLSegmentView : UIView

@property (nonatomic ,strong) IBInspectable UIFont * defaultTextFont;
@property (nonatomic ,strong) IBInspectable UIFont * selectedTextFont;

@property (nonatomic ,strong) IBInspectable UIColor * defaultTextColor;
@property (nonatomic ,strong) IBInspectable UIColor * selectedTextColor;

@property (nonatomic ,assign) IBInspectable BOOL useGradient;

@property (nonatomic ,strong) IBInspectable UIColor * containerBackgroundColor;
@property (nonatomic ,strong) IBInspectable UIColor * thumbColor;
@property (nonatomic ,strong) IBInspectable NSArray * thumbGradientColors;
@property (nonatomic ,strong) IB_DESIGNABLE UIColor * thumbShadowColor;
@property (nonatomic ,assign) IBInspectable BOOL useShadow;

@property (nonatomic ,assign) IBInspectable CGSize padding;
@property (nonatomic ,assign) IBInspectable CGFloat cornerRadius;

@end
