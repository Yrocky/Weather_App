//
//  KXBeautyCell.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyCell.h"
#import "KXBeautySlider.h"
#import "Masonry.h"
#import "UIColor+Common.h"

#define KXBeautyCellHeight 55

@interface KXBeautyCell ()

@property (nonatomic, strong) UIImageView *beautyIcon;
@property (nonatomic, strong) UILabel *beautyName;
@property (nonatomic, strong) KXBeautySlider *slider;

@end

@implementation KXBeautyCell


+ (CGFloat)height
{
    return KXBeautyCellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.beautyIcon];
        [self addSubview:self.beautyName];
        
        
        [self.beautyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.beautyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.beautyIcon);
            make.top.mas_equalTo(self.beautyIcon.mas_bottom);
            make.height.mas_equalTo(15);
        }];
        
//        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.beautyIcon.mas_right).mas_offset(15);
//            make.top.bottom.right.mas_equalTo(0);
//
////            make.centerY.equalTo(self);
////            make.height.mas_equalTo(20);
//        }];
        
        _slider = [[KXBeautySlider alloc] initWithFrame:CGRectMake(45, 0, frame.size.width - 45, KXBeautyCellHeight) Height:14 type:KXSliderType_def];
        _slider.tipsColor = [UIColor colorWithHexString:@"#333333"];
//        @weakifyyy(self);
        _slider.progressDidChanged = ^(CGFloat progress) {
//            @strongifyyy(self);
            self.beautyModel.value = progress;
        };
        [self addSubview:self.slider];
        
    }
    return self;
}

- (void)setBeautyModel:(KXBeautyCellModel *)beautyModel
{
    _beautyModel = beautyModel;
    self.beautyIcon.image = [UIImage imageNamed:_beautyModel.icon];
    self.beautyName.text = _beautyModel.name;
    self.slider.type = beautyModel.isMidelSlider ? KXSliderType_mid : KXSliderType_def;
    self.slider.progress = _beautyModel.value;
    
}

- (UIImageView *)beautyIcon
{
    if (!_beautyIcon) {
        _beautyIcon = [[UIImageView alloc] init];
        _beautyIcon.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _beautyIcon;
}


- (UILabel *)beautyName
{
    if (!_beautyName) {
        _beautyName = [[UILabel alloc] init];
        _beautyName.font = [UIFont systemFontOfSize:10];
        _beautyName.textAlignment = NSTextAlignmentCenter;
        _beautyName.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _beautyName;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect sliderFrame = CGRectInset(self.slider.frame, -20, 0);
    if (CGRectContainsPoint(sliderFrame, point)) {
        return self.slider;
    }
    return [super hitTest:point withEvent:event];
}

@end
