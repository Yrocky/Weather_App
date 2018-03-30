//
//  UIView+AsyncDrawImage.h
//  Weather_App
//
//  Created by user1 on 2018/3/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (AsyncDrawImage)

// async load image in which type is png
- (void) asyncDrawImage:(NSString *)imageName result:(void(^)(UIImage *image))result;
- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size result:(void(^)(UIImage *image))result;

// async load image with color
- (void) asyncDrawImageWithColor:(UIColor *)color result:(void(^)(UIImage *image))result;
- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size result:(void(^)(UIImage *image))result;
@end

@interface UIImageView (AsyncDrawImage)

// async load image in which type is png
- (void) asyncDrawImage:(NSString *)imageName;
- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size;

// async load image with color
- (void) asyncDrawImageWithColor:(UIColor *)color;
- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size;

// async load highlight image in which type is png
- (void) asyncDrawHighlightImage:(NSString *)imageName;
- (void) asyncDrawHighlightImage:(NSString *)imageName withSize:(CGSize)size;

// async load highlight image with color
- (void) asyncDrawHighlightImageWithColor:(UIColor *)color;
- (void) asyncDrawHighlightImageWithColor:(UIColor *)color withSize:(CGSize)size;
@end

@interface UIButton (AsyncDrawImage)

// async set image for state
- (void) asyncDrawImage:(NSString *)imageName forState:(UIControlState)state;
- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state;

// async set background image for state
- (void) asyncDrawBackgroundImage:(NSString *)imageName forState:(UIControlState)state;
- (void) asyncDrawBackgroundImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state;

// async set image with color for state
- (void) asyncDrawImageWithColor:(UIColor *)color forState:(UIControlState)state;
- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size forState:(UIControlState)state;

// async set background image with color for state
- (void) asyncDrawBackgroundImageWithColor:(UIColor *)color forState:(UIControlState)state;
- (void) asyncDrawBackgroundImageWithColor:(UIColor *)color withSize:(CGSize)size forState:(UIControlState)state;

@end
