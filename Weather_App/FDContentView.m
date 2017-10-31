//
//  FDContentView.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDContentView.h"
#import "ANYMethodLog.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "CLTStickyLayout.h"
#import "HLLStickIndicator.h"
#import "FDCollectionView.h"
#import "HLLAttributedBuilder.h"

@interface FDContentView()<UIScrollViewDelegate,FDCollectionViewMoveDirectionDelegate>

@property (nonatomic ,assign) CGFloat contentViewBeginPointY;
@property (nonatomic ,assign) CGFloat contentViewNextPointY;

@property (nonatomic ,strong) UIScrollView * contentView;
@property (nonatomic ,strong) UIView * contentBackgroundView;
@property (nonatomic ,strong) MASConstraint * bgViewHeightConstraint;

@property (nonatomic ,strong) UIView * headerView;

@property (nonatomic ,strong) CLTStickyLayout * layout;
@property (nonatomic ,strong) FDCollectionView * collectionView;
@property (nonatomic ,strong) MASConstraint * collectionViewLeftConstraint;

// stickIndicator
@property (nonatomic ,strong) HLLStickIndicatorView * topIndicatorView;

@property (nonatomic ,strong) HLLStickIndicatorView * leftIndicatorView;
@property (nonatomic ,strong) MASConstraint * leftIndicatorViewRightConstraint;

@property (nonatomic ,strong) HLLStickIndicatorView * rightIndicatorView;
@property (nonatomic ,strong) MASConstraint * rightIndicatorViewLeftConstraint;

@property (nonatomic ,strong) UIView * snapshotView;
@property (nonatomic ,strong) MASConstraint * snapshotViewLeftConstraint;
@end

@implementation FDContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self fd_addSubviews];
    }
    return self;
}

- (void) fd_addSubviews{
    
    self.backgroundColor = [UIColor clearColor];
    
    // content View
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.delegate = self;
    self.contentView.restorationIdentifier = @"contentView";
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.alwaysBounceVertical = YES;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    // contnet background View
    self.contentBackgroundView = [UIView new];
    self.contentBackgroundView.restorationIdentifier = @"contentBackgroundView";
    self.contentBackgroundView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentBackgroundView];
    
    [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView);
        self.bgViewHeightConstraint = make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    // header View
    self.headerView = [UIView new];
    self.headerView.restorationIdentifier = @"headerView";
    self.headerView.backgroundColor = [UIColor redColor];
    [self.contentBackgroundView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.top.and.right.and.left.mas_equalTo(self.contentBackgroundView);
    }];
    
    // collection View
    self.layout = [[CLTStickyLayout alloc] init];
    self.layout.itemSize = CGSizeMake(50, 30);
    self.layout.stickyHeader = YES;
    _collectionView = [[FDCollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:self.layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.fd_delegate = self;
    self.collectionView.restorationIdentifier = @"collectionView";
    self.collectionView.alwaysBounceHorizontal = YES;
    [self.contentBackgroundView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.collectionViewLeftConstraint = make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentBackgroundView.mas_right);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.contentBackgroundView.mas_bottom);
    }];
    [self.layout invalidateLayoutCache];
    
    NSAttributedString * topIndicatorViewText;
    NSDictionary * normalStyle =@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                  };
    NSDictionary * _normalStyle =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                  NSForegroundColorAttributeName:[UIColor redColor]
                                  };
    topIndicatorViewText = [[[HLLAttributedBuilder builderWithString:@"下拉切换" defaultStyle:normalStyle] appendString:@"日视图" forStyle:_normalStyle] attributedString];
    // 1.topIndicator View
    self.topIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorTop];
    self.topIndicatorView.restorationIdentifier = @"topIndicatorView";
    [self.topIndicatorView configIndicatorInfoAttributesString:topIndicatorViewText];
    [self.contentView addSubview:self.topIndicatorView];
    [self.topIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_top);
    }];
    
    // 2.leftIndicator View
    self.leftIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorLeft];
    self.leftIndicatorView.restorationIdentifier = @"leftIndicatorView";
    [self.leftIndicatorView configIndicatorInfo:@"加载\n前一篇"];
    [self.contentBackgroundView addSubview:self.leftIndicatorView];
    [self.leftIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 200));
        make.centerY.mas_equalTo(_collectionView);
        self.leftIndicatorViewRightConstraint = make.right.mas_equalTo(_collectionView.mas_left).mas_offset(0);
    }];
    
    
    // 3.rightIndicator View
    self.rightIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight];
    self.rightIndicatorView.restorationIdentifier = @"rightIndicatorView";
    [self.rightIndicatorView configIndicatorInfo:@"加载\n下一篇"];
    [self.contentBackgroundView addSubview:self.rightIndicatorView];
    [self.rightIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.leftIndicatorView);
        make.centerY.mas_equalTo(self.leftIndicatorView);
        self.rightIndicatorViewLeftConstraint = make.left.mas_equalTo(self.headerView.mas_right).mas_offset(0);
    }];
    
    // snapshot View
    self.snapshotView = [[UIView alloc] init];
    self.snapshotView.restorationIdentifier = @"snapshotView";
    self.snapshotView.userInteractionEnabled = NO;
    self.snapshotView.alpha = 1;
    self.snapshotView.backgroundColor = [UIColor clearColor];
    [self.contentBackgroundView addSubview:self.snapshotView];
    [self.snapshotView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.snapshotViewLeftConstraint = make.left.mas_equalTo(0);
        make.top.and.right.and.bottom.mas_equalTo(self.collectionView);
    }];
}

