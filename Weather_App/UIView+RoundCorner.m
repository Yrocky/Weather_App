//
//  UIView+RoundCorner.m
//  Weather_App
//
//  Created by user1 on 2018/8/9.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "UIView+RoundCorner.h"
#import <objc/runtime.h>

static void *const __mm_cornerRadiusImageSize = "__mm_cornerRadiusImageSize";
static void *const __mm_cornerRadiusImageOuterColor = "__mm_cornerRadiusImageOuterColor";
static void *const __mm_cornerRadiusImageInnerColor = "__mm_cornerRadiusImageInnerColor";
static void *const __mm_cornerRadiusImageRadius = "__mm_cornerRadiusImageRadius";
static void *const __mm_cornerRadiusImageCorners = "__mm_cornerRadiusImageCorners";
static void *const __mm_cornerRadiusImageBorderWidth = "__mm_cornerRadiusImageBorderWidth";
static void *const __mm_cornerRadiusImageBorderColor = "__mm_cornerRadiusImageBorderColor";
static void *const __mm_cornerRadiusImageShadowColor = "__mm_cornerRadiusImageShadowColor";
static void *const __mm_cornerRadiusImageShadowOffset = "__mm_cornerRadiusImageShadowOffset";
static void *const __mm_cornerRadiusImageShadowBlur = "__mm_cornerRadiusImageShadowBlur";

static void *const _XWMaskCornerRadiusLayerKey = "_XWMaskCornerRadiusLayerKey";
static NSMutableSet<UIImage *> *maskCornerRaidusImageSet;

@interface MM_RoundCorner()

@property (nonatomic ,strong) UIColor * mm_outerColor;
@property (nonatomic ,strong) UIColor * mm_innerColor;
@property (nonatomic ,assign) CGSize mm_radius;
@property (nonatomic ,assign) UIRectCorner mm_corners;
@property (nonatomic ,assign) CGFloat mm_borderWidth;
@property (nonatomic ,strong) UIColor * mm_borderColor;
@property (nonatomic ,strong) UIColor * mm_shadowColor;
@property (nonatomic ,assign) CGSize mm_shadowOffset;
@property (nonatomic ,assign) CGFloat mm_shadowBlur;
@end

@implementation NSObject (_XWAdd)

+ (void)xw_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)xw_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)xw_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)xw_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}
@end

@implementation UIImage (RoundCorner)

+ (void)xw_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock resultImage:(void(^)(UIImage *))cb{
    if (!drawBlock) return;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (image && cb) {
        cb(image);
    };
}

