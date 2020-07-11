//
//  UIImage+DrawImage.m
//  Weather_App
//
//  Created by Rocky Young on 2018/12/6.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "UIImage+DrawImage.h"
#import "NSArray+Sugar.h"

@implementation UIImage (ImageDrawer)

+ (UIImage *) imageWithSize:(CGSize)size
               contextBlock:(MMDrawImageContextBlock)contextBlock{
    return [self imageWithSize:size opaque:NO scale:0 contextBlock:contextBlock];
}

+ (UIImage *) imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale
               contextBlock:(MMDrawImageContextBlock)contextBlock{
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (contextBlock) {
        contextBlock(context);
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageWithContextBlock:(MMDrawImageContextBlock)contextBlock{
    
    return [UIImage imageWithSize:self.size opaque:NO scale:self.scale contextBlock:^(CGContextRef context) {
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        [self drawInRect:rect];
        if (contextBlock) {
            contextBlock(context);
        }
    }];
}

- (UIImage *) addImage:(UIImage *)otherImage{
    
    return [self imageWithContextBlock:^(CGContextRef context) {
        
        CGRect selfRect = (CGRect){CGPointZero,self.size};
        CGRect otherRect = (CGRect){CGPointZero,otherImage.size};
        
        if (CGRectContainsRect(selfRect, otherRect)) {
            otherRect.origin.x = (selfRect.size.width - otherRect.size.width) / 2.0;
            otherRect.origin.y = (selfRect.size.height - otherRect.size.height) / 2.0;
        }else{
            otherRect.size = selfRect.size;
        }
        [self drawInRect:selfRect];
        [otherImage drawInRect:otherRect];
    }];
}

- (UIImage *) imageWithColor:(UIColor *)color{
    
    return [UIImage imageWithSize:self.size contextBlock:^(CGContextRef context) {
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = (CGRect){CGPointZero,self.size};
        CGContextClipToMask(context, rect, self.CGImage);
        [color setFill];
        CGContextFillRect(context, rect);
    }];
}

+ (MMImageDrawer *) imageDrawerWithFixedSize:(CGSize)fixedSize{
    
    MMImageDrawer * drawer = [MMImageDrawer new];
    drawer.imageType = MMImageDrawerFixed;
    drawer.fixedSize = fixedSize;
    return drawer;
}
+ (MMImageDrawer *) imageDrawerWithResizable{
    
    MMImageDrawer * drawer = [MMImageDrawer new];
    drawer.imageType = MMImageDrawerResizable;
    return drawer;
}
@end

static NSMutableDictionary<NSString* , UIImage*> * cachedImages;

@interface MMImageDrawer ()

@property (nonatomic ,copy) NSArray<UIColor *> * colors;
@property (nonatomic ,copy) NSArray<NSNumber *> * colorLocations;
@property (nonatomic ,assign) CGPoint colorStartPoint;
@property (nonatomic ,assign) CGPoint colorEndPoint;

@property (nonatomic ,copy) NSArray<UIColor *> * borderColors;
@property (nonatomic ,copy) NSArray<NSNumber *> * borderColorLocations;
@property (nonatomic ,assign) CGPoint borderColorStartPoint;
@property (nonatomic ,assign) CGPoint borderColorEndPoint;
@property (nonatomic ,assign) CGFloat borderWidth;
@property (nonatomic ,assign) MMBorderAligment borderAlignment;

@property (nonatomic ,assign) CGFloat cornerRadiusTopLeft;
@property (nonatomic ,assign) CGFloat cornerRadiusTopRight;
@property (nonatomic ,assign) CGFloat cornerRadiusBottomLeft;
@property (nonatomic ,assign) CGFloat cornerRadiusBottomRight;

@property (nonatomic ,copy) NSString * cacheKey;

@end

@implementation MMImageDrawer

+ (void)initialize{
    cachedImages = [NSMutableDictionary dictionary];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colors = [NSArray arrayWithObject:[UIColor clearColor]];
        self.colorLocations = [NSArray arrayWithObjects:@(0),@(1), nil];
        self.colorStartPoint = CGPointZero;
        self.colorEndPoint = CGPointMake(0, 1);
        
        self.borderColors = [NSArray arrayWithObject:[UIColor blackColor]];
        self.borderColorLocations = [NSArray arrayWithObjects:@(0),@(1), nil];
        self.borderColorStartPoint = CGPointZero;
        self.borderColorEndPoint = CGPointMake(0, 1);
        self.borderAlignment = MMBorderAligmentInside;
        
        self.imageType = MMImageDrawerResizable;
    }
    return self;
}

- (NSString *) cacheKey{

    NSMutableDictionary<NSString* ,NSString*> * attributes = [NSMutableDictionary dictionary];
    attributes[@"colors"] = [self _hash:self.colors.description.hash];
    attributes[@"colorLocations"] = [self _hash:self.colorLocations.description.hash];
    attributes[@"colorStartPoint"] = [self _hashPoint:self.colorStartPoint];
    attributes[@"colorEndPoint"] = [self _hashPoint:self.colorEndPoint];
    
    attributes[@"borderColors"] = [self _hash:self.borderColors.description.hash];
    attributes[@"borderColorLocations"] = [self _hash:self.borderColorLocations.description.hash];;
    attributes[@"borderColorStartPoint"] = [self _hashPoint:self.borderColorStartPoint];
    attributes[@"borderColorEndPoint"] = [self _hashPoint:self.borderColorEndPoint];
    attributes[@"borderWidth"] = [self _hash:self.borderWidth];
    attributes[@"borderAlignment"] = [self _hash:self.borderAlignment];
    
    attributes[@"cornerRadiusTopLeft"] = [self _hash:self.cornerRadiusTopLeft];
    attributes[@"cornerRadiusTopRight"] = [self _hash:self.cornerRadiusTopRight];
    attributes[@"cornerRadiusBottomLeft"] = [self _hash:self.cornerRadiusBottomLeft];
    attributes[@"cornerRadiusBottomRight"] = [self _hash:self.cornerRadiusBottomRight];
    switch (self.imageType) {
        case MMImageDrawerFixed:
            attributes[@"size"] = [NSString stringWithFormat:@"Fixed:(%f,%f)",self.fixedSize.width,self.fixedSize.height];
            break;
        case MMImageDrawerResizable:
            attributes[@"size"] = @"Resizable";
        default:
            break;
    }
    return [[attributes.allKeys mm_map:^id(NSString *key) {
        return [NSString stringWithFormat:@"%@:%@",key,attributes[key]];
    }] mm_join:@"|"];
}

- (NSString *) _hash:(NSUInteger)hash{
    return [NSString stringWithFormat:@"%lu",(unsigned long)hash];
}

- (NSString *) _hashString:(NSString *)string{
    return [self _hash:string.description.hash];
}

- (NSString *) _hashSize:(CGSize)size{
    return [self _hash:NSStringFromCGSize(size).description.hash];
}
- (NSString *) _hashPoint:(CGPoint)point{
    return [self _hash:NSStringFromCGPoint(point).description.hash];
}

#pragma mark - Fill
- (MMImageDrawer *) fillColor:(UIColor *)color{
    
    self.colors = @[color];
    return self;
}
- (MMImageDrawer *) fillGradientColor:(NSArray<UIColor *> *)gradient
                            locations:(NSArray<NSNumber *> *)locations
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint{
    self.colors = gradient;
    self.colorLocations = locations;
    self.colorStartPoint = startPoint;
    self.colorEndPoint = endPoint;
    return self;
}

#pragma mark - Border
- (MMImageDrawer *) borderColor:(UIColor *)color{
    self.borderColors = @[color];
    return self;
}
- (MMImageDrawer *) borderGradientColor:(NSArray<UIColor *> *)gradient
                            locations:(NSArray<NSNumber *> *)locations
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint{
    self.borderColors = gradient;
    self.borderColorLocations = locations;
    self.borderColorStartPoint = startPoint;
    self.borderColorEndPoint = endPoint;
    return self;
}
- (MMImageDrawer *) borderWidth:(CGFloat)width{
    self.borderWidth = width;
    return self;
}
- (MMImageDrawer *) borderAlinment:(MMBorderAligment)alignment{
    self.borderAlignment = alignment;
    return self;
}

#pragma mark - Corner
- (MMImageDrawer *) cornerRadius:(CGFloat)raduis{
    return [self cornerWithTopLeft:raduis topRight:raduis
                        bottomLeft:raduis bottomRight:raduis];
}
- (MMImageDrawer *) cornerTopLeft:(CGFloat)topLeft{
    self.cornerRadiusTopLeft = topLeft;
    return self;
}
- (MMImageDrawer *) cornerTopRight:(CGFloat)topRight{
    self.cornerRadiusTopRight = topRight;
    return self;
}
- (MMImageDrawer *) cornerBottomLeft:(CGFloat)bottomLeft{
    self.cornerRadiusBottomLeft = bottomLeft;
    return self;
}
- (MMImageDrawer *) cornerBottomRight:(CGFloat)bottomRight{
    self.cornerRadiusBottomRight = bottomRight;
    return self;
}
- (MMImageDrawer *) cornerWithTopLeft:(CGFloat)topLeft
                             topRight:(CGFloat)topRight
                           bottomLeft:(CGFloat)bottomLeft
                          bottomRight:(CGFloat)bottomRight{
    return [[[[self cornerTopLeft:topLeft] cornerTopRight:topRight]
             cornerBottomLeft:bottomLeft] cornerBottomRight:bottomRight];
}

#pragma mark - Image
- (UIImage *) image{
    
    if (self.imageType == MMImageDrawerFixed) {
        return [self _imageWithSize:self.fixedSize useCache:YES];
    }else{
        self.borderAlignment = MMBorderAligmentInside;
        
        CGFloat cornerRadius = MAX(self.cornerRadiusTopLeft, self.cornerRadiusTopRight);
        cornerRadius = MAX(cornerRadius, self.cornerRadiusBottomLeft);
        cornerRadius = MAX(cornerRadius, self.cornerRadiusBottomRight);
        
        CGFloat capSize = ceil(MAX(cornerRadius, self.borderWidth));
        CGFloat imageSize = capSize * 2 + 1;
        
        UIImage * image = [self _imageWithSize:CGSizeMake(imageSize, imageSize)
                                      useCache:YES];
        
        UIEdgeInsets capInsets = UIEdgeInsetsMake(capSize, capSize, capSize, capSize);
        
        return [image resizableImageWithCapInsets:capInsets];
    }
    return nil;
}
- (UIImage *) _imageWithSize:(CGSize)size useCache:(BOOL)useCache{
    
    if (useCache && cachedImages[self.cacheKey]) {
        return cachedImages[self.cacheKey];
    }
    CGSize imageSize = size;
    CGRect rect = (CGRect){CGPointZero,imageSize};
    
    switch (self.borderAlignment) {
        case MMBorderAligmentInside:
            rect.origin.x += self.borderWidth / 2.0;
            rect.origin.y += self.borderWidth / 2.0;
            rect.size.width -= self.borderWidth;
            rect.size.height -= self.borderWidth;
            break;
        case MMBorderAligmentCenter:
            rect.origin.x += self.borderWidth / 2.0;
            rect.origin.y += self.borderWidth / 2.0;
            imageSize.width += self.borderWidth;
            imageSize.height += self.borderWidth;
            break;
        case MMBorderAligmentOutside:
            rect.origin.x += self.borderWidth / 2.0;
            rect.origin.y += self.borderWidth / 2.0;
            rect.size.width += self.borderWidth;
            rect.size.height += self.borderWidth;
            imageSize.width += (self.borderWidth * 2);
            imageSize.height += (self.borderWidth * 2);
            break;
        default:
            break;
    }
    
    CGFloat cornerRadius = MAX(self.cornerRadiusTopLeft, self.cornerRadiusTopRight);
    cornerRadius = MAX(cornerRadius, self.cornerRadiusBottomLeft);
    cornerRadius = MAX(cornerRadius, self.cornerRadiusBottomRight);
    
    UIImage * image = [UIImage imageWithSize:imageSize contextBlock:^(CGContextRef context) {
        
        // 1.border
        UIBezierPath * path;
        
        if (self.cornerRadiusTopLeft == self.cornerRadiusTopRight &&
            self.cornerRadiusTopLeft == self.cornerRadiusBottomLeft &&
            self.cornerRadiusTopLeft == self.cornerRadiusBottomRight &&
            self.cornerRadiusTopLeft > 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadiusTopLeft];
        } else if (cornerRadius > 0){
            
            CGFloat startAngle = M_PI;
            
            CGPoint topLeftCenter = CGPointMake(self.cornerRadiusTopLeft + self.borderWidth / 2.0,
                                                self.cornerRadiusTopLeft + self.borderWidth / 2.0);
            CGPoint topRightCenter = CGPointMake(imageSize.width - self.cornerRadiusTopRight - self.borderWidth / 2.0,
                                                 self.cornerRadiusTopRight + self.borderWidth / 2.0);
            CGPoint bottomRightCenter = CGPointMake(imageSize.width - self.cornerRadiusBottomRight - self.borderWidth / 2.0,
                                                    self.cornerRadiusTopRight + self.borderWidth / 2.0);
            CGPoint bottomLeftCenter = CGPointMake(self.cornerRadiusBottomLeft + self.borderWidth / 2.0,
                                                   imageSize.height - self.cornerRadiusBottomLeft - self.borderWidth / 2.0);
            
            UIBezierPath * mutablePath = UIBezierPath.bezierPath;
            
            // top left
            if (self.cornerRadiusTopLeft > 0) {
                [mutablePath addArcWithCenter:topLeftCenter
                                       radius:self.cornerRadiusTopLeft
                                   startAngle:startAngle
                                     endAngle:1.5*startAngle clockwise:YES];
            }else{
                [mutablePath moveToPoint:topLeftCenter];
            }
            
            // top right
            if (self.cornerRadiusTopRight > 0) {
                [mutablePath addArcWithCenter:topRightCenter
                                       radius:self.cornerRadiusTopRight
                                   startAngle:1.5*startAngle
                                     endAngle:2.0*startAngle clockwise:YES];
            }else{
                [mutablePath addLineToPoint:topRightCenter];
            }
            
            // bottom right
            if (self.cornerRadiusBottomRight > 0) {
                [mutablePath addArcWithCenter:bottomRightCenter
                                       radius:self.cornerRadiusBottomRight
                                   startAngle:2*startAngle
                                     endAngle:2.5*startAngle clockwise:YES];
            }else{
                [mutablePath addLineToPoint:bottomRightCenter];
            }
            
            // bottom left
            if (self.cornerRadiusBottomLeft > 0) {
                [mutablePath addArcWithCenter:bottomLeftCenter
                                       radius:self.cornerRadiusBottomLeft
                                   startAngle:2.5*startAngle
                                     endAngle:3*startAngle clockwise:YES];
            }else{
                [mutablePath addLineToPoint:bottomLeftCenter];
            }
            
            // close path
            if (self.cornerRadiusTopLeft > 0) {
                [mutablePath addLineToPoint:(CGPoint){
                    self.borderWidth / 2.0,
                    topLeftCenter.y
                }];
            }else{
                [mutablePath addLineToPoint:topLeftCenter];
            }
            
            // output path
            path = mutablePath;
        }else{
            path = [UIBezierPath bezierPathWithRect:rect];
        }

        // 2.fill
        CGContextSaveGState(context);
        if (self.colors.count <= 1) {
            [self.colors.firstObject setFill];
        }else{
            CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
            CFArrayRef colors = (__bridge CFArrayRef)([self.colors mm_map:^id(UIColor *color) {
                return (__bridge id)color.CGColor;
            }]);
            CGFloat locations[self.colorLocations.count];
            NSInteger index = 0;
            for (NSNumber * number in self.colorLocations) {
                locations[index] = number.floatValue;
                index ++;
            }
            
            CGGradientRef gradientRef = CGGradientCreateWithColors(colorRef, colors, locations);
            if (gradientRef) {
                CGPoint startPoint = CGPointMake(self.colorStartPoint.x * imageSize.width,
                                                 self.colorStartPoint.y * imageSize.height);
                CGPoint endPoint = CGPointMake(self.colorEndPoint.x * imageSize.width,
                                                 self.colorEndPoint.y * imageSize.height);
                CGContextAddPath(context, path.CGPath);
                CGContextClip(context);
                CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
            }
        }
        CGContextRestoreGState(context);
        
        
        // 3.stroke
        CGContextSaveGState(context);
        if (self.borderColors.count <= 1) {
            [self.borderColors.firstObject setStroke];
            path.lineWidth = self.borderWidth;
            [path stroke];
        }else{
            CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
            CFArrayRef colors = (__bridge CFArrayRef)([self.borderColors mm_map:^id(UIColor *color) {
                return (__bridge id)color.CGColor;
            }]);
            CGFloat locations[self.borderColorLocations.count];
            NSInteger index = 0;
            for (NSNumber * number in self.colorLocations) {
                locations[index] = number.floatValue;
                index ++;
            }
            
            CGGradientRef gradientRef = CGGradientCreateWithColors(colorRef, colors, locations);
            if (gradientRef) {
                CGPoint startPoint = CGPointMake(self.borderColorStartPoint.x * imageSize.width,
                                                 self.borderColorStartPoint.y * imageSize.height);
                CGPoint endPoint = CGPointMake(self.borderColorEndPoint.x * imageSize.width,
                                               self.borderColorEndPoint.y * imageSize.height);
                CGContextAddPath(context, path.CGPath);
                CGContextSetLineWidth(context, self.borderWidth);
                CGContextReplacePathWithStrokedPath(context);
                CGContextClip(context);
                CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
            }
            CGContextRestoreGState(context);
        }
    }];
    
    if (useCache) {
        cachedImages[self.cacheKey] = image;
    }
    return image;
}
@end
