//
//  MMSwipeCell.h
//  Weather_App
//
//  Created by Rocky Young on 2018/8/28.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
// 提供一个有滑动手势的按钮cell
@class MMSwipeCell;

// 供子类重新修改样式
@protocol MMSwipeCellInterfaceProtocol<NSObject>
- (CGFloat) handleButtonWidth;
@optional
- (UIEdgeInsets) swipeContentViewEdgeInsets;
@end

@protocol MMSwipeCellProtocol<NSObject>
@optional
- (void) swipeCellWillStartSwipe:(MMSwipeCell *)cell;
- (void) swipeCellDidEndSwipe:(MMSwipeCell *)cell;
- (void) swipeCellDidTapLeftHandleButton:(MMSwipeCell *)cell;
- (void) swipeCellDidTapRightHandleButton:(MMSwipeCell *)cell;
@end

@interface MMSwipeCell : UITableViewCell<MMSwipeCellInterfaceProtocol>{
    
    UIView * _customContentView;
    
    UIView * _swipeContentView;
    UIPanGestureRecognizer *_panGesture;///<调用添加左右按钮的方法才会初始化
    
    UIButton * _leftHandleButton;///<调用 -addLeftHandleButton:方法才会创建
    UIButton * _rightHandleButton;///<调用 -addRightHandleButton:方法才会创建
    
    BOOL _canLeftSwipeHandle;///<添加了left按钮才会为YES
    BOOL _canRightSwipeHandle;///<添加了right按钮才会为YES
    
    CGPoint _originalCenter;
    BOOL _leftOnDragRelease;
    BOOL _rightOnDragRelease;
    
    BOOL _swipeStatus;
}

///<自定义的控件都添加这上面，作用和cell的contentView类似
@property (nonatomic ,strong ,readonly) UIView * swipeContentView;
@property (nonatomic ,weak) id<MMSwipeCellProtocol>swipeDelegate;

+ (NSString *) cellIdentifier;
///<重置打开的视图为初始状态
- (void) resetSwipeStatusIfNeeded;
- (UIButton *) addLeftHandleButton:(NSString *)text;
- (UIButton *) addRightHandleButton:(NSString *)text;

@end
