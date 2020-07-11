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
#define AttBuilderStyle(string,style) [HLLAttributedBuilder builderWithString:string defaultStyle:style]


#ifndef RX
#define RX(pattern) [[NSRegularExpression alloc] initWithPattern:pattern]
#endif

@interface NSRegularExpression (RX)

- (instancetype) initWithPattern:(NSString *)pattern;
// 在str中找寻匹配pattern的字符串
- (NSArray <NSTextCheckingResult *>*) matches:(NSString *)str;
// 在str中找寻匹配pattern的第一个字符串
- (nullable NSTextCheckingResult *) firstMatch:(NSString *)str;
// 遍历找到的字符串
- (void) enumMatches:(void(^)(NSTextCheckingResult * result,NSUInteger index))handle inString:(NSString *)string;
// 对查找到的字符串进行替换
- (NSString *) replaceMatchedStringsWith:(NSString *(^)(NSString *matchedString))replace inString:(NSString *)string;
@end

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

- (HLLAttributedBuilder *) firstConfigString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) firstConfigStringAndStyle;

- (HLLAttributedBuilder *) configString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle;
@end
