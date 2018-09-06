//
//  MMSwipeCell.m
//  Weather_App
//
//  Created by Rocky Young on 2018/8/28.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMSwipeCell.h"

@interface MMSwipeCell ()<UIGestureRecognizerDelegate>

@end

@implementation MMSwipeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor orangeColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _customContentView = [UIView new];
        _customContentView.restorationIdentifier = @"custom content view";
        _customContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_customContentView];
        
        _swipeContentView = [UIView new];
        self.swipeContentView.restorationIdentifier = @"display content view";
        self.swipeContentView.backgroundColor = [UIColor greenColor];
        [_customContentView addSubview:self.swipeContentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _customContentView.frame = (CGRect){
        self.swipeContentViewEdgeInsets.left,
        self.swipeContentViewEdgeInsets.top,
        self.contentView.frame.size.width - self.swipeContentViewEdgeInsets.left - self.swipeContentViewEdgeInsets.right,
        self.contentView.frame.size.height - self.swipeContentViewEdgeInsets.top - self.swipeContentViewEdgeInsets.bottom
    };
    
    self.swipeContentView.frame = _customContentView.bounds;
    
    _leftHandleButton.frame = (CGRect){
        CGPointZero,
        self.handleButtonWidth,
        _customContentView.frame.size.height
    };
    
    _rightHandleButton.frame = (CGRect){
        _customContentView.frame.size.width - self.handleButtonWidth,
        0,
        self.handleButtonWidth,
        _customContentView.frame.size.height
    };
}

- (void)resetSwipeStatusIfNeeded{
    if (_leftOnDragRelease || _rightOnDragRelease) {
        [UIView animateWithDuration:0.2 animations:^{
            self.swipeContentView.frame = _customContentView.bounds;
        }];
    }
}

+ (NSString *)cellIdentifier{
    return @"swipe-cell-identifier";
}

- (UIButton *) addLeftHandleButton:(NSString *)text{
    
    if (_leftHandleButton) {
        [_leftHandleButton removeFromSuperview];
        _leftHandleButton = nil;
    }
    _canLeftSwipeHandle = YES;
    
    UIButton * leftHandleButton = [self _createButton:text
                                               action:@selector(onLeftButtonAction:)];
    leftHandleButton.backgroundColor = [UIColor blackColor];
    _leftHandleButton = leftHandleButton;
    
    [_customContentView addSubview:_leftHandleButton];
    [_customContentView sendSubviewToBack:_leftHandleButton];
    
    [self layoutIfNeeded];
    [self _addGestureIfNeeded];
    return leftHandleButton;
}

- (UIButton *) addRightHandleButton:(NSString *)text{
    
    if (_rightHandleButton) {
        [_rightHandleButton removeFromSuperview];
        _rightHandleButton = nil;
    }
    _canRightSwipeHandle = YES;
    
    UIButton * rightHandleButton = [self _createButton:text
                                                action:@selector(onRightButtonAction:)];
    rightHandleButton.backgroundColor = [UIColor blueColor];
    _rightHandleButton = rightHandleButton;
    
    [_customContentView addSubview:_rightHandleButton];
    [_customContentView sendSubviewToBack:_rightHandleButton];
    
    [self layoutIfNeeded];
    [self _addGestureIfNeeded];
    return rightHandleButton;
}

- (UIButton *) _createButton:(NSString *)text action:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) _addGestureIfNeeded{
    if (nil == _panGesture) {
        _panGesture= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
        _panGesture.delegate = self;
        [self.swipeContentView addGestureRecognizer:_panGesture];
    }
}

#pragma mark - Action

- (void) onLeftButtonAction:(UIButton *)button{
    [self resetSwipeStatusIfNeeded];
    if (self.swipeDelegate &&
        [self.swipeDelegate respondsToSelector:@selector(swipeCellDidTapLeftHandleButton:)]) {
        [self.swipeDelegate swipeCellDidTapLeftHandleButton:self];
    }
}
- (void) onRightButtonAction:(UIButton *)button{
    [self resetSwipeStatusIfNeeded];
    if (self.swipeDelegate &&
        [self.swipeDelegate respondsToSelector:@selector(swipeCellDidTapRightHandleButton:)]) {
        [self.swipeDelegate swipeCellDidTapRightHandleButton:self];
    }
}

- (IBAction)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.swipeContentView.center;
        _swipeStatus = YES;
        if (self.swipeDelegate &&
            [self.swipeDelegate respondsToSelector:@selector(swipeCellWillStartSwipe:)]) {
            [self.swipeDelegate swipeCellWillStartSwipe:self];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        // 得到滑动中的点，在触摸点左边是负，右边是正
        CGPoint transtion = [gesture translationInView:self.swipeContentView];
        
        self.swipeContentView.center = CGPointMake(_originalCenter.x + transtion.x, _originalCenter.y);
        
        _rightOnDragRelease = (self.swipeContentView.frame.origin.x < -self.handleButtonWidth) &&
        _canRightSwipeHandle;
        _leftOnDragRelease = (self.swipeContentView.frame.origin.x > self.handleButtonWidth) &&
        _canLeftSwipeHandle;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        
        _swipeStatus = NO;
        
        CGFloat orignialX = 0.0f;
        if (_rightOnDragRelease) {
            orignialX = -self.handleButtonWidth;
        } else if (_leftOnDragRelease) {
            orignialX = self.handleButtonWidth;
        }
        CGRect originalFrame = (CGRect){
            orignialX,0,
            self.swipeContentView.frame.size
        };
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:15 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.swipeContentView.frame = originalFrame;
            self.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
        
        if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeCellDidEndSwipe:)]) {
            [self.swipeDelegate swipeCellDidEndSwipe:self];
        }
    }
}

#pragma mark - FDSwipeCellInterfaceProtocol

- (CGFloat) handleButtonWidth{
    return 80.0f;
}

- (UIEdgeInsets) swipeContentViewEdgeInsets{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIPanGestureRecognizer * panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint translation = [panGestureRecognizer translationInView:self.swipeContentView];
        
        if (fabs(translation.x) > fabs(translation.y)) {
            if (_leftOnDragRelease || _rightOnDragRelease) {// 处于打开按钮的状态
                return YES;
            }
            BOOL currentDirectionIsCanSwipe = (translation.x > 0 && _canLeftSwipeHandle) ||
            (translation.x < 0 && _canRightSwipeHandle);// 滑动方向（左/右）上有添加对应的按钮
            return currentDirectionIsCanSwipe;
        }
        return NO;
    }
    return NO;
}

@end
