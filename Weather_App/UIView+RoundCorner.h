//
//  UIView+RoundCorner.h
//  Weather_App
//
//  Created by user1 on 2018/8/9.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>


// 为UIView和CALayer添加圆角、阴影、描边特性的辅助类
@interface MM_RoundCorner : NSObject

// defaul is [UIColor clearColor]
- (MM_RoundCorner * (^)(UIColor * color)) outerColor;
- (MM_RoundCorner * (^)(UIColor * color)) innerColor;

- (MM_RoundCorner * (^)(CGSize radius)) radius;
- (MM_RoundCorner * (^)(UIRectCorner corners)) corners;

- (MM_RoundCorner * (^)(UIColor * borderColor)) borderColor;
- (MM_RoundCorner * (^)(CGFloat borderWidth)) borderWidth;

// 设置阴影的时候需要指定一个非clearColor的`innerColor`值
- (MM_RoundCorner * (^)(UIColor * shadowColor)) shadowColor;
- (MM_RoundCorner * (^)(CGSize shadowOffset)) shadowOffset;
- (MM_RoundCorner * (^)(CGFloat shadowBlur)) shadowBlur;

@end

@interface UIView (XWAddForRoundedCorner)

- (void) mm_makeRoundCorner:(void(^)(MM_RoundCorner *make))block;
@end

@interface CALayer (XWAddForRoundedCorner)

@property (nonatomic, strong) UIImage * mm_contentImage;
- (void) mm_makeRoundCorner:(void(^)(MM_RoundCorner *make))block;
@end
