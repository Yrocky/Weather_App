//
//  MMParserr.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMParserr.h"
#import "MMLexer.h"
#import "MMToken.h"
#import "MMBinAST.h"
#import "MMNumAST.h"
#import "MMUnaryOpAST.h"

@interface MMParserr ()

@property (nonatomic ,strong ,readwrite) MMLexer * lexer;
@property (nonatomic ,strong) MMToken * currentToken;
@end

@implementation MMParserr

+ (instancetype) parser:(MMLexer *)lexer{
    
    MMParserr * parser = [MMParserr new];
    parser.lexer = lexer;
    parser.currentToken = [lexer nextToken];
    return parser;
}

#pragma mark - api

- (MMAST *) parse{
    MMAST * expr = [self expr];
    if (self.currentToken.type != MMTokenEOF) {
        [self error];
    }
    return expr;
}

#pragma mark - private method

- (void) error{
    NSAssert(1, @"[lsbasi] Error");
}

#pragma mark > SyntaxDiagram
- (MMAST *) term{
    MMAST * node = [self factor];
    while (self.currentToken.type == MMTokenDiv ||
           self.currentToken.type == MMTokenMul) {
        MMToken * token = self.currentToken;
        if (self.currentToken.type == MMTokenMul) {
            [self eat:MMTokenMul];
        } else if (self.currentToken.type == MMTokenDiv) {
            [self eat:MMTokenDiv];
        }
        node = [MMBinAST binAST:node op:token right:[self factor]];
    }
    return node;
}

- (MMAST *) factor{
    if (self.currentToken.type == MMTokenPlus) {
        MMToken * token = self.currentToken;
        [self eat:MMTokenPlus];
        return [MMUnaryOpAST unaryOpAST:token expr:[self factor]];
        
    } else if (self.currentToken.type == MMTokenMinus) {
        MMToken * token = self.currentToken;
        [self eat:MMTokenMinus];
        return [MMUnaryOpAST unaryOpAST:token expr:[self factor]];
        
    } else if (self.currentToken.type == MMTokenFloat) {
        MMToken * token = self.currentToken;
        [self eat:MMTokenFloat];
        return [MMNumAST numAST:token];
        
    } else if (self.currentToken.type == MMTokenLParen) {
        [self eat:MMTokenLParen];
        MMAST * node = [self expr];
        [self eat:MMTokenRParen];
        return node;
    }
    return nil;
}

///<构建ast的核心代码，通过遍历lexer中的token来生成ast
- (MMAST *) expr{
    MMAST * node = [self term];
    while (self.currentToken.type == MMTokenPlus ||
           self.currentToken.type == MMTokenMinus) {
        MMToken * op = self.currentToken;
        if (self.currentToken.type == MMTokenPlus) {
            [self eat:MMTokenPlus];
        } else if (self.currentToken.type == MMTokenMinus) {
            [self eat:MMTokenMinus];
        }
        node = [MMBinAST binAST:node op:op right:[self term]];
    }
    return node;
}

- (void) eat:(MMTokenType)tokenType{
    if (self.currentToken.type == tokenType) {
        self.currentToken = [self.lexer nextToken];
        return;
    }
    [self error];
}

@end
