//
//  BottomCommitView.m
//  Weather_App
//
//  Created by user1 on 2017/11/13.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "BottomFollowView.h"
#import "UIColor+Common.h"
#import "Masonry.h"

@implementation BottomFollowView
+ (instancetype) commitView{
    
    return [[[self class] alloc] init];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithHexString:@"#D2DAE8"];
        
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setBackgroundColor:[UIColor colorWithHexString:@"#2A3142"]];
        [_followButton setTitle:@"Follow" forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _followButton.layer.cornerRadius = 20;
        _followButton.layer.masksToBounds = YES;
        [_contentView addSubview:_followButton];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_followButton.mas_top).mas_offset(-20);
        }];
        
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            CGFloat margin = 10;
            make.size.mas_equalTo(CGSizeMake(120, 40));
            make.centerX.mas_equalTo(_contentView);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(_contentView.mas_safeAreaLayoutGuideBottom).mas_offset(0);
            } else {
                make.bottom.mas_equalTo(_contentView.mas_bottom).mas_offset(-margin);
            }
        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    _contentView.layer.mask = maskLayer;
}

@end

