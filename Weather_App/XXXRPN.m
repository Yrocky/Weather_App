//
//  XXXRPN.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/7.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXRPN.h"
#import "MMToken.h"
#import "MMStack.h"

@interface XXXRPN ()

@property (nonatomic ,copy) NSString * expression;
@property (nonatomic ,strong) MMStack<MMToken *> * stack1;
@property (nonatomic ,strong) MMStack<MMToken *> * stack2;

@property (nonatomic ,assign) NSInteger pos;// 用于在下面遍历字符串的时候使用的游标

@end

@implementation XXXRPN

+ (instancetype) rpnWithExpression:(NSString *)expression{
    
    NSLog(@"[rpn] expression:%@",expression);
    XXXRPN * rpn = [XXXRPN new];
    rpn.expression = expression;
    rpn.pos = 0;
    [rpn expr];
    return rpn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stack1 = [MMStack new];
        self.stack2 = [MMStack new];
    }
    return self;
}

- (void) moveStack2TopTokenToStack1{
    MMToken * samePriToken = [self.stack2 pop];
    [self.stack1 push:samePriToken];
}

- (void) factor:(MMToken *)token{
    
    MMOperatorPriority pri = [self.stack2.top operatorPriorityWith:token];
    if (pri == MMOperatorPriorityEqual ||
        pri == MMOperatorPriorityHigh) {
        // 有相同优先级的token，则弹出来top运算符，然后压入当前运算符
        [self moveStack2TopTokenToStack1];
        [self.stack2 push:token];
    } else {
        // 其他优先级的，直接入栈2
        [self.stack2 push:token];
    }
}

- (void) expr{

    [self.stack1 clear];
    [self.stack2 clear];
    
    while (self.pos < self.expression.length) {
        
        NSString * current = [self.expression substringWithRange:NSMakeRange(self.pos, 1)];
        
        MMToken * token;
        if (MM_isInterger(current) || [current isEqualToString:@"."]) {
            token = [MMToken floatToken:[self floatString]];
            
            [self.stack1 push:token];// 如果是数字，直接放入到s1中
        } else if ([current isEqualToString:MM_opString(MMTokenPlus)]) {
            [self advance];
            token = [MMToken plusToken];
            
            [self factor:token];
            
        } else if ([current isEqualToString:MM_opString(MMTokenMinus)]) {
            [self advance];
            token = [MMToken minusToken];
            
            [self factor:token];
            
        } else if ([current isEqualToString:MM_opString(MMTokenMul)]) {
            [self advance];
            token = [MMToken mulToken];
            
            [self factor:token];
            
        } else if ([current isEqualToString:MM_opString(MMTokenDiv)]) {
            [self advance];
            token = [MMToken divToken];
            
            [self factor:token];
            
        } else if ([current isEqualToString:MM_opString(MMTokenLParen)]) {
            [self advance];
            token = [MMToken lParenToken];
            
            [self.stack2 push:token];// 左括号，直接入栈2
            
        } else if ([current isEqualToString:MM_opString(MMTokenRParen)]) {
            [self advance];
            token = [MMToken rParenToken];
            
            // 如果是右括号，将栈2中的所有元素依次弹出到栈1中，直到遇到左括号
            while (self.stack2.top.type != MMTokenLParen) {
                
                MMToken * otherToken = [self.stack2 pop];
                if (otherToken.type != MMTokenLParen) {                
                    [self.stack1 push:otherToken];
                }
            }
            // 将栈2顶端的token弹出，并且断言这个token是左括号类型的
            NSAssert(self.stack2.pop.type == MMTokenLParen, @"这一个token一定要是左括号，不然请检查输入的表达式是否正确");
        }
    }
    
    while (nil != self.stack2.top) {    
        [self moveStack2TopTokenToStack1];
    }
}

- (NSString *) floatString{
    NSString * floatStr = @"";
    while (self.pos < self.expression.length &&
           (MM_isInterger([self.expression substringWithRange:NSMakeRange(self.pos, 1)]) ||
            [[self.expression substringWithRange:NSMakeRange(self.pos, 1)] isEqualToString:@"."])) {
               
               NSString * otherString = [self.expression substringWithRange:NSMakeRange(self.pos, 1)];
               floatStr = [floatStr stringByAppendingString:otherString];
               [self advance];
           }
    return floatStr;
}

///<自增pos索引
- (void) advance{
    self.pos += 1;
}

- (void) backwards{
    self.pos -= 1;
}

- (void) calculateValueFromStack2With:(MMTokenType)type{
    MMToken * otherToken = [self.stack2 pop];
    MMToken * oneToken = [self.stack2 pop];
    NSAssert(oneToken.type == otherToken.type &&
             oneToken.type == MMTokenFloat, @"要进行运算的两个token必须是float类型的:[%@][%@]",oneToken,otherToken);
    CGFloat value = 0.0f;
    if (type == MMTokenPlus) {
        value = oneToken.value.floatValue + otherToken.value.floatValue;
    } else if (type == MMTokenMinus) {
        value = oneToken.value.floatValue - otherToken.value.floatValue;
    } else if (type == MMTokenMul) {
        value = oneToken.value.floatValue * otherToken.value.floatValue;
    } else if (type == MMTokenDiv) {
        value = oneToken.value.floatValue / otherToken.value.floatValue;
    }
    [self.stack2 push:[MMToken floatToken:[NSString stringWithFormat:@"%f",value]]];
}

#pragma makr - api

- (CGFloat) result{

    self.pos = self.stack1.size - 1;
    while (self.pos >= 0) {
        MMToken * token = [self.stack1 peekStack:self.pos];
        [self backwards];
    
        if (token.type == MMTokenFloat) {
            [self.stack2 push:token];
        } else {
            [self calculateValueFromStack2With:token.type];
        }
    }
    return self.stack2.pop.value.floatValue;
}

- (NSString *) rpnString{
    
    NSString * str = @"";
    while (nil != self.stack1.top) {
        str = [self.stack1.pop.value stringByAppendingString:str];
    }
    return str;
}
@end
