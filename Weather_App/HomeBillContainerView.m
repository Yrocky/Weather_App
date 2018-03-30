//
//  HomeBillContainerView.m
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContainerView.h"
#import "HLLStickIndicator.h"
#import "Masonry.h"

@interface HomeBillContainerView()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic ,strong) HLLStickIndicatorView * leftIndocatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * rightIndocatorView;

@property (nonatomic ,strong) MASConstraint * leftIndicatorViewRightConstraint;
@property (nonatomic ,strong) MASConstraint * rightIndicatorViewLeftConstraint;

@property (nonatomic ,strong) UIView * oneView;
@property (nonatomic ,strong) UIView * twoView;
@end

@implementation HomeBillContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.restorationIdentifier = @"scrollView";
        self.scrollView.backgroundColor = [UIColor greenColor];
        self.scrollView.alwaysBounceHorizontal = YES;
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.leftIndocatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorLeft];
        self.leftIndocatorView.restorationIdentifier = @"left-indocator";
        [self.leftIndocatorView configIndicatorInfo:@"前一天"];
        [self addSubview:self.leftIndocatorView];
        [self.leftIndocatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 200));
            make.centerY.mas_equalTo(self);
            self.leftIndicatorViewRightConstraint = make.right.mas_equalTo(self.mas_left).mas_offset(0);
        }];
        
        self.rightIndocatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight];
        self.rightIndocatorView.restorationIdentifier = @"right-indocator";
        [self.rightIndocatorView configIndicatorInfo:@"后一天"];
        [self addSubview:self.rightIndocatorView];
        [self.rightIndocatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.leftIndocatorView);
            make.centerY.mas_equalTo(self.leftIndocatorView);
            self.rightIndicatorViewLeftConstraint = make.left.mas_equalTo(self.mas_right).mas_offset(0);
        }];
        
        self.oneView = [UIView new];
        self.oneView.backgroundColor = [UIColor redColor];
        [self addSubview:self.oneView];
        [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self);
        }];
        
        self.twoView = [UIView new];
        self.twoView.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.twoView];
        [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    NSLog(@"contentOffset:%f",scrollView.contentOffset.x);
    
    CGFloat offset = fabs(scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.x > 0) {// 向左滑

        [self updateRightIndocatorViewLocation:offset];
    }
    else if (scrollView.contentOffset.x < 0){
        
        [self updateLeftIndocatorViewLocation:offset];
    }else{
        self.leftIndocatorView.hidden = self.rightIndocatorView.hidden = YES;
    }
}

- (void) updateLeftIndocatorViewLocation:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    
    self.leftIndocatorView.hidden = NO;
    self.rightIndocatorView.hidden = YES;
    
    [self.leftIndocatorView update:ratio];
    self.leftIndicatorViewRightConstraint.mas_equalTo(offset);
}

- (void) updateRightIndocatorViewLocation:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    
    self.rightIndocatorView.hidden = NO;
    self.leftIndocatorView.hidden = YES;
    
    [self.rightIndocatorView update:ratio];
    self.rightIndicatorViewLeftConstraint.mas_equalTo(-offset);
}
@end
