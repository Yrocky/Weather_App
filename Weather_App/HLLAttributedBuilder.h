//
//  HLLAttributedBuilder.h
//  Weather_App
//
//  Created by user1 on 2017/8/24.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef AttBuilder

#define AttBuilder [HLLAttributedBuilder builder]

#endif

#define AttBuilderWith(string) [HLLAttributedBuilder builderWithString:string]

@interface HLLAttributedBuilder : NSObject

// black 16
+ (instancetype) builder;
// { NS...AttributeName : (id)value}
+ (instancetype) builderWithDefaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) appendString:(NSString *)string;
- (HLLAttributedBuilder *(^)(NSString *str)) appendString;

- (HLLAttributedBuilder *) appendString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) appendStringAndStyle;

// 根据添加的字符串属性生成属性字符串
- (NSAttributedString *) attributedString;
- (NSAttributedString *(^)())attributedStr;

@end

@interface HLLAttributedBuilder (Attachment)

// 可以根据图片设置属性字符串
- (HLLAttributedBuilder *) appendAttachment:(NSTextAttachment *)attachment;
- (HLLAttributedBuilder *(^)(NSTextAttachment *))appendAttachment;
@end

// 给定文本，对需要的内容设置对应的属性字符串，并且区分大小写，支持使用正则匹配
@interface HLLAttributedBuilder (Config)

+ (instancetype) builderWithString:(NSString *)originalString;
+ (instancetype) builderWithString:(NSString *)originalString defaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) configString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle;
@end
