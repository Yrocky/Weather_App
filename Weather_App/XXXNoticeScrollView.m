//
//  XXXNoticeScrollView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/23.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXNoticeScrollView.h"
#import "Masonry.h"
#import "MMNoRetainTimer.h"

@interface XXXNoticeScrollView ()

@property (nonatomic ,copy) NSArray<UIView *> * contentViews;
@property (nonatomic ,assign) NSInteger offset;///<从contentViews中选取视图的游标

@property (nonatomic ,assign) NSTimeInterval timeInterval;

@property (nonatomic,weak) __block UIView *currentContentView;

@property (nonatomic ,strong) MMNoRetainTimer * timer;
@end

@implementation XXXNoticeScrollView

- (void)dealloc{
    NSLog(@"XXXNoticeScrollView dealloc");
    [self.timer invalidate];
}

- (instancetype) initWithTimeInterval:(NSTimeInterval)timeInterval{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor greenColor];
        
        self.direction = XXXNoticeScrollDirectionVertical;
        self.duration = 0.25;
        self.timeInterval = timeInterval;
    }
    return self;
}

- (void) addContentViews:(NSArray<UIView *> *)contentViews{
    
    if (nil == self.timer && contentViews.count > 1) {
        self.timer = [MMNoRetainTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                              target:self
                                                            selector:@selector(onTimer:)
                                                            userInfo:nil
                                                             repeats:YES];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.contentViews.count) {
        [self.contentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
    }
    self.contentViews = contentViews;
    
    [self addSubviewFromContentViews];
    [self addGestureForContentView];
}

- (void) addSubviewFromContentViews{
    
    for (UIView * view in [self.contentViews reverseObjectEnumerator]) {
        view.mas_key = view.restorationIdentifier;
        [self addSubview:view];
        BOOL isFirst = view == self.contentViews.firstObject;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.direction == XXXNoticeScrollDirectionVertical) {
                if (isFirst) {
                    make.top.mas_equalTo(0);
                } else {
                    make.top.mas_equalTo(self.mas_bottom).priorityLow();
                }
                make.left.equalTo(self);
            } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
                if (isFirst) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(self.mas_right).priorityLow();
                }
                make.top.mas_equalTo(self);
            }
            make.height.equalTo(self);
            make.width.mas_equalTo(self);
        }];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.currentContentView = [self.contentViews firstObject];
}

- (void) addGestureForContentView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tap];
}

- (void) onTap{
    //FIXME:当滑动的时候传递出去的不一定点击的那个视图，需要根据tap来判断落点所在的位置位于哪个视图
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(noticeScrollView:didSelected:at:)]) {
        [self.delegate noticeScrollView:self didSelected:self.contentViews[self.offset] at:self.offset];
    }
}

- (void) onTimer:(MMNoRetainTimer *)timer{
    
    NSLog(@"[Timer] change contentView");
    
    self.offset ++;
    if (self.offset >= self.contentViews.count) {
        self.offset = 0;
    }
    [self changeContentViewAnimationAction];
}

- (void) changeContentViewAnimationAction{
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    NSAssert(self.offset < self.contentViews.count, @"offset计算出错");
    
    UIView * nextView = self.contentViews[self.offset];
    
    [self.currentContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.direction == XXXNoticeScrollDirectionVertical) {
            make.top.mas_equalTo(-height);
        } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
            make.left.mas_equalTo(-width);
        }
    }];
    
    [nextView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.direction == XXXNoticeScrollDirectionVertical) {
            make.top.mas_equalTo(0);
        } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
            make.left.mas_equalTo(0);
        }
    }];
    
    ///<为定时器添加暂停功能，可以避免动画时间大于切换视图间隔的时间
    [_timer pause];
    
    [UIView animateKeyframesWithDuration:self.duration delay:0 options:(UIViewKeyframeAnimationOptionLayoutSubviews|UIViewKeyframeAnimationOptionAllowUserInteraction) animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.currentContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.direction == XXXNoticeScrollDirectionVertical) {
                make.top.mas_equalTo(height);
            } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
                make.left.mas_equalTo(width);
            }
        }];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        [_timer restart];
        
        self.currentContentView = nextView;
    }];
}

@end
