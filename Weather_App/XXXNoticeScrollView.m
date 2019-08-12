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

@interface XXXNoticeScrollView ()<UIGestureRecognizerDelegate>{
    BOOL _didAddGesture;
    
    BOOL _isChangeToNextView;
    BOOL _canChangeForPanGesture;
}

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

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithTimeInterval:4.0f];
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

- (NSInteger) contentViewCount{
    return self.contentViews.count;
}

- (BOOL) containContentView:(UIView *)contentView{
    if (!contentView) {
        return NO;
    }
    return [self.contentViews containsObject:contentView];
}

- (void) addContentView:(UIView *)contentView{
    if ([self containContentView:contentView]) {
        return;
    }
    NSMutableArray<UIView *> * temp = [NSMutableArray array];
    if (self.contentViews.count) {
        [temp addObjectsFromArray:self.contentViews];
    }
    [temp addObject:contentView];
    [self addContentViews:temp.copy];
    [self restartTimerIfNeeded];
}

- (void) removeContentView:(UIView *)contentView{
    
    if (![self containContentView:contentView]) {
        return;
    }
    NSMutableArray<UIView *> * temp = [self.contentViews mutableCopy];
    [temp removeObject:contentView];
    [self addContentViews:temp.copy];
    [self restartTimerIfNeeded];
}

- (void) addContentViews:(NSArray<UIView *> *)contentViews{
    
    if (nil == self.timer && contentViews.count > 1) {
        self.timer = [MMNoRetainTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                              target:self
                                                            selector:@selector(onTimer:)
                                                            userInfo:nil
                                                             repeats:YES];
    } else {
        [self.timer pause];
    }
    
    self.offset = 0;
    
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
    if (!_didAddGesture) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(onPan:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        _didAddGesture = YES;
    }
}

- (void) onTap{
    //FIXME:当滑动的时候传递出去的不一定点击的那个视图，需要根据tap来判断落点所在的位置位于哪个视图
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(noticeScrollView:didSelected:at:)]) {
        [self.delegate noticeScrollView:self didSelected:self.contentViews[self.offset] at:self.offset];
    }
}

- (void) onPan:(UIPanGestureRecognizer *)gesture{

    CGFloat offset = 0.0f;
    CGFloat velocity = 0.0f;
    CGPoint movePoint = CGPointZero;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.timer pause];
            break;
        case UIGestureRecognizerStateChanged:
            movePoint = [gesture translationInView:gesture.view];
            if (self.direction == XXXNoticeScrollDirectionVertical) {
                ///<正是向下，负是向上
                offset = movePoint.y;
                velocity = [gesture velocityInView:gesture.view].y;
            } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
                ///<正是向右，负是向左
                offset = movePoint.x;
                velocity = [gesture velocityInView:gesture.view].x;
            }
            [self changeContentViewWithGestureOffset:offset velocity:velocity];
            [gesture setTranslation:CGPointZero inView:gesture.view];
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self endChangeContentViewWithGesture];
            break;
        default:
            break;
    }
}

- (void) onTimer:(MMNoRetainTimer *)timer{
    
    NSLog(@"[Timer] change contentView");
    [self incrementOffset];
    [self changeContentViewAnimationAction];
}

- (void) incrementOffset{
    self.offset ++;
    if (self.offset >= self.contentViews.count) {
        self.offset = 0;
    }
}

- (void) decrementOffset{
    self.offset --;
    if (self.offset < 0) {
        self.offset = self.contentViews.count - 1;
    }
}
- (void) restartTimerIfNeeded{
    if (self.contentViews.count > 1) {
        [self.timer restart];
    }
}

- (void) changeContentViewWithGestureOffset:(CGFloat)offset velocity:(CGFloat)velocity{
    NSLog(@"[gesture] move velocity:%f",velocity);

    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    _canChangeForPanGesture = ABS(velocity) > 100;
    UIView * otherView;
    CGRect otherViewFrame = CGRectZero;
    CGRect currentViewFrame = self.currentContentView.frame;
    BOOL isMoveNextView = NO;
    
    if (self.direction == XXXNoticeScrollDirectionVertical) {
        currentViewFrame.origin.y += offset;
        ///<正是向下，负是向上
        isMoveNextView = CGRectGetMaxY(currentViewFrame) <= height;
        if (isMoveNextView) {
            otherView = self.nextView;
            otherViewFrame = otherView.frame;
            otherViewFrame.origin.y = CGRectGetMaxY(currentViewFrame);
        } else {
            otherView = self.preView;
            otherViewFrame = otherView.frame;
            otherViewFrame.origin.y = CGRectGetMinY(currentViewFrame) - height;
        }
        _canChangeForPanGesture |= (ABS(height - CGRectGetMaxY(currentViewFrame)) >= height * 0.3);
    } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
        currentViewFrame.origin.x += offset;
        ///<正是向右，负是向左
        isMoveNextView = CGRectGetMaxX(currentViewFrame) <= width;
        if (isMoveNextView) {
            otherView = self.nextView;
            otherViewFrame = otherView.frame;
            otherViewFrame.origin.x = CGRectGetMaxX(currentViewFrame);
        } else {
            otherView = self.preView;
            otherViewFrame = otherView.frame;
            otherViewFrame.origin.x = CGRectGetMinX(currentViewFrame) - width;
        }
        _canChangeForPanGesture |= (ABS(width - CGRectGetMaxX(currentViewFrame)) >= width * 0.3);
    }

    _isChangeToNextView = isMoveNextView;
    NSLog(@"[gesture] otherView:%@ canChange:%d",otherView.restorationIdentifier,_canChangeForPanGesture);
    
    self.currentContentView.frame = currentViewFrame;
    otherView.frame = otherViewFrame;
}

