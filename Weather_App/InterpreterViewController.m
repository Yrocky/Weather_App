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

@interface InterpreterViewController ()

@end

@implementation InterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBaseExpression];
    [self testMMInterpreter];
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



