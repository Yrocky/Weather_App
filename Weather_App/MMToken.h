//
//  MMToken.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMObjDescribeAble.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger ,MMTokenType) {
    MMTokenFloat,
    MMTokenPlus,// +
    MMTokenMinus,// -
    MMTokenMul,// *
    MMTokenDiv,// /
    MMTokenLParen,// (
    MMTokenRParen,// )
    MMTokenEOF,
};

static NSString * ops = @"+-*/";

///<判断字符串是否是运算符
extern inline BOOL MM_isOps(NSString * str);

///<将运算符枚举转换成字符串
extern inline NSString * MM_opString(MMTokenType type);

///<判断字符串是否可转化成数字
extern inline BOOL MM_isInterger(NSString * str);

// 在词法分析中产生的token流的抽象，也是语法分析阶段中所使用的输入，上面的tokenType根据语法中的定义来穷举所有情况
@interface MMToken : NSObject<MMObjDescribeAble>

@property (nonatomic ,assign ,readonly) MMTokenType type;
@property (nonatomic ,copy ,readonly) NSString * value;

+ (instancetype) token:(MMTokenType)type value:(NSString *)value;

+ (instancetype) floatToken:(NSString *)value;
+ (instancetype) plusToken;
+ (instancetype) minusToken;
+ (instancetype) mulToken;
+ (instancetype) divToken;
+ (instancetype) lParenToken;
+ (instancetype) rParenToken;
+ (instancetype) eofToken;
@end

NS_ASSUME_NONNULL_END
