//
//  UIImage+DrawImage.h
//  Weather_App
//
//  Created by Rocky Young on 2018/12/6.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MMDrawImageContextBlock)(CGContextRef context);

typedef NS_ENUM(NSUInteger ,MMImageDrawerType) {
    MMImageDrawerFixed,
    MMImageDrawerResizable
};

typedef NS_ENUM(NSUInteger , MMBorderAligment) {
    MMBorderAligmentInside,
    MMBorderAligmentCenter,
    MMBorderAligmentOutside
};

@interface MMImageDrawer : NSObject

@property (nonatomic ,assign) MMImageDrawerType imageType;
@property (nonatomic ,assign) CGSize fixedSize;

@property (nonatomic ,strong ,readonly) UIImage * image;

#pragma mark - Fill
- (MMImageDrawer *) fillColor:(UIColor *)color;
- (MMImageDrawer *) fillGradientColor:(NSArray<UIColor *> *)gradient
                            locations:(NSArray<NSNumber *> *)locations
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint;

#pragma mark - Border
- (MMImageDrawer *) borderColor:(UIColor *)color;
- (MMImageDrawer *) borderGradientColor:(NSArray<UIColor *> *)gradient
                              locations:(NSArray<NSNumber *> *)locations
                             startPoint:(CGPoint)startPoint
                               endPoint:(CGPoint)endPoint;
- (MMImageDrawer *) borderWidth:(CGFloat)width;
- (MMImageDrawer *) borderAlinment:(MMBorderAligment)alignment;

#pragma mark - Corner
- (MMImageDrawer *) cornerRadius:(CGFloat)raduis;
- (MMImageDrawer *) cornerTopLeft:(CGFloat)topLeft;
- (MMImageDrawer *) cornerTopRight:(CGFloat)topRight;
- (MMImageDrawer *) cornerBottomLeft:(CGFloat)bottomLeft;
- (MMImageDrawer *) cornerBottomRight:(CGFloat)bottomRight;
- (MMImageDrawer *) cornerWithTopLeft:(CGFloat)topLeft
                             topRight:(CGFloat)topRight
                           bottomLeft:(CGFloat)bottomLeft
                          bottomRight:(CGFloat)bottomRight;
@end

@interface UIImage (ImageDrawer)

#pragma mark - CGContext
+ (UIImage *) imageWithSize:(CGSize)size
               contextBlock:(MMDrawImageContextBlock)contextBlock;
+ (UIImage *) imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale
               contextBlock:(MMDrawImageContextBlock)contextBlock;

- (UIImage *) imageWithContextBlock:(MMDrawImageContextBlock)contextBlock;

#pragma mark - Add
- (UIImage *) addImage:(UIImage *)otherImage;

#pragma mark - Color
- (UIImage *) imageWithColor:(UIColor *)color;

#pragma mark - MMImageDrawer
+ (MMImageDrawer *) imageDrawerWithFixedSize:(CGSize)fixedSize;
+ (MMImageDrawer *) imageDrawerWithResizable;
@end

NS_ASSUME_NONNULL_END
