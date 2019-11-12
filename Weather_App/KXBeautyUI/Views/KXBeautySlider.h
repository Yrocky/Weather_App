//
//  KXBeautySlider.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KXSliderType_def = 0,
    KXSliderType_mid,
} KXSliderType;

NS_ASSUME_NONNULL_BEGIN

@interface KXBeautySlider : UIView

@property (nonatomic, copy) void(^progressDidChanged)(CGFloat progress);

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *tipsColor;

@property (nonatomic, assign) KXSliderType type;

- (instancetype)initWithFrame:(CGRect)frame Height:(CGFloat)height type:(KXSliderType)type;

@end

NS_ASSUME_NONNULL_END
