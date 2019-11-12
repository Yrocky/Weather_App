//
//  KXBeautyFilterCell.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyFilterCell.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface KXBeautyFilterCell ()

@property (nonatomic, strong) UIImageView *filterImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *coverBoard;

@property (nonatomic, strong) UIImageView *sliderIcon;

@property (nonatomic, strong) CAGradientLayer *coverLayer;

@end

@implementation KXBeautyFilterCell

+ (CGSize)cellSize
{
    return CGSizeMake(50, 75);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.filterImageView];
        [self.filterImageView addSubview:self.coverView];
        [self.filterImageView addSubview:self.coverBoard];
//        [self.coverView.layer addSublayer:self.coverLayer];
        [self.filterImageView addSubview:self.sliderIcon];
        [self addSubview:self.nameLabel];
        
        
        [self.filterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(self.filterImageView.mas_width);
        }];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.coverBoard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.sliderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.filterImageView.mas_bottom).mas_offset(8);
            
        }];
        
        [self layoutIfNeeded];
        [self setNeedsLayout];
//        self.coverLayer.frame = self.coverView.bounds;
        
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

- (void)setCellModel:(KXFilterCellModel *)cellModel
{
    _cellModel = cellModel;
    _filterImageView.image = [UIImage imageNamed:cellModel.icon];
    _nameLabel.text = cellModel.name;
    if (_cellModel.isSelected) {
        self.coverView.hidden = NO;
        self.coverBoard.hidden = NO;
        if ([_cellModel.filter isEqualToString:@"origin"]) {
            self.sliderIcon.hidden = YES;
        } else {
            self.sliderIcon.hidden = NO;
        }
    } else {
        self.coverView.hidden = YES;
        self.sliderIcon.hidden = YES;
        self.coverBoard.hidden = YES;
    }
}

- (UIImageView *)filterImageView
{
    if (!_filterImageView) {
        _filterImageView = [[UIImageView alloc] init];
        _filterImageView.layer.masksToBounds = YES;
        _filterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _filterImageView.layer.cornerRadius = 8;
    }
    return _filterImageView;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _coverView;
}

- (UIView *)coverBoard
{
    if (!_coverBoard) {
        _coverBoard = [[UIView alloc] init];
        _coverBoard.backgroundColor = [UIColor clearColor];
        _coverBoard.layer.borderWidth = 1.5;
        _coverBoard.layer.borderColor = [UIColor colorWithHexString:@"#FF2E55"].CGColor;
        _coverBoard.layer.masksToBounds = YES;
        _coverBoard.layer.cornerRadius = 8;
    }
    return _coverBoard;
}

- (CAGradientLayer *)coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [[CAGradientLayer alloc] init];
        _coverLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#C2BBFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#B0CAFF"].CGColor];
        _coverLayer.locations = @[@(0), @(1)];
        _coverLayer.startPoint = CGPointMake(1, 0);
        _coverLayer.endPoint = CGPointMake(1, 1);
    }
    return _coverLayer;
}

- (UIImageView *)sliderIcon
{
    if (!_sliderIcon) {
        _sliderIcon = [[UIImageView alloc] init];
        _sliderIcon.contentMode = UIViewContentModeScaleAspectFit;
        _sliderIcon.image = [UIImage imageNamed:@"meiyan_ljmc"];
    }
    return _sliderIcon;
}

@end
