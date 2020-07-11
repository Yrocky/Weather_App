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

typedef NS_ENUM(NSInteger ,MMTokenType) {
    MMTokenFloat,
    
    MMTokenPlus = 1,// +
    MMTokenMinus,// -
    
    MMTokenMul = 10,// *
    MMTokenDiv,// /
    
    MMTokenLParen = -20,// (
    MMTokenRParen = -30,// )
    
    MMTokenEOF = -40,
};

typedef NS_ENUM(NSUInteger ,MMOperatorPriority) {
    MMOperatorPriorityDefault,///<
    MMOperatorPriorityLow,///<低优先级
    MMOperatorPriorityEqual,///<优先级相等
    MMOperatorPriorityHigh,///<高优先级
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

///<当前token和otherToken的优先级比较，返回的结果为self和other的比较
- (MMOperatorPriority) operatorPriorityWith:(MMToken *)otherToken;

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
