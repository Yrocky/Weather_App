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

@property (nonatomic ,weak ,readwrite) UIView * contentView;
@property (nonatomic ,strong) MASConstraint * contentViewLeftConstraint;

@property (nonatomic ,strong) UIImageView * snapshotView;
@property (nonatomic ,strong) MASConstraint * snapshotViewLeftConstraint;

@end

@implementation HomeBillContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.direction = HLLStickIndicatorLeft;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.restorationIdentifier = @"scrollView";
        self.scrollView.backgroundColor = [UIColor clearColor];
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
        [self.scrollView addSubview:self.leftIndocatorView];
        [self.leftIndocatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 200));
            make.centerY.mas_equalTo(self.scrollView);
            self.leftIndicatorViewRightConstraint = make.right.mas_equalTo(self.mas_left).mas_offset(0);
        }];
        
        self.rightIndocatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight];
        self.rightIndocatorView.restorationIdentifier = @"right-indocator";
        [self.rightIndocatorView configIndicatorInfo:@"后一天"];
        [self.scrollView addSubview:self.rightIndocatorView];
        [self.rightIndocatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.leftIndocatorView);
            make.centerY.mas_equalTo(self.leftIndocatorView);
            self.rightIndicatorViewLeftConstraint = make.left.mas_equalTo(self.mas_right).mas_offset(0);
        }];
        
        self.snapshotView = [[UIImageView alloc] init];
        self.snapshotView.restorationIdentifier = @"snapshotView";
        self.snapshotView.backgroundColor = [UIColor clearColor];
        self.snapshotView.alpha = 0;
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
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self);
            self.contentViewLeftConstraint = make.left.mas_equalTo(self.mas_left).offset(0);
            make.top.mas_equalTo(self);
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    NSLog(@"contentOffsetX:%f",scrollView.contentOffset.x);
    
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([self canLoadNextContentView] || [self canLoadPreContentView]) {
        
        [self syncSnapshot:^(UIImage *image) {
            self.snapshotView.image = image;
        }];
        self.snapshotView.alpha = 1;
        self.contentView.hidden = 1;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.direction == HLLStickIndicatorLeft && [self canLoadPreContentView]) {
        
        self.tag --;//debug
//        NSLog(@"contentView需要更新👈前一天的数据");
        if (self.delegate && [self.delegate respondsToSelector:@selector(billContainerViewNeedUpdatePreContentView:)]) {
            [self.delegate billContainerViewNeedUpdatePreContentView:self];
        }

        self.contentView.hidden = NO;
//        NSLog(@"将contentView从左边移动到右边，snapView向右移动");
        // 0.85是个估算值，不是系统scrollView滚动到offset为0的动画时间
        [UIView animateWithDuration:.85 delay:0 options:UIViewAnimationOptionPreferredFramesPerSecond60 animations:^{
            self.contentViewLeftConstraint.mas_equalTo(0);
            self.snapshotViewLeftConstraint.mas_equalTo(scrollView.frame.size.width);
            self.snapshotView.alpha = 0;
            [self layoutIfNeeded];// 一定要调用这个，不然没有动画效果
        }completion:^(BOOL finished) {
            self.snapshotViewLeftConstraint.mas_equalTo(0);
        }];
    }
    if (self.direction == HLLStickIndicatorRight && [self canLoadNextContentView]) {
        
        self.tag ++;//debug
//        NSLog(@"contentView需要更新👉后一天的数据");
        if (self.delegate && [self.delegate respondsToSelector:@selector(billContainerViewNeedUpdateNextContentView:)]) {
            [self.delegate billContainerViewNeedUpdateNextContentView:self];
        }
        
//        NSLog(@"将contentView从右边移动到左边，snapView向左移动");
        self.contentView.hidden = NO;
        [UIView animateWithDuration:.85 delay:0 options:UIViewAnimationOptionPreferredFramesPerSecond60 animations:^{
            self.contentViewLeftConstraint.mas_equalTo(0);
            self.snapshotViewLeftConstraint.mas_equalTo(-scrollView.frame.size.width);
            self.snapshotView.alpha = 0;
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.snapshotViewLeftConstraint.mas_equalTo(0);
        }];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if ([self canLoadPreContentView] || [self canLoadNextContentView]) {
        
        CGFloat distance = MAX(fabs(scrollView.contentOffset.x),fabs(targetContentOffset->x)) - MIN(fabs(scrollView.contentOffset.x),fabs(targetContentOffset->x));
        CGFloat duration = distance * 0.46 / 50;// 这个时间是个估算值，不是系统scrollView滚动到offset为0的动画时间
        
        void (^bContentViewAndSnapshotViewMoveToOriginWithAnimation)() = ^{
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionPreferredFramesPerSecond60 animations:^{
                self.contentViewLeftConstraint.mas_equalTo(0);
                self.snapshotViewLeftConstraint.mas_equalTo(0);
                [self layoutIfNeeded];// 一定要调用这个，不然没有动画效果
            }completion:^(BOOL finished) {
                self.contentView.hidden = NO;
                self.snapshotView.alpha = 0;
            }];
        };
        
        if (self.direction == HLLStickIndicatorTop) {
            bContentViewAndSnapshotViewMoveToOriginWithAnimation();
        }
        if (self.direction == HLLStickIndicatorBottom) {
            bContentViewAndSnapshotViewMoveToOriginWithAnimation();
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 在这里对snapshotView进行更新
    [self syncSnapshot:^(UIImage *image) {
        self.snapshotView.image = image;
    }];
    // 防止没有完全归位导致的显示差异
    self.contentViewLeftConstraint.mas_equalTo(0);
}

#pragma mark - update location

- (void) updateLeftIndocatorViewLocationWith:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    self.leftIndocatorView.hidden = NO;
    self.rightIndocatorView.hidden = YES;
    
    [self.leftIndocatorView update:ratio];
    self.leftIndocatorView.canContinues = ratio >= 1;
    self.leftIndicatorViewRightConstraint.mas_equalTo(offset);
    
    if (ratio >= 1) {
        // 获取左边的数据
        self.direction = HLLStickIndicatorLeft;
    }else{
        self.direction = HLLStickIndicatorTop;
    }

    if (![self canLoadPreContentView]) {
        self.contentViewLeftConstraint.mas_equalTo(offset);
    }else if (self.scrollView.isDragging){
        [self moveSnapshotViewToRightWith:offset];
        [self moveContentViewToLeftHandSide];
    }
}

