//
//  XXXCalculator.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXCalculator.h"
#import "XXXContext.h"
#import "XXXExpression.h"
#import "MMStack.h"
#import "NSString+Exten.h"
#import "NSArray+Sugar.h"
#import "HLLAttributedBuilder.h"

@implementation XXXCalculator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _context = [XXXContext new];
    }
    return self;
}
- (float) calculatorWith:(NSString *)expression{
    
    if (nil == expression) {
        return 0.0f;
    }
    
    _expression = expression;
    
    NSArray<NSString *> *vars = [expression separatedByStrings:@[@"\\+",@"\\-",@"\\*",@"\\/"]
                                                     contained:NO];
    if (!vars.count) {
        return 0.0f;
    }
    
    NSArray<NSString *> * operators = [[RX(@"[\\+\\-\\*\\/]") matches:expression] mm_map:^id(NSTextCheckingResult *result) {
        return [expression substringWithRange:result.range];
    }];
    
    [vars mm_each:^(NSString *var) {
        [_context addVar:var
                  forKey:var];
    }];
    
    XXXExpression * left = [XXXVariableExpression varExpression:vars[0]];
    XXXExpression * right;
    
    MMStack<XXXExpression *> * stack = [MMStack new];
    [stack push:left];
    
    for (int i = 1; i < vars.count; i += 1) {
        left = [stack pop];
        right = [XXXVariableExpression varExpression:vars[i]];
        NSString * operator = operators[i - 1];
        if ([operator isEqualToString:@"+"]) {
            XXXAddOperatorExpression * add = [XXXAddOperatorExpression new];
            [add left:left right:right];
            [stack push:add];
        }
        else if ([operator isEqualToString:@"-"]) {
            XXXSubOperatorExpression * sub = [XXXSubOperatorExpression new];
            [sub left:left right:right];
            [stack push:sub];
        }
        else if ([operator isEqualToString:@"*"]) {
            XXXMulOperatorExpression * mul = [XXXMulOperatorExpression new];
            [mul left:left right:right];
            [stack push:mul];
        }
        else if ([operator isEqualToString:@"/"]) {
            XXXDivOperatorExpression * div = [XXXDivOperatorExpression new];
            [div left:left right:right];
            [stack push:div];
        }
    }
    float value = [[stack pop] interpretInContext:_context];
    NSLog(@"[Interpreter] exp:%@ result:%f",expression,value);
    [stack clear];
    [_context clear];
    return value;
}
@end
