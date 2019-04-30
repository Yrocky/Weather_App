//
//  MMInterpreter.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMInterpreter.h"
#import "MMToken.h"
#import "MMBinAST.h"
#import "MMNumAST.h"
#import "MMUnaryOpAST.h"

@interface MMInterpreter ()

@property (nonatomic ,strong ,readwrite) MMLexer * lexer;
@property (nonatomic ,strong) MMToken * currentToken;
@end

@implementation MMInterpreter

+ (instancetype) interpreter:(MMLexer *)lexer{
    
    MMInterpreter * interpreter = [MMInterpreter new];
    interpreter.lexer = lexer;
    interpreter.currentToken = [lexer nextToken];
    return interpreter;
}

- (void) error{
    NSAssert(1, @"[lsbasi] Error");
}

#pragma mark - api method

- (NSInteger) factor{
    if (self.currentToken.type == MMTokenInterger) {
        NSInteger value = self.currentToken.value.integerValue;
        [self eat:MMTokenInterger];
        return value;
    } else if (self.currentToken.type == MMTokenLParen) {
        [self eat:MMTokenLParen];
        NSInteger result = [self expr];
        [self eat:MMTokenRParen];
        return result;
    }
    return 0.0;
}

///<语法图中的术语，在这个场景下，表示的是int类型的数字
- (NSInteger) term{
    
    NSInteger result = [self factor];
    while (self.currentToken.type == MMTokenDiv ||
           self.currentToken.type == MMTokenMul) {
        if (self.currentToken.type == MMTokenMul) {
            [self eat:MMTokenMul];
            result *= [self factor];
        } else if (self.currentToken.type == MMTokenDiv) {
            [self eat:MMTokenDiv];
            result /= [self factor];
        }
    }
    return result;
}

- (NSInteger) expr{
    NSInteger result = [self term];
    while (self.currentToken.type == MMTokenPlus ||
           self.currentToken.type == MMTokenMinus) {
        
        if (self.currentToken.type == MMTokenPlus) {
            [self eat:MMTokenPlus];
            result += [self term];
        } else if (self.currentToken.type == MMTokenMinus) {
            [self eat:MMTokenMinus];
            result -= [self term];
        }
    }
    return result;
}

- (void) eat:(MMTokenType)tokenType{
    if (self.currentToken.type == tokenType) {
        self.currentToken = [self.lexer nextToken];
        return;
    }
    [self error];
}

@end
