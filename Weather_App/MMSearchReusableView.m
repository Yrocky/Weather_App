//
//  MMSearchReusableView.m
//  memezhibo
//
//  Created by user1 on 2017/7/12.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import "MMSearchReusableView.h"
#import "UIColor+Common.h"
#import <Masonry/Masonry.h>

@implementation MM_SearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"F3F6FB"];
        
        //
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"Ffffff"];
        [self addSubview:self.backgroundView];
        
        //
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.backgroundView addSubview:self.titleLabel];
        
        //
        self.handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.handleButton setTitleColor:[UIColor colorWithHexString:@"#2B2B2B"] forState:UIControlStateNormal];
        self.handleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.handleButton.hidden = YES;
        [self.backgroundView addSubview:self.handleButton];
    }
    return self;
}

- (void) setHandleText:(NSString *)text{
 
    [self.handleButton setTitle:text forState:UIControlStateNormal];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundView.mas_top).mas_offset(12);
        make.left.mas_equalTo(8);
    }];
    
    [self.handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.width.mas_greaterThanOrEqualTo(20);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
}
@end

@implementation MM_SearchFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithHexString:@"#F3F6FB"];
    }
    return self;
}
@end
@implementation MMTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 3;
        self.contentView.layer.borderWidth = 1;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end
