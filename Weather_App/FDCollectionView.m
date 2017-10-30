//
//  FDCollectionView.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDCollectionView.h"
#import <objc/runtime.h>
#import "Masonry.h"

@interface FDCollectionView (FDSwizzing)

@end

@implementation FDCollectionView(FDSwizzing)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = NSSelectorFromString(@"handlePan:");
        SEL swizzledSelector = NSSelectorFromString(@"fd_handlePan:");
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
@end

@interface FDCollectionView()

@end

@implementation FDCollectionView{
    
    CGPoint _gestureHandlePanBeginPoint;
    CGPoint _gestureHandlePanChangePoint;
    FDCollectionViewMoveDirection _moveDirection;
}

// UIScrollViewPanGestureRecognizer
- (void) fd_handlePan:(UIPanGestureRecognizer *)gesture{
    
    CGPoint gestureMoveContentOffset = [gesture translationInView:self];
    
    // 在向右/左滑动的时候 gestureMoveContentOffset 的 y 在前几个数据是不变的，只有 x>0 来表示向右 ，x<0来表示向左
    // 上/下滑动的时候， 同理，x 在前几个数据中不变，y>0来表示向上 ，y<0来表示向下
    BOOL continueMothod = YES;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStatePossible:
            
            self.alwaysBounceHorizontal = YES;
            _gestureHandlePanBeginPoint = gestureMoveContentOffset;
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            
            if (self.fd_delegate && [self.fd_delegate respondsToSelector:@selector(collectionViewDidEndMove:)]) {
                [self.fd_delegate collectionViewDidEndMove:self];
            }
            break;
        case UIGestureRecognizerStateChanged:
            
            _gestureHandlePanChangePoint = gestureMoveContentOffset;
            /// 上下移动
            if (_gestureHandlePanChangePoint.x == _gestureHandlePanBeginPoint.x || _gestureHandlePanBeginPoint.x == 0) {// 上下移动
                
                if (_gestureHandlePanChangePoint.y > 0 || _gestureHandlePanBeginPoint.y > 0) {//向上
                    
                    _moveDirection = FDCollectionViewMoveUp;
                    if (self.fd_delegate && [self.fd_delegate respondsToSelector:@selector(collectionView:didMoveToDownContentOffset:)]) {
                        [self.fd_delegate collectionView:self didMoveToDownContentOffset:_gestureHandlePanChangePoint.y];
                        continueMothod = NO;
                    }
                }else if (_gestureHandlePanChangePoint.y < 0 || _gestureHandlePanBeginPoint.y < 0){// 向下
                    
                    _moveDirection = FDCollectionViewMoveDown;
                    if (self.fd_delegate && [self.fd_delegate respondsToSelector:@selector(collectionView:didMoveToUpContentOffset:)]) {
                        [self.fd_delegate collectionView:self didMoveToUpContentOffset:_gestureHandlePanChangePoint.y];
                        continueMothod = NO;
                    }
                }else{
                    _moveDirection = FDCollectionViewMoveNone;
                }
            }else if (_gestureHandlePanChangePoint.y == _gestureHandlePanBeginPoint.y || _gestureHandlePanBeginPoint.y == 0){// 左右移动
                
                if (_gestureHandlePanChangePoint.x > 0 || _gestureHandlePanBeginPoint.x > 0) {// 向右移动
                    
                    _moveDirection = FDCollectionViewMoveRight;
                    if (self.fd_delegate && [self.fd_delegate respondsToSelector:@selector(collectionView:didMoveToLeftContentOffset:)]) {
                        [self.fd_delegate collectionView:self didMoveToLeftContentOffset:-_gestureHandlePanChangePoint.x];
                    }
                }else if (_gestureHandlePanChangePoint.x < 0 || _gestureHandlePanBeginPoint.x < 0){// 向左
                    
                    _moveDirection = FDCollectionViewMoveLeft;
                    if (self.fd_delegate && [self.fd_delegate respondsToSelector:@selector(collectionView:didMoveToRightContentOffset:)]) {
                        [self.fd_delegate collectionView:self didMoveToRightContentOffset:-_gestureHandlePanChangePoint.x];
                    }
                }else{
                    _moveDirection = FDCollectionViewMoveNone;
                }
            }else{
                _moveDirection = FDCollectionViewMoveNone;
            }
            break;
        default:
            break;
    }
    [self fd_handlePan:gesture];
}

@end