- (void) updateRightIndocatorViewLocationWith:(CGFloat)offset{
    
    CGFloat ratio = offset / 50.0;
    
    self.rightIndocatorView.hidden = NO;
    self.leftIndocatorView.hidden = YES;
    
    [self.rightIndocatorView update:ratio];
    self.rightIndocatorView.canContinues = ratio >= 1;
    self.rightIndicatorViewLeftConstraint.mas_equalTo(-offset);
    
    if (ratio >= 1) {
        // 获取右边的数据
        self.direction = HLLStickIndicatorRight;
    }else{
        self.direction = HLLStickIndicatorBottom;
    }
    
    if (![self canLoadNextContentView]) {
        self.contentViewLeftConstraint.mas_equalTo(-offset);
    }else if (self.scrollView.isDragging){
        [self moveSnapshotViewToLeftWith:offset];
        [self moveContentViewToRightHandSide];
    }
}

#pragma mark - move view

// 将 contentView 移动到左边
- (void) moveContentViewToLeftHandSide{
    self.contentViewLeftConstraint.mas_equalTo(-self.frame.size.width);
}

// 将 contentView 移动到右边
- (void) moveContentViewToRightHandSide{
    self.contentViewLeftConstraint.mas_equalTo(self.frame.size.width);
}

// snapshotView 向右移动
- (void) moveSnapshotViewToRightWith:(CGFloat)offset{
    self.snapshotViewLeftConstraint.mas_equalTo(offset);
}

// snapshotView 向左移动
- (void) moveSnapshotViewToLeftWith:(CGFloat)offset{
    self.snapshotViewLeftConstraint.mas_equalTo(-offset);
}

#pragma mark - edges
- (BOOL) canLoadPreContentView{

    if (self.delegate && [self.delegate respondsToSelector:@selector(allowBillContainerViewLoadPreContentView:)]) {
        return [self.delegate allowBillContainerViewLoadPreContentView:self];
    }
    return 1;
}

- (BOOL) canLoadNextContentView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(allowBillContainerViewLoadNextContentView:)]) {
        return [self.delegate allowBillContainerViewLoadNextContentView:self];
    }
    return 1;
}

- (void) syncSnapshot:(void(^)(UIImage *image))result{
    
    if (self.contentView){
        CGSize size = self.frame.size;
        UIImage *image = nil;
        UIGraphicsBeginImageContextWithOptions(size,
                                               NO,
                                               [UIScreen mainScreen].scale);
        [self.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (result) {
            result(image);
        }
    }
    else if (result) {
        result(nil);
    }
}

@end
