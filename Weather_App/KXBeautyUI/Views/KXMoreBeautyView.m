//
//  KXMoreBeautyView.m
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "KXMoreBeautyView.h"
#import "KXBeautyView.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "KXFaceBeautyModelManager.h"

@interface KXMoreBeautyView ()
@property (nonatomic ,strong) UIView * bgView;
@property (nonatomic ,strong) KXBeautyView * beautyView;
@end

@implementation KXMoreBeautyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void) reloadData{
    [self.beautyView reloadData:KXBeautyManager.beautyArray];
}

- (void)addViews {
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"meiyan_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(backBtn.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bgView addSubview:self.beautyView];
    [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line.mas_bottom).mas_offset(7);
        make.bottom.mas_equalTo(-34);///
    }];
    
    [self reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask  = maskLayer;
}

- (void)backAction:(UIButton *)btn
{
    if (self.bBackAction) {
        self.bBackAction();
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (KXBeautyView *)beautyView
{
    if (!_beautyView) {
        _beautyView = [[KXBeautyView alloc] init];
    }
    return _beautyView;
}

@end
