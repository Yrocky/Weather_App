//
//  UIView+AsyncDrawImage.m
//  Weather_App
//
//  Created by user1 on 2018/3/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "UIView+AsyncDrawImage.h"


@implementation UIView (AsyncDrawImage)

+ (UIImage *) imageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

+ (CGColorSpaceRef) asyncColorSpaceForImageRef:(CGImageRef)imageRef {
    // current
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = CGColorSpaceCreateDeviceRGB();
        CFAutorelease(colorspaceRef);
    }
    return colorspaceRef;
}

- (void) _asyncDrawImage:(UIImage *(^)())handle withSize:(CGSize)size result:(void(^)(UIImage *))result{
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    //    NSLog(@"size:%@",NSStringFromCGSize(size));
    //    NSLog(@"self.bounds:%@",NSStringFromCGRect(self.bounds));
    
    // 1.使用SDWebImage内的图片解压算法进行图片的加载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        void (^mainQueueResult)(UIImage *image) = ^(UIImage *image){
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(image);
                });
            }
        };
        UIImage * image = handle();
        @autoreleasepool{
            
            CGImageRef imageRef = image.CGImage;
            CGColorSpaceRef colorspaceRef = [UIView asyncColorSpaceForImageRef:imageRef];
            
            size_t width = CGImageGetWidth(imageRef);
            size_t height = CGImageGetHeight(imageRef);
            size_t bytesPerRow = 4 * width;
            
            // 由于SD内部的图片是没有alpha的，这里借鉴YYKit中的压缩图片方法，获取到有alpha的bitmapInfo
            CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
            BOOL hasAlpha = NO;
            if (alphaInfo == kCGImageAlphaPremultipliedLast ||
                alphaInfo == kCGImageAlphaPremultipliedFirst ||
                alphaInfo == kCGImageAlphaLast ||
                alphaInfo == kCGImageAlphaFirst) {
                hasAlpha = YES;
            }
            
            // BGRA8888 (premultiplied) or BGRX8888
            // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
            bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
            
            
            // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
            // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
            // to create bitmap graphics contexts without alpha info.
            CGContextRef context = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8,
                                                         bytesPerRow,
                                                         colorspaceRef,
                                                         // 这里的bitmapInfo使用YYKit中的方法，sd中的为kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast
                                                         bitmapInfo);
            if (context != NULL) {
                // Draw the image into the context and retrieve the new bitmap image without alpha
                CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
                
                CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
                UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                                 scale:image.scale
                                                           orientation:image.imageOrientation];
                
                CGContextRelease(context);
                CGImageRelease(imageRefWithoutAlpha);
                
                if (mainQueueResult) {
                    mainQueueResult(imageWithoutAlpha);
                }
            }
        }
    });
    
    return;
    
    // 2.采用最简单的异步绘制图片的方法，内部需要计算图片的位置，耦合控件的class，不是很好
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        void (^mainQueueResult)(UIImage *image) = ^(UIImage *image){
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(image);
                });
            }
        };
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);// 获取画板的尺寸
        UIImage * image = handle();
        CGSize imageSize = size;
        
        if (image.size.width == 1 && image.size.height == 1) {
            // 使用颜色创建的图片，当然也有可能真的有{1，1}的图片，暂时先不考虑
            // note 针对于实际上是{1，1}的图片，可能会有bug
        }
        else if (image.size.width != imageSize.width ||
                 image.size.height != imageSize.height) {
            
            // magic here
            if ([self isKindOfClass:[UIImageView class]]) {
                // imageView设置image的时候会涉及到拉伸的效果，如果image的size小于imageView的size，就会显示为拉伸
                // 当然，如果image的size和imageView的size一样，则是正常显示
                // note 可能会在设置一些图片的时候有显示bug
            }else if ([self isKindOfClass:[UIButton class]]){
                // button有可能是设置image，image的size有可能小于imageView的size，因此这里将draw的size设置为图片的size
                imageSize = image.size;
            }
        }
        if (!image) {
            mainQueueResult(image);
        }else{
            CGRect bounds = (CGRect){
                (selfWidth - imageSize.width) / 2,
                (selfHeight - imageSize.height) / 2,
                imageSize
            };
            NSLog(@"self.bounds:%@",NSStringFromCGRect(bounds));
            
            [image drawInRect:bounds];
            UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            mainQueueResult(temp);
        }
    });
}

