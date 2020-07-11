//
//  MMDirectionGestureRecognizer.m
//  Weather_App
//
//  Created by Rocky Young on 2018/10/29.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMDirectionGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MMDirectionGestureRecognizer ()

@property (nonatomic ,assign) CGPoint startPoint;
@end

@implementation MMDirectionGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        _direction = MMDirectionGestureRecognizerUnknown;
        _hysteresisOffset = 2.0f;
    }
    return self;
}

#pragma mark - private

- (BOOL) locationInHysteresisRange:(CGPoint)location{
    
    CGFloat radius = self.hysteresisOffset;
    double dx = fabs(location.x - self.startPoint.x);
    double dy = fabs(location.y - self.startPoint.y);
    double dis = hypot(dx, dy);
    return dis <= radius;// 到startPoint的距离小于等于半径
}

-(CGFloat) startPointCenterGetDegreeWith:(CGPoint)point
{
    CGPoint center = self.startPoint;
    
    // 取出点击坐标x y
    CGFloat x,y;
    x = point.x;
    y = point.y;
    
    // 圆心坐标
    CGFloat xC = center.x;
    CGFloat yC = center.y;
    
    // 计算控件距离圆心距离
    CGFloat distance = sqrt(pow((x - xC), 2) + pow(y - yC, 2));
    CGFloat xD = (x - xC);
    
    CGFloat mySin = fabs(xD) / distance;
    
    CGFloat degree;
    if (point.x < center.x) {
        if (point.y < center.y) {
            degree = 360 - asin(mySin) / M_PI * 180;
        }
        else
        {
            degree = asin(mySin) / M_PI * 180 + 180;
        }
    }
    else
    {
        if (point.y < center.y) {
            degree = asin(mySin) / M_PI * 180;
        }
        else
        {
            degree = 180 - asin(mySin) / M_PI * 180;
        }
    }
    
    return degree;
}

- (MMDirectionGestureRecognizerDirection) gestureDirection:(CGPoint)location{
    
    CGFloat degree = [self startPointCenterGetDegreeWith:location];
    
    if (degree <= 45.0f || degree > 315.0f) {// up
        return MMDirectionGestureRecognizerUp;
    }else if(degree > 45.0f && degree <= 135.0f){// right
        return MMDirectionGestureRecognizerRight;
    } else if (degree > 135.0f && degree <= 225.0f){// down
        return MMDirectionGestureRecognizerDown;
    } else if (degree > 225.0f && degree<= 315.0f){// left
        return MMDirectionGestureRecognizerLeft;
    }
    return MMDirectionGestureRecognizerUnknown;
}

- (void) resetConfig{
    self.startPoint = CGPointZero;
    _direction = MMDirectionGestureRecognizerUnknown;
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count != 1) {// 仅支持一个手指的手势
        self.state = UIGestureRecognizerStateFailed;
    }
    self.startPoint = [touches.anyObject locationInView:self.view];
    NSLog(@"startPoint:%@",NSStringFromCGPoint(self.startPoint));
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    // 1 failed直接返回
    if (self.state == UIGestureRecognizerStateFailed){
        return;
    }
    
    // 2
    if (touches.count) {
        CGPoint location = [touches.anyObject locationInView:self.view];

        if (![self locationInHysteresisRange:location]) {// 没有在滞后区内部，开始进行方向的判断
            
            if (self.direction == MMDirectionGestureRecognizerUnknown) {// 还没有设置方向
                _direction = [self gestureDirection:location];
                self.state = UIGestureRecognizerStateChanged;
            }
            if (self.direction == MMDirectionGestureRecognizerUp ||// 向上滑动
                self.direction == MMDirectionGestureRecognizerDown) {// 向下滑动
                _offset = location.y - _startPoint.y;
            }
            if (self.direction == MMDirectionGestureRecognizerLeft ||// 向左移动
                self.direction == MMDirectionGestureRecognizerRight) {// 向右移动
                _offset = location.x - _startPoint.x;
            }
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    [self resetConfig];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self resetConfig];
}

- (void)reset{
    [super reset];
    
    self.state = UIGestureRecognizerStatePossible;
    [self resetConfig];
}

@end
