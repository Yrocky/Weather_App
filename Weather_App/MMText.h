//
//  MMText.h
//  Weather_App
//
//  Created by user1 on 2018/1/3.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMRenderProtocol.h"

typedef NS_ENUM(NSUInteger ,MMTextAlight) {
    
    MMTextAlightLeft = 0,
    MMTextAlightCenter,
    MMTextAlightRight
};

@interface MMUnderline : NSObject<MMRenderProtocol>{
    UIFont * _font;
    UIColor * _color;
}

/// 颜色
@property (nonatomic ,strong ,readonly) UIColor * color;
@property (nonatomic ,strong) NSString * hexColor;

/// 对齐方式
@property (nonatomic ,assign) MMTextAlight alight;

/// 宽高尺寸
@property (nonatomic ,assign) CGSize size;
@end


@interface MMText : NSObject<MMRenderProtocol>{
    UIFont * _font;
    UIColor * _color;
}

/// 字体
@property (nonatomic ,strong ,readonly) UIFont * font;
@property (nonatomic ,strong) NSString * fontName;
@property (nonatomic ,assign) NSInteger fontSize;

/// 颜色
@property (nonatomic ,strong ,readonly) UIColor * color;
@property (nonatomic ,strong) NSString * hexColor;

/// 对齐方式
@property (nonatomic ,assign) MMTextAlight textAlight;

/// 下划线
@property (nonatomic ,strong) MMUnderline * underline;
@end
