//
//  InterpreterViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/28.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "InterpreterViewController.h"
#import "XXXCalculator.h"

@interface InterpreterViewController ()

@end

@implementation InterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBaseExpression];
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

@end