- (void) endChangeContentViewWithGesture{
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);

    UIView * otherView;
    CGRect currentViewFrame = self.currentContentView.frame;
    CGRect otherViewFrame = CGRectZero;
    
    if (_canChangeForPanGesture) {
        ///<切换动画
        if (self.direction == XXXNoticeScrollDirectionVertical) {
            if (_isChangeToNextView) {
                otherView = self.nextView;
                otherViewFrame = otherView.frame;
                
                currentViewFrame.origin.y = -height;
                otherViewFrame.origin.y = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentContentView.frame = currentViewFrame;
                    otherView.frame = otherViewFrame;
                } completion:^(BOOL finished) {
                    [self resetCurrentViewFrame:currentViewFrame];
                    self.currentContentView = otherView;
                    [self incrementOffset];
                    [self restartTimerIfNeeded];
                }];
            } else {
                otherView = self.preView;
                otherViewFrame = otherView.frame;
                
                currentViewFrame.origin.y = height;
                otherViewFrame.origin.y = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentContentView.frame = currentViewFrame;
                    otherView.frame = otherViewFrame;
                } completion:^(BOOL finished) {
                    [self resetCurrentViewFrame:currentViewFrame];
                    self.currentContentView = otherView;
                    [self decrementOffset];
                    [self restartTimerIfNeeded];
                }];
            }
        } else {
            if (_isChangeToNextView) {
                otherView = self.nextView;
                otherViewFrame = otherView.frame;
                
                currentViewFrame.origin.x = -width;
                otherViewFrame.origin.x = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentContentView.frame = currentViewFrame;
                    otherView.frame = otherViewFrame;
                } completion:^(BOOL finished) {
                    [self resetCurrentViewFrame:currentViewFrame];
                    self.currentContentView = otherView;
                    [self incrementOffset];
                    [self restartTimerIfNeeded];
                }];
            } else {
                otherView = self.preView;
                otherViewFrame = otherView.frame;
                
                currentViewFrame.origin.x = width;
                otherViewFrame.origin.x = 0;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentContentView.frame = currentViewFrame;
                    otherView.frame = otherViewFrame;
                } completion:^(BOOL finished) {
                    [self resetCurrentViewFrame:currentViewFrame];
                    self.currentContentView = otherView;
                    [self decrementOffset];
                    [self restartTimerIfNeeded];
                }];
            }
        }
    } else {
        ///<回归动画
        
        if (_isChangeToNextView) {
            otherView = self.nextView;
            otherViewFrame = otherView.frame;
        } else {
            otherView = self.preView;
            otherViewFrame = otherView.frame;
        }
        
        if (self.direction == XXXNoticeScrollDirectionVertical) {
            currentViewFrame.origin.y = 0;
            if (_isChangeToNextView) {
                otherViewFrame.origin.y = height;

            } else {
                otherViewFrame.origin.y = -height;
            }
        } else {
            currentViewFrame.origin.x = 0;
            if (_isChangeToNextView) {
                otherViewFrame.origin.x = width;
            } else {
                otherViewFrame.origin.x = -width;
            }
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.currentContentView.frame = currentViewFrame;
            otherView.frame = otherViewFrame;
        } completion:^(BOOL finished) {
            [self resetOtherView:otherView frame:otherViewFrame];
            [self restartTimerIfNeeded];
        }];
    }
}
- (void) resetOtherView:(UIView *)otherView frame:(CGRect)otherViewFrame{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);

    if (self.direction == XXXNoticeScrollDirectionVertical) {
        otherViewFrame.origin.y = height;
    } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
        otherViewFrame.origin.x = width;
    }
    otherView.frame = otherViewFrame;
}

- (void)resetCurrentViewFrame:(CGRect)currentViewFrame{
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);

    if (self.direction == XXXNoticeScrollDirectionVertical) {
        currentViewFrame.origin.y = height;
    } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
        currentViewFrame.origin.x = width;
    }
    self.currentContentView.frame = currentViewFrame;
}

- (void) changeContentViewAnimationAction{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    NSAssert(self.offset < self.contentViews.count, @"offset计算出错");
    
    UIView * nextView = self.contentViews[self.offset];
    
    __block CGRect currentViewFrame = self.currentContentView.frame;
    CGRect nextViewFrame = nextView.frame;
    
    if (self.direction == XXXNoticeScrollDirectionVertical) {
        currentViewFrame.origin.y = -height;
        nextViewFrame.origin.y = 0;
    } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
        currentViewFrame.origin.x = -width;
        nextViewFrame.origin.x = 0;
    }

    ///<为定时器添加暂停功能，可以避免动画时间大于切换视图间隔的时间
    [_timer pause];
    
    [UIView animateKeyframesWithDuration:self.duration delay:0 options:(UIViewKeyframeAnimationOptionLayoutSubviews|UIViewKeyframeAnimationOptionAllowUserInteraction) animations:^{

        self.currentContentView.frame = currentViewFrame;
        nextView.frame = nextViewFrame;
    } completion:^(BOOL finished) {

        [self resetCurrentViewFrame:currentViewFrame];
        [_timer restart];
        
        self.currentContentView = nextView;
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return self.canGestureScroll && self.contentViews.count > 1;
    }
    return YES;
}

- (UIView *) preView{
    if (self.contentViews.count == 1) {
        return nil;
    }
    if (self.offset == 0) {
        return self.contentViews.lastObject;
    }
    return self.contentViews[self.offset - 1];
}

- (UIView *) nextView{
    if (self.contentViews.count == 1) {
        return nil;
    }
    if (self.offset + 1 == self.contentViews.count) {
        return self.contentViews.firstObject;
    }
    return self.contentViews[self.offset + 1];
}

@end
