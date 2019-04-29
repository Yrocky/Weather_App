//
//  XXXExpression.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXXContext;

NS_ASSUME_NONNULL_BEGIN

// 操作符的基类，也叫做抽象表达式
// 表达式分为终结(Terminal Expression)、非终结表达式(Nonterminal Expression)
// 终结表达式，可以理解为在具体运算的时候作为一个整体一部分
// s=a+b，其中a和b都是终结表达式，他们自己又可以是其他终结表达式组成的，a=c-d, b=e*f
// 上面的运算操作中，等号、加号、减号等这些都可以认为是非终结表达式
@interface XXXExpression : NSObject

/// subclass override
- (float) interpretInContext:(XXXContext *)context;
@end

// 变量操作符
@interface XXXVariableExpression : XXXExpression
@property (nonatomic ,copy) NSString * value;
+ (instancetype) varExpression:(NSString *)value;
@end

// 操作符的基类
@interface XXXOperatorExpression : XXXExpression
@property (nonatomic ,strong) XXXExpression * left;
@property (nonatomic ,strong) XXXExpression * right;
- (void) left:(XXXExpression *)left right:(XXXExpression *)right;
@end

// +
@interface XXXAddOperatorExpression : XXXOperatorExpression

@end

// -
@interface XXXSubOperatorExpression : XXXOperatorExpression

@end

// *
@interface XXXMulOperatorExpression : XXXOperatorExpression

@end

// /
@interface XXXDivOperatorExpression : XXXOperatorExpression

@end

NS_ASSUME_NONNULL_END