- (void) previousAnimation{

    [self _animation:YES];
}

- (void) behindAnimation{
 
    [self _animation:NO];
}

- (void) _animation:(BOOL)isPrevious{
    
    CGRect collectionViewFrame = self.collectionView.frame;
    CGFloat offset = (isPrevious ? 2 : -2 ) * collectionViewFrame.size.width;
    self.collectionView.alpha = 0;
    self.collectionViewLeftConstraint.mas_equalTo(offset);
    
    self.snapshotView.alpha = 0;
    CGRect snapshotViewFrame = self.snapshotView.frame;
    
    [UIView animateWithDuration:1.25 animations:^{
        
        self.collectionView.alpha = 1;
        self.snapshotView.alpha = 0;
        [self layoutIfNeeded];
        self.collectionViewLeftConstraint.mas_equalTo(0);
        self.snapshotViewLeftConstraint.mas_equalTo(-snapshotViewFrame.size.width);
    } completion:^(BOOL finished) {
        self.snapshotViewLeftConstraint.mas_equalTo(0);
        [self.snapshotView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }];
}
#pragma mark - API

- (void) modifContentViewHeight:(CGFloat)height{
    
    self.bgViewHeightConstraint.mas_equalTo(height);
}

- (void) configCollectionView:(void (^)(UICollectionView *))handle{
    
    if (handle) {
        handle(_collectionView);
    }
}
#pragma mark - FDCollectionViewMoveDirectionDelegate
// 向右移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToLeftContentOffset:(CGFloat)offset{
    
    CGPoint contentOffset = collectionView.contentOffset;
    [collectionView setContentOffset:CGPointMake(offset, contentOffset.y)];
    
    [self.leftIndicatorView update:fabs(offset) / 60];
    self.leftIndicatorView.canContinues = fabs(offset) >= 60;
    self.leftIndicatorViewRightConstraint.mas_equalTo(self.leftIndicatorView.canContinues ? 60 : fabs(offset));
}

// 向左移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToRightContentOffset:(CGFloat)offset{

    CGPoint contentOffset = collectionView.contentOffset;
    [collectionView setContentOffset:CGPointMake(offset, contentOffset.y)];
    
    [self.rightIndicatorView update:fabs(offset) / 60];
    self.rightIndicatorView.canContinues = -offset <= -60;
    self.rightIndicatorViewLeftConstraint.mas_equalTo(self.rightIndicatorView.canContinues ? -60 : -offset);
}

// 向上移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToUpContentOffset:(CGFloat)offset{
    
    collectionView.alwaysBounceVertical = YES;
    collectionView.alwaysBounceHorizontal = NO;
}
// 向下移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToDownContentOffset:(CGFloat)offset{
    
    collectionView.alwaysBounceVertical = YES;
    collectionView.alwaysBounceHorizontal = NO;
}

// 结束移动
- (void)collectionViewDidEndMove:(FDCollectionView *)collectionView{
    
    // 快照
    [self.snapshotView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIView * snapshotView = [collectionView snapshotViewAfterScreenUpdates:YES];
    [self.snapshotView addSubview:snapshotView];
    
    // 指示视图
    void (^indicatorViewHandle)() = ^void(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            collectionView.alwaysBounceHorizontal = YES;
        });
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.leftIndicatorView update:0];
            [self.rightIndicatorView update:0];
            
            [self layoutIfNeeded];
            self.rightIndicatorViewLeftConstraint.mas_equalTo(0);
            self.leftIndicatorViewRightConstraint.mas_equalTo(0);
        } completion:nil];
    };
    
    indicatorViewHandle();
    // 动画
    if (collectionView.moveDirection == FDCollectionViewMoveRight &&
        self.leftIndicatorView.canContinues) {
        if (self.delegate) {
            [self.delegate contentViewDidExecuteChangePrevious:self];
        }
        [self previousAnimation];
    }else if (collectionView.moveDirection == FDCollectionViewMoveLeft &&
              self.rightIndicatorView.canContinues){
        if (self.delegate) {
            [self.delegate contentViewDidExecuteChangeBehind:self];
        }

        [self behindAnimation];
    }else{
        self.snapshotView.alpha = 0;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat percent = (fabs(scrollView.contentOffset.y) - 0.0) / 60;
    [self.topIndicatorView update:percent];
    self.topIndicatorView.canContinues = percent >= 1;
    
    self.contentViewNextPointY = scrollView.contentOffset.y;
    
    CGFloat zeroContentOffsetY = 0;
    
    if (@available(iOS 11.0, *)) {
        zeroContentOffsetY = 0;
    } else {
        zeroContentOffsetY = 0;
    }

    CGPoint zeroContentOffset = (CGPoint){
        0,zeroContentOffsetY
    };
    
    bool contentViewScrollDirectionDown = NO;// 是否向下拉
    contentViewScrollDirectionDown = self.contentViewBeginPointY >= self.contentViewNextPointY;
    if (!contentViewScrollDirectionDown) {
        [self.contentView setContentOffset:zeroContentOffset animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.contentViewBeginPointY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (self.topIndicatorView.canContinues) {
        if (self.delegate) {
            [self.delegate contentViewDidExecuteChangeDisplayType:self];
        }
    }
}
@end
