//
//  UIView+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIView+MHCommon.h"

@implementation UIView (MHCommon)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.centerY);
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.centerX, centerY);
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (void)addSubviewOrBringToFront:(UIView *)subview
{
    BOOL found = NO;
    
    for (UIView *v in self.subviews) {
        if (v == subview) {
            found = YES;
            
            break;
        }
    }
    
    if (found) {
        [self bringSubviewToFront:subview];
        
    } else {
        [self addSubview:subview];
    }
}

- (void)frameSet:(NSString *)key value:(CGFloat)value
{
    CGRect rect = self.frame;
    
    if ([@"x" isEqualToString:key]) {
        rect.origin.x = value;
        
    } else if ([@"y" isEqualToString:key]) {
        rect.origin.y = value;
        
    } else if ([@"w" isEqualToString:key]) {
        rect.size.width = value;
        
    } else if ([@"h" isEqualToString:key]) {
        rect.size.height = value;
    }
    
    self.frame = rect;
}

- (void)frameSet:(NSString *)key1 value1:(CGFloat)value1 key2:(NSString *)key2 value2:(CGFloat)value2
{
    [self frameSet:key1 value:value1];
    [self frameSet:key2 value:value2];
}

- (void)addLine:(CGRect)rect
{
    [self addLine:[UIColor lightGrayColor] inRect:rect];
}

- (void)addLine:(UIColor *)color inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
   	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end
@implementation UIView (Line)

+ (instancetype) lineView{
    
    UIView * view = [[self alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
@end

@implementation CALayer (HSFrame)

- (void)setHs_x:(CGFloat)hs_x{
    CGRect frame = self.frame;
    frame.origin.x = hs_x;
    self.frame = frame;
}
-(CGFloat)hs_x{
    return self.frame.origin.x;
}

- (void)setHs_y:(CGFloat)hs_y{
    CGRect frame = self.frame;
    frame.origin.y = hs_y;
    self.frame = frame;
}
-(CGFloat)hs_y{
    return self.frame.origin.y;
}

- (void)setHs_height:(CGFloat)hs_height{
    CGRect frame = self.frame;
    frame.size.height = hs_height;
    self.frame = frame;
}
-(CGFloat)hs_height{
    return self.frame.size.height;
}

- (void)setHs_width:(CGFloat)hs_width{
    CGRect frame = self.frame;
    frame.size.width = hs_width;
    self.frame = frame;
}
-(CGFloat)hs_width{
    return self.frame.size.width;
}

- (void)setHs_size:(CGSize)hs_size{
    CGRect frame = self.frame;
    frame.size = hs_size;
    self.frame = frame;
}
-(CGSize)hs_size{
    return self.frame.size;
}
@end
