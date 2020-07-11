//
//  MMLexer.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMLexer.h"
#import "MMToken.h"

@interface MMLexer ()
@property (nonatomic ,copy ,readwrite) NSString * text;
@property (nonatomic ,assign) NSUInteger pos;// 用于在下面遍历字符串的时候使用的游标
@property (nonatomic ,copy) NSString * currentStr;
@end

@implementation MMLexer

+ (instancetype) lexer:(NSString *)text{

    NSAssert(nil != text, @"请输入不为空的字符串");
    
    MMLexer * lexer = [MMLexer new];
    lexer.text = text;
    [lexer skipWhitespace];
    lexer.pos = 0;
    lexer.currentStr = [lexer.text substringToIndex:1];
    return lexer;
}

///<自增pos索引
- (void) advance{

    self.pos += 1;
    if (self.pos > self.text.length - 1) {
        self.currentStr = @"";
    }
}

- (void) skipWhitespace{
    self.text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

///<如果一个字符串是数字开始的，遍历他后面的所有字符串，直到不是数字为止
///<主要是为了获取多位数的数字，比如:89、100
- (NSString *) intergerString{
    NSString * interger = @"";
    while (self.pos < self.text.length &&
           MM_isInterger([self.text substringWithRange:NSMakeRange(self.pos, 1)])) {
        
        NSString * otherString = [self.text substringWithRange:NSMakeRange(self.pos, 1)];
        interger = [interger stringByAppendingString:otherString];
        [self advance];
    }
    return interger;
}

- (NSString *) floatString{
    NSString * floatStr = @"";
    while (self.pos < self.text.length &&
           (MM_isInterger([self.text substringWithRange:NSMakeRange(self.pos, 1)]) ||
            [[self.text substringWithRange:NSMakeRange(self.pos, 1)] isEqualToString:@"."])) {

               NSString * otherString = [self.text substringWithRange:NSMakeRange(self.pos, 1)];
               floatStr = [floatStr stringByAppendingString:otherString];
               [self advance];
    }
    return floatStr;
}

///<根据pos来解析文本，返回对应的token
///<如果是运算符或者括号，返回对应的token
///<如果是数字，会去寻找最大的数字字符串
- (MMToken *) nextToken{
    
    // 遍历
    while (self.pos < self.text.length) {
        
        NSString * current = [self.text substringWithRange:NSMakeRange(self.pos, 1)];

        if (MM_isInterger(current) || [current isEqualToString:@"."]) {
            return [MMToken floatToken:[self floatString]];
            
        } else if ([current isEqualToString:MM_opString(MMTokenPlus)]) {
            [self advance];
            return [MMToken plusToken];
            
        } else if ([current isEqualToString:MM_opString(MMTokenMinus)]) {
            [self advance];
            return [MMToken minusToken];
            
        } else if ([current isEqualToString:MM_opString(MMTokenMul)]) {
            [self advance];
            return [MMToken mulToken];
            
        } else if ([current isEqualToString:MM_opString(MMTokenDiv)]) {
            [self advance];
            return [MMToken divToken];
            
        } else if ([current isEqualToString:MM_opString(MMTokenLParen)]) {
            [self advance];
            return [MMToken lParenToken];
            
        } else if ([current isEqualToString:MM_opString(MMTokenRParen)]) {
            [self advance];
            return [MMToken rParenToken];
        }
    }
    return [MMToken eofToken];
}

@end