+ (void)xw_maskRoundCornerRadiusImageWithOuterColor:(UIColor *)outerColor innerColor:(UIColor *)innerColor cornerRadii:(CGSize)cornerRadii size:(CGSize)size corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth shadowOffset:(CGSize)shadowOffset shadowColor:(UIColor *)shadowColor shadowBlur:(CGFloat)shadowBlur drawImage:(void(^)(UIImage *))cb{
    
    dispatch_queue_t queue = dispatch_queue_create([@"com.2339.asyncImage" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        [self xw_imageWithSize:size drawBlock:^(CGContextRef context) {
            
            CGRect rect = CGRectMake(0, 0, size.width, size.height);
            CGRect roundRect = (CGRect){
                shadowOffset.width < 0 ? ABS(shadowOffset.width) : 0,
                shadowOffset.height < 0 ? ABS(shadowOffset.height) : 0,
                CGRectGetWidth(rect) - ABS(shadowOffset.width),
                CGRectGetHeight(rect) - ABS(shadowOffset.height)
            };
            CGRect boardOuterRect = roundRect;
            CGRect boardInnerRect = (CGRect){
                CGRectGetMinX(roundRect) + borderWidth,
                CGRectGetMinY(roundRect) + borderWidth,
                CGRectGetWidth(rect) - ABS(shadowOffset.width) - borderWidth * 2,
                CGRectGetHeight(rect) - ABS(shadowOffset.height) - borderWidth * 2
            };
            
            UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:rect];
            UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:roundRect
                                                            byRoundingCorners:corners
                                                                  cornerRadii:cornerRadii];
            [rectPath appendPath:roundPath];
            
            UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:boardOuterRect
                                                                   byRoundingCorners:corners
                                                                         cornerRadii:cornerRadii];
            UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:boardInnerRect
                                                                  byRoundingCorners:corners
                                                                        cornerRadii:cornerRadii];
            [borderOutterPath appendPath:borderInnerPath];
            
            CGContextSaveGState(context);
//            [roundPath addClip];//
//            CGContextEOClip(context);
            [innerColor set];
            [rectPath fill];
            CGContextAddPath(context, rectPath.CGPath);
            CGContextEOFillPath(context);
            CGContextRestoreGState(context);
            
            if (!CGColorEqualToColor(shadowColor.CGColor,[UIColor clearColor].CGColor)){
                CGContextSaveGState(context);
                if (!CGColorEqualToColor(innerColor.CGColor,[UIColor clearColor].CGColor)) {
                    [innerColor set];
                }
                [roundPath fill];
                CGContextAddPath(context, roundPath.CGPath);
                CGContextSetShadowWithColor(context,shadowOffset,shadowBlur,shadowColor.CGColor);
                CGContextEOFillPath(context);
                CGContextRestoreGState(context);
            }
            
            CGContextSaveGState(context);
            [borderColor set];
            CGContextAddPath(context, borderOutterPath.CGPath);
            CGContextEOFillPath(context);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
            if (!CGColorEqualToColor(innerColor.CGColor,[UIColor clearColor].CGColor)){
                
                [innerColor setFill];
                CGContextAddPath(context, borderInnerPath.CGPath);
                CGContextEOFillPath(context);
            }else{
//                [[UIColor redColor] set];
//                [rectPath appendPath:borderInnerPath];
//                [borderInnerPath addClip];
//                CGContextAddPath(context, rectPath.CGPath);
//                CGContextFillPath(context);
            }
            CGContextRestoreGState(context);
            
        } resultImage:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cb) {
                    cb(image);
                }
            });
        }];
    });
}
@end

@implementation CALayer (XWAddForRoundedCorner)

+ (void)load{
    [CALayer xw_swizzleInstanceMethod:@selector(layoutSublayers)
                                 with:@selector(_xw_layoutSublayers)];
}

- (UIImage *)mm_contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setMm_contentImage:(UIImage *)contentImage{
    self.contents = (__bridge id)contentImage.CGImage;
}

- (void) mm_makeRoundCorner:(void(^)(MM_RoundCorner *make))block{
    
    MM_RoundCorner * make = [MM_RoundCorner new];
    if (block){
        block(make);
        [self _mm_configRoundCornerWith:make];
    };
}

- (void) _mm_configRoundCornerWith:(MM_RoundCorner *)make{
    
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self xw_setAssociateValue:cornerRadiusLayer withKey:_XWMaskCornerRadiusLayerKey];
    }
    if (make.mm_outerColor) {
        [cornerRadiusLayer xw_setAssociateValue:make.mm_outerColor withKey:__mm_cornerRadiusImageOuterColor];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:__mm_cornerRadiusImageOuterColor];
    }
    if (make.mm_innerColor) {
        [cornerRadiusLayer xw_setAssociateValue:make.mm_innerColor withKey:__mm_cornerRadiusImageInnerColor];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:__mm_cornerRadiusImageInnerColor];
    }
    [cornerRadiusLayer xw_setAssociateValue:[NSValue valueWithCGSize:make.mm_radius] withKey:__mm_cornerRadiusImageRadius];
    [cornerRadiusLayer xw_setAssociateValue:@(make.mm_corners) withKey:__mm_cornerRadiusImageCorners];
    if (make.mm_borderColor) {
        [cornerRadiusLayer xw_setAssociateValue:make.mm_borderColor withKey:__mm_cornerRadiusImageBorderColor];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:__mm_cornerRadiusImageBorderColor];
    }
    [cornerRadiusLayer xw_setAssociateValue:@(make.mm_borderWidth) withKey:__mm_cornerRadiusImageBorderWidth];
    if (make.mm_shadowColor) {
        [cornerRadiusLayer xw_setAssociateValue:make.mm_shadowColor withKey:__mm_cornerRadiusImageShadowColor];
    }else{
        [cornerRadiusLayer xw_removeAssociateWithKey:__mm_cornerRadiusImageShadowColor];
    }
    [cornerRadiusLayer xw_setAssociateValue:@(make.mm_shadowOffset) withKey:__mm_cornerRadiusImageShadowOffset];
    [cornerRadiusLayer xw_setAssociateValue:@(make.mm_shadowBlur) withKey:__mm_cornerRadiusImageShadowBlur];
    
    [self _xw_getCornerRadiusImageFromSet:^(UIImage *image) {
        if (image) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            cornerRadiusLayer.mm_contentImage = image;
            [CATransaction commit];
        }
    }];
}

