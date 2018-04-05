//
//  HomeBillContentDefaultView.m
//  Weather_App
//
//  Created by user1 on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContentDefaultView.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface HomeBillContentDefaultView()

@property (nonatomic ,strong) UIImageView * defaultImageView;
@property (nonatomic ,strong) UILabel * defaultTitleLabel;
@property (nonatomic ,strong) UILabel * defaultDetailLabel;
@end

@implementation HomeBillContentDefaultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultImageView = [[UIImageView alloc] init];
        self.defaultImageView.backgroundColor = [UIColor clearColor];
        self.defaultImageView.image = [UIImage imageNamed:@"home_bill_list_empty"];
        [self addSubview:self.defaultImageView];
        
        _defaultTitleLabel = [UILabel new];
        self.defaultTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.defaultTitleLabel.text = @"无记账";
        self.defaultTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
        self.defaultTitleLabel.textColor = [UIColor colorWithHexString:@"363B40"];
        [self addSubview:self.defaultTitleLabel];
        
        _defaultDetailLabel = [UILabel new];
        self.defaultDetailLabel.textAlignment = NSTextAlignmentCenter;
        self.defaultDetailLabel.text = @"点击下面的按钮开始记账吧";
        self.defaultDetailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        self.defaultDetailLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];
        [self addSubview:self.defaultDetailLabel];
        
        [self.defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(154);
            make.height.mas_equalTo(152);
        }];
        
        [self.defaultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(self);
            make.top.mas_equalTo(self.defaultImageView.mas_bottom).mas_offset(7);
            make.height.mas_equalTo(24);
        }];
        
        [self.defaultDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.top.mas_equalTo(self.defaultTitleLabel.mas_bottom).mas_offset(7);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}


@end
