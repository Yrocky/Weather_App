//
//  InterpreterViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/28.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "InterpreterViewController.h"
#import "XXXCalculator.h"
#import "MMInterpreter.h"
#import "MMParserr.h"
#import "MMVertex.h"

@interface InterpreterViewController ()

@property (nonatomic ,strong) MMVertex<NSString *> * node;
@property (nonatomic ,copy) NSArray<NSValue *> * nodes;

@property (nonatomic ,strong) MMVertex<NSString *> * node2;
@property (nonatomic ,copy) NSArray<MMVertex *> * node2s;
@end

@implementation InterpreterViewController

- (void)dealloc{
    NSLog(@"InterpreterViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBaseExpression];
    [self testMMInterpreter];
    
    [self weakValue];
}

- (void) weakValue{
    
    self.node = [MMVertex vertex:@"aaa"];
    NSValue * value = [NSValue valueWithNonretainedObject:self.node];
    self.node = @[value];
    
    self.node2 = [MMVertex vertex:@"bbbb"];
    self.node2s = @[self.node2];
}

- (void) testBaseExpression{
    
    XXXCalculator * calculator = [XXXCalculator new];
    {
        [calculator calculatorWith:@"8+3-6*4/2"];
    }
    {
        [calculator calculatorWith:@"2*3/6"];
    }
    {
        [calculator calculatorWith:@"2+3*6"];
    }
}

- (void) testMMInterpreter{
    {
        MMLexer * lexer = [MMLexer lexer:@"8+(3-6)*4/2"];
        MMParserr * parser = [MMParserr parser:lexer];
        MMAST * ast = [parser parse];
        NSLog(@"[MMAST] %@",ast);
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
    {
        MMLexer * lexer = [MMLexer lexer:@"8+(3+-6)+4/2"];
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
    {
        MMLexer * lexer = [MMLexer lexer:@"8*(3-6)-4+2"];
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
    {
        MMLexer * lexer = [MMLexer lexer:@"(8+(3-6)*4)/2"];
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
    {
        MMLexer * lexer = [MMLexer lexer:@"8*(3+6)/4+2"];
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
    {
        MMLexer * lexer = [MMLexer lexer:@"((8-4)*2+(3-6)*5)*4/2"];
        MMInterpreter * interpreter = [MMInterpreter interpreter:lexer];
        NSLog(@"[Interpreter] exp:%@ result:%ld",lexer.text,(long)[interpreter expr]);
    }
}
@end



