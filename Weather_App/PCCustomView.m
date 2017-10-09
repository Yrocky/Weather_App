//
//  PCCustomView.m
//  PointChat
//
//  Created by Rocky Young on 2017/10/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "PCCustomView.h"
#import "UIColor+Common.h"
#import "Masonry.h"

@implementation PCCustomView{
    UIView * _topSeparatorView;
    UIView * _leftSeparatorView;
    UIView * _bottomSeparatorView;
    UIView * _rightSeparatorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _config];
    }
    return self;
}

- (void) _config{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *(^separatorView)(void) = ^UIView *(){
        UIView * separatorView = [UIView new];
        separatorView.hidden = YES;
        separatorView.backgroundColor = [self customSeparatorColor];
        [self addSubview:separatorView];
        return separatorView;
    };
    _topSeparatorView = separatorView();
    _leftSeparatorView = separatorView();
    _bottomSeparatorView = separatorView();
    _rightSeparatorView = separatorView();
}

- (UIColor *) customSeparatorColor{
    
    return [UIColor colorWithHexString:@"CAC9CF"];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat h = 1/[UIScreen mainScreen].scale;
    
    [_topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(h);
    }];
    
    [_leftSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.and.left.mas_equalTo(self);
        make.width.mas_equalTo(h);
    }];
    
    [_bottomSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self);
        make.height.mas_equalTo(_topSeparatorView);
    }];
    
    [_rightSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.mas_equalTo(self);
        make.width.mas_equalTo(h);
    }];
}

- (void) showSeparatorView:(PCCustomViewSeparator)type{
    
    _topSeparatorView.hidden = !(type & (PCCustomViewSeparatorTop | PCCustomViewSeparatorAll));
    _leftSeparatorView.hidden = !(type & (PCCustomViewSeparatorLeft | PCCustomViewSeparatorAll));
    _bottomSeparatorView.hidden = !(type & (PCCustomViewSeparatorBottom | PCCustomViewSeparatorAll));
    _rightSeparatorView.hidden = !(type & (PCCustomViewSeparatorRight | PCCustomViewSeparatorAll));
}
@end