- (void)_xw_getCornerRadiusImageFromSet:(void(^)(UIImage *image))cb{
    
    if (!self.bounds.size.width || !self.bounds.size.height) return;
    
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    UIColor *outerColor = [cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageOuterColor];
    UIColor *innerColor = [cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageInnerColor];
    CGSize radius = [[cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageRadius] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageCorners] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageBorderWidth] floatValue];
    UIColor *borderColor = [cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageBorderColor];
    UIColor *shadowColor = [cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowColor];
    CGSize shadowOffset = [[cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowOffset] CGSizeValue];
    CGFloat shadowBlur = [[cornerRadiusLayer xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowBlur] floatValue];
    
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGSize imageSize = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageSize] CGSizeValue];
        UIColor *imageOuterColor = [obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageOuterColor];
        UIColor *imageInnerColor = [obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageInnerColor];
        CGSize imageRadius = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageRadius] CGSizeValue];
        NSUInteger imageCorners = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageCorners] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageBorderWidth] floatValue];
        UIColor *imageBorderColor = [obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageBorderColor];
        UIColor *imageShadowColor = [obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowColor];
        CGSize imageShadowOffset = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowOffset] CGSizeValue];
        CGFloat imageShadowBlur = [[obj xw_getAssociatedValueForKey:__mm_cornerRadiusImageShadowBlur] floatValue];
        
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) &&
                             borderWidth == imageBorderWidth) ||
        (!borderColor && !imageBorderColor) ||
        (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) &&
        CGColorEqualToColor(imageOuterColor.CGColor, outerColor.CGColor) &&
        CGColorEqualToColor(imageInnerColor.CGColor, innerColor.CGColor) &&
        CGColorEqualToColor(imageShadowColor.CGColor, shadowColor.CGColor) &&
        imageCorners == corners &&
        CGSizeEqualToSize(radius, imageRadius) &&
        CGSizeEqualToSize(imageShadowOffset, shadowOffset) &&
        imageShadowBlur == shadowBlur &&
        isBorderSame;
        
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        [UIImage xw_maskRoundCornerRadiusImageWithOuterColor:outerColor
                                                  innerColor:innerColor
                                                 cornerRadii:radius
                                                        size:self.bounds.size
                                                     corners:corners
                                                 borderColor:borderColor
                                                 borderWidth:borderWidth
                                                shadowOffset:shadowOffset
                                                 shadowColor:shadowColor
                                                  shadowBlur:shadowBlur
                                                   drawImage:^(UIImage *img) {
                                                       
                                                       [img xw_setAssociateValue:[NSValue valueWithCGSize:self.bounds.size] withKey:__mm_cornerRadiusImageSize];
                                                       [img xw_setAssociateValue:outerColor withKey:__mm_cornerRadiusImageOuterColor];
                                                       [img xw_setAssociateValue:innerColor withKey:__mm_cornerRadiusImageInnerColor];
                                                       [img xw_setAssociateValue:[NSValue valueWithCGSize:radius] withKey:__mm_cornerRadiusImageRadius];
                                                       [img xw_setAssociateValue:@(corners) withKey:__mm_cornerRadiusImageCorners];
                                                       if (borderColor) {
                                                           [img xw_setAssociateValue:borderColor withKey:__mm_cornerRadiusImageBorderColor];
                                                       }
                                                       [img xw_setAssociateValue:@(borderWidth) withKey:__mm_cornerRadiusImageBorderWidth];
                                                       if (shadowColor) {
                                                           [img xw_setAssociateValue:shadowColor withKey:__mm_cornerRadiusImageShadowColor];
                                                       }
                                                       [img xw_setAssociateValue:@(shadowOffset) withKey:__mm_cornerRadiusImageShadowOffset];
                                                       [img xw_setAssociateValue:@(shadowBlur) withKey:__mm_cornerRadiusImageShadowBlur];
                                                       
                                                       [maskCornerRaidusImageSet addObject:img];
                                                       if (cb){
                                                           cb(img);
                                                       }
                                                   }];
    }
}

