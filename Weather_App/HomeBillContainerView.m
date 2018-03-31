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

@property (nonatomic ,assign) HLLStickIndicatorDirection direction;

@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic ,strong) HLLStickIndicatorView * leftIndocatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * rightIndocatorView;

@property (nonatomic ,strong) MASConstraint * leftIndicatorViewRightConstraint;
@property (nonatomic ,strong) MASConstraint * rightIndicatorViewLeftConstraint;

@property (nonatomic ,weak) UIView * contentView;
@property (nonatomic ,strong) MASConstraint * contentViewLeftConstraint;

@property (nonatomic ,strong) UIView * snapshotView;
@property (nonatomic ,strong) MASConstraint * snapshotViewLeftConstraint;

@end

@implementation HomeBillContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.direction = HLLStickIndicatorLeft;
        
        self.backgroundColor = [UIColor orangeColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.restorationIdentifier = @"scrollView";
        self.scrollView.backgroundColor = [UIColor greenColor];
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
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
        
        self.snapshotView = [[UIView alloc] init];
        self.snapshotView.restorationIdentifier = @"snapshotView";
        self.snapshotView.userInteractionEnabled = NO;
        self.snapshotView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.snapshotView];
        [self.snapshotView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.snapshotViewLeftConstraint = make.left.mas_equalTo(self.mas_left).offset(0);
            make.top.mas_equalTo(self);
            make.size.mas_equalTo(self);
        }];
    }
    return self;
}

- (void) configBillContentView:(__kindof UIView *)contentView{
    
    if (contentView) {
        self.contentView = contentView;
        self.contentView.restorationIdentifier = @"contentView";
//        [self.scrollView addSubview:self.contentView];
//        [self.scrollView insertSubview:self.contentView belowSubview:self.snapshotView];
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.and.bottom.mas_equalTo(self.scrollView);
//            self.contentViewLeftConstraint = make.left.mas_equalTo(self.scrollView).offset(0);
//            self.contentViewRightConstraint = make.right.mas_equalTo(self.scrollView).offset(0);
//        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    NSLog(@"contentOffset:%f",scrollView.contentOffset.x);
    
    CGFloat offset = fabs(scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.x > 0) {// 向左滑

        [self updateRightIndocatorViewLocationWith:offset];
    }
    else if (scrollView.contentOffset.x < 0){
        
        [self updateLeftIndocatorViewLocationWith:offset];
    }else{
        self.leftIndocatorView.hidden = self.rightIndocatorView.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.direction == HLLStickIndicatorLeft) {
        NSLog(@"需要去获取左边的数据，并且将contentView从左边移动到右边，snapView向右移动");
        [UIView animateWithDuration:2 animations:^{
            self.snapshotViewLeftConstraint.mas_equalTo(scrollView.frame.size.width);
//            self.snapshotView.alpha = 0;
        }completion:^(BOOL finished) {
            self.snapshotViewLeftConstraint.mas_equalTo(0);
        }];
    }
    if (self.direction == HLLStickIndicatorRight) {
        NSLog(@"需要去获取右边的数据，并且将contentView从右边移动到左边，snapView向左移动");
        [UIView animateWithDuration:2 animations:^{
            self.snapshotViewLeftConstraint.mas_equalTo(-scrollView.frame.size.width);
//            self.snapshotView.alpha = 0;
        }completion:^(BOOL finished) {
            self.snapshotViewLeftConstraint.mas_equalTo(0);
        }];
    }
    NSLog(@"direction:%lu",(unsigned long)self.direction);
}

#pragma mark - update location

- (void) updateLeftIndocatorViewLocationWith:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    
    self.leftIndocatorView.hidden = NO;
    self.rightIndocatorView.hidden = YES;
    
    [self.leftIndocatorView update:ratio];
    self.leftIndocatorView.canContinues = ratio >= 1;
    self.leftIndicatorViewRightConstraint.mas_equalTo(offset);
    
    [self moveSnapshotViewToRightWith:offset];
    
    if (ratio >= 1) {
        // 获取左边的数据
        self.direction = HLLStickIndicatorLeft;
    }else{
        self.direction = HLLStickIndicatorTop;
    }
}

- (void) updateRightIndocatorViewLocationWith:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    
    self.rightIndocatorView.hidden = NO;
    self.leftIndocatorView.hidden = YES;
    
    [self.rightIndocatorView update:ratio];
    self.rightIndocatorView.canContinues = ratio >= 1;
    self.rightIndicatorViewLeftConstraint.mas_equalTo(-offset);
    
    [self moveSnapshotViewToLeftWith:offset];
    
    if (ratio >= 1) {
        // 获取右边的数据
        self.direction = HLLStickIndicatorRight;
    }else{
        self.direction = HLLStickIndicatorBottom;
    }
}

// 向右移动
- (void) moveSnapshotViewToRightWith:(CGFloat)offset{
    
    if (self.scrollView.isDragging) {
        self.snapshotViewLeftConstraint.mas_equalTo(offset);
    }
}

// 向左移动
- (void) moveSnapshotViewToLeftWith:(CGFloat)offset{
    
    if (self.scrollView.isDragging) {
        self.snapshotViewLeftConstraint.mas_equalTo(-offset);
    }
}

@end