- (void) asyncDrawImage:(NSString *)imageName result:(void(^)(UIImage *))result{
    
    [self asyncDrawImage:imageName withSize:self.frame.size result:result];
}

- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size result:(void(^)(UIImage *))result{
    
    if (imageName == nil && result) {
        result(nil);
        return;
    }
    
    [self _asyncDrawImage:^UIImage *{
        return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName]];
    } withSize:size result:result];
}

- (void) asyncDrawImageWithColor:(UIColor *)color result:(void(^)(UIImage *image))result{
    
    [self asyncDrawImageWithColor:color withSize:self.frame.size result:result];
}

- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size result:(void(^)(UIImage *image))result{
    
    if (!color) {
        if (result) {
            result(nil);
        }
        return;
    }
    [self _asyncDrawImage:^UIImage *{
        return [UIView imageWithColor:color];
    } withSize:size result:result];
}

@end

@implementation UIImageView (AsyncDrawImage)

- (void) asyncDrawImage:(NSString *)imageName{
    [self asyncDrawImage:imageName withSize:self.bounds.size];
}
- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size{
    [self asyncDrawImage:imageName withSize:size result:^(UIImage *image) {
        self.image = image;
    }];
}

- (void) asyncDrawImageWithColor:(UIColor *)color{
    [self asyncDrawImageWithColor:color withSize:self.bounds.size];
}
- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size{
    [self asyncDrawImageWithColor:color withSize:size result:^(UIImage *image) {
        self.image = image;
    }];
}

- (void) asyncDrawHighlightImage:(NSString *)imageName{
    [self asyncDrawHighlightImage:imageName withSize:self.bounds.size];
}
- (void) asyncDrawHighlightImage:(NSString *)imageName withSize:(CGSize)size{
    [self asyncDrawImage:imageName withSize:size result:^(UIImage *image) {
        self.highlightedImage = image;
    }];
}

- (void) asyncDrawHighlightImageWithColor:(UIColor *)color{
    [self asyncDrawHighlightImageWithColor:color withSize:self.bounds.size];
}
- (void) asyncDrawHighlightImageWithColor:(UIColor *)color withSize:(CGSize)size{
    [self asyncDrawImageWithColor:color withSize:size result:^(UIImage *image) {
        self.highlightedImage = image;
    }];
}
@end

@implementation UIButton (AsyncDrawImage)

- (void) asyncDrawImage:(NSString *)imageName forState:(UIControlState)state{
    [self asyncDrawImage:imageName withSize:self.bounds.size forState:state];
}

- (void) asyncDrawImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state{
    [self asyncDrawImage:imageName withSize:size result:^(UIImage *image) {
        [self setImage:image forState:state];
    }];
}

- (void) asyncDrawBackgroundImage:(NSString *)imageName forState:(UIControlState)state{
    [self asyncDrawImage:imageName withSize:self.bounds.size forState:state];
}

- (void) asyncDrawBackgroundImage:(NSString *)imageName withSize:(CGSize)size forState:(UIControlState)state{
    [self asyncDrawImage:imageName withSize:size result:^(UIImage *image) {
        [self setBackgroundImage:image forState:state];
    }];
}

- (void) asyncDrawImageWithColor:(UIColor *)color forState:(UIControlState)state{
    [self asyncDrawImageWithColor:color withSize:self.bounds.size forState:state];
}

- (void) asyncDrawImageWithColor:(UIColor *)color withSize:(CGSize)size forState:(UIControlState)state{
    [self asyncDrawImageWithColor:color withSize:size result:^(UIImage *image) {
        [self setImage:image forState:state];
    }];
}

// async set background image with color for state
- (void) asyncDrawBackgroundImageWithColor:(UIColor *)color forState:(UIControlState)state{
    [self asyncDrawBackgroundImageWithColor:color withSize:self.bounds.size forState:state];
}

- (void) asyncDrawBackgroundImageWithColor:(UIColor *)color withSize:(CGSize)size forState:(UIControlState)state{
    [self asyncDrawImageWithColor:color withSize:size result:^(UIImage *image) {
        [self setBackgroundImage:image forState:state];
    }];
}

@end