#pragma mark - exchage Methods

- (void)_xw_layoutSublayers{
    [self _xw_layoutSublayers];
    CALayer *cornerRadiusLayer = [self xw_getAssociatedValueForKey:_XWMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        [self _xw_getCornerRadiusImageFromSet:^(UIImage *image) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            cornerRadiusLayer.mm_contentImage = image;
            cornerRadiusLayer.frame = self.bounds;
            [CATransaction commit];
        }];
//        [self addSublayer:cornerRadiusLayer];
        [self insertSublayer:cornerRadiusLayer atIndex:0];
    }
}

@end

@implementation UIView (XWAddForRoundedCorner)

- (void) mm_makeRoundCorner:(void(^)(MM_RoundCorner *make))block{
    [self.layer mm_makeRoundCorner:block];
}
@end

@implementation MM_RoundCorner

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mm_outerColor = [UIColor clearColor];
        self.mm_innerColor = [UIColor clearColor];
        self.mm_corners = UIRectCornerAllCorners;
        self.mm_radius = CGSizeZero;
        self.mm_borderWidth = 0.0f;
        self.mm_borderColor = [UIColor clearColor];
        self.mm_shadowColor = [UIColor clearColor];
        self.mm_shadowOffset = CGSizeZero;
        self.mm_shadowBlur = 0.0f;
    }
    return self;
}
- (MM_RoundCorner * (^)(UIColor * outerColor)) outerColor{
    return ^id(UIColor * outerColor){
        self.mm_outerColor = outerColor;
        return self;
    };
}
- (MM_RoundCorner * (^)(UIColor * innerColor)) innerColor{
    return ^id(UIColor * innerColor){
        self.mm_innerColor = innerColor;
        return self;
    };
}
- (MM_RoundCorner * (^)(CGSize radius)) radius{
    return ^id(CGSize radius){
        self.mm_radius = radius;
        return self;
    };
}
- (MM_RoundCorner * (^)(UIRectCorner corners)) corners{
    return ^id(UIRectCorner corners){
        self.mm_corners = corners;
        return self;
    };
}
- (MM_RoundCorner * (^)(UIColor * borderColor)) borderColor{
    return ^id(UIColor * borderColor){
        self.mm_borderColor = borderColor;
        return self;
    };
}
- (MM_RoundCorner * (^)(CGFloat borderWidth)) borderWidth{
    return ^id(CGFloat borderWidth){
        self.mm_borderWidth = borderWidth;
        return self;
    };
}
- (MM_RoundCorner * (^)(UIColor * shadowColor)) shadowColor{
    return ^id(UIColor * shadowColor){
        self.mm_shadowColor = shadowColor;
        return self;
    };
}
- (MM_RoundCorner * (^)(CGSize shadowOffset)) shadowOffset{
    return ^id(CGSize shadowOffset){
        self.mm_shadowOffset = shadowOffset;
        return self;
    };
}
- (MM_RoundCorner * (^)(CGFloat shadowBlur)) shadowBlur{
    return ^id(CGFloat shadowBlur){
        self.mm_shadowBlur = shadowBlur;
        return self;
    };
}
@end

