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

@end

@interface UIButton (AsyncDrawImage)

// async set image for state
- (void) asyncDrawImage:(NSString *)imageName forState:(UIControlState)state;
- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state;

// async set background image for state
- (void) asyncDrawBackgroundImage:(NSString *)imageName forState:(UIControlState)state;
- (void) asyncDrawBackgroundImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state;

- (void) asyncDrawBackgroundImageWithColor:(UIColor *)color forState:(UIControlState)state;
@end

