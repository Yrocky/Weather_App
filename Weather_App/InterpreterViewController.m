//
//  InterpreterViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/28.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "InterpreterViewController.h"
#import "MMStack.h"
#import "NSString+Exten.h"
#import "NSArray+Sugar.h"
#import "HLLAttributedBuilder.h"

// 在解释器模式中，它的任务一般是用来存放文法中各个终结符所对应的具体值
@interface XXXContext : NSObject{
    NSMutableDictionary * _vars;
}
@property (nonatomic ,copy ,readonly) NSDictionary * variables;

- (NSString *) varWithKey:(NSString *)key;
- (void) addVar:(NSString *)var forKey:(NSString *)key;
@end

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


// 定义一个计算类，用于解释并实现解释文本的逻辑
@interface XXXCalculator : NSObject{
    NSString * _expression;
    XXXContext * _context;
}

- (float) calculatorWith:(NSString *)expression;
@end

@interface InterpreterViewController ()

@end

@implementation InterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBaseExpression];
}

- (void) testBaseExpression{
    
    NSString * exp = @"";
    float result = 0.0f;
    {
        exp = @"8+3-6*4/2";
        XXXCalculator * calculator = [XXXCalculator new];
        result = [calculator calculatorWith:exp];
        NSLog(@"[Interpreter] exp:%@ result:%f",exp,result);
    }
    {
        exp = @"2*3/6";
        XXXCalculator * calculator = [XXXCalculator new];
        result = [calculator calculatorWith:exp];
        NSLog(@"[Interpreter] exp:%@ result:%f",exp,result);
    }
    {
        exp = @"2+3*6";
        XXXCalculator * calculator = [XXXCalculator new];
        result = [calculator calculatorWith:exp];
        NSLog(@"[Interpreter] exp:%@ result:%f",exp,result);
    }
}

@end

@implementation XXXContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vars = [NSMutableDictionary new];
    }
    return self;
}

- (void)addVar:(NSString *)var forKey:(NSString *)key{
    NSAssert(nil != var, @"var is null");
    NSAssert(nil != key, @"key is null");
    key = [NSString stringWithFormat:@"var:%@",key];
    if (![_vars.allKeys containsObject:key]) {
        _vars[key] = var;
    }
}

- (NSString *) varWithKey:(NSString *)key{
    NSAssert(nil != key, @"key is null");
    key = [NSString stringWithFormat:@"var:%@",key];
    return _vars[key];
}

- (NSDictionary *)variables{
    return _vars.copy;
}
@end

@implementation XXXExpression
- (float)interpretInContext:(XXXContext *)context{
    return 0.0;
}
@end

@implementation XXXVariableExpression

+ (instancetype) varExpression:(NSString *)value{
    XXXVariableExpression * exp = [XXXVariableExpression new];
    exp.value = value;
    return exp;
}
- (float)interpretInContext:(XXXContext *)context{
    if (nil == self.value) {
        return 0.0f;
    }
    return [[context varWithKey:self.value] floatValue];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _value];
}
@end
@implementation XXXOperatorExpression

- (void)left:(XXXExpression *)left right:(XXXExpression *)right{
    self.left = left;
    self.right = right;
}
@end

@implementation XXXAddOperatorExpression

- (float)interpretInContext:(XXXContext *)context{
    return [self.left interpretInContext:context] + [self.right interpretInContext:context];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ + %@", self.left,self.right];
}
@end

@implementation XXXSubOperatorExpression
- (float)interpretInContext:(XXXContext *)context{
    return [self.left interpretInContext:context] - [self.right interpretInContext:context];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.left,self.right];
}
@end

@implementation XXXMulOperatorExpression
- (float)interpretInContext:(XXXContext *)context{
    return [self.left interpretInContext:context] * [self.right interpretInContext:context];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ * %@", self.left,self.right];
}
@end

@implementation XXXDivOperatorExpression
- (float)interpretInContext:(XXXContext *)context{
    float rightValue = [self.right interpretInContext:context];
    NSAssert(0 != rightValue, @"right value cant be zero");
    return [self.left interpretInContext:context] / rightValue;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ / %@", self.left,self.right];
}
@end

@implementation XXXCalculator

- (float) calculatorWith:(NSString *)expression{
    
    if (nil == expression) {
        return 0.0f;
    }
    
    _expression = expression;
    _context = [XXXContext new];
    
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
            XXXSubOperatorExpression * add = [XXXSubOperatorExpression new];
            [add left:left right:right];
            [stack push:add];
        }
        else if ([operator isEqualToString:@"*"]) {
            XXXMulOperatorExpression * add = [XXXMulOperatorExpression new];
            [add left:left right:right];
            [stack push:add];
        }
        else if ([operator isEqualToString:@"/"]) {
            XXXDivOperatorExpression * add = [XXXDivOperatorExpression new];
            [add left:left right:right];
            [stack push:add];
        }
    }
//    [stack clear];
    return [[stack pop] interpretInContext:_context];
}
@end

