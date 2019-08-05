//
//  UIView+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "UIView+MHCommon.h"

@implementation UIView (MHCommon)

#define XXXCgpointGetter(__name__,__result__)\
- (CGPoint)__name__ {\
    return __result__;\
}\


XXXCgpointGetter(viewOrigin, self.frame.origin);

#define XXXCGPointSetter(__name__,__block__)\
- (void)set##__name__:(CGPoint)__name__ {\
    __block__();\
}

XXXCGPointSetter(ViewOrigin, (^(void){
    CGRect newFrame = self.frame;
    newFrame.origin = ViewOrigin;
    self.frame      = newFrame;
}));


- (CGSize)viewSize {
    
    return self.frame.size;
}

- (void)setViewSize:(CGSize)cccc {
    
    CGRect newFrame = self.frame;
    newFrame.size   = cccc;
    self.frame      = newFrame;
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = x;
    self.frame        = newFrame;
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = y;
    self.frame        = newFrame;
}

- (CGFloat)width {
    
    return CGRectGetWidth(self.bounds);
}

- (void)setWidth:(CGFloat)width {
    
    CGRect newFrame     = self.frame;
    newFrame.size.width = width;
    self.frame          = newFrame;
}

- (CGFloat)height {
    
    return CGRectGetHeight(self.bounds);
}

- (void)setHeight:(CGFloat)height {
    
    CGRect newFrame      = self.frame;
    newFrame.size.height = height;
    self.frame           = newFrame;
}

- (CGFloat)top {
    
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = top;
    self.frame        = newFrame;
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)left {
    
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = left;
    self.frame        = newFrame;
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    
    CGRect newFrame   = self.frame;
    newFrame.origin.x = right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint newCenter = self.center;
    newCenter.x       = centerX;
    self.center       = newCenter;
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint newCenter = self.center;
    newCenter.y       = centerY;
    self.center       = newCenter;
}

- (CGFloat)middleX {
    
    return CGRectGetWidth(self.bounds) / 2.f;
}

- (CGFloat)middleY {
    
    return CGRectGetHeight(self.bounds) / 2.f;
}

- (CGPoint)middlePoint {
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
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
