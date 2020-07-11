//
//  MMNumAST.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMNumAST.h"
#import "MMToken.h"

@interface MMNumAST ()
@property (nonatomic ,strong ,readwrite) MMToken * num;
@end

@implementation MMNumAST

+ (instancetype) numAST:(MMToken *)num{
    
    MMNumAST * ast = [MMNumAST new];
    ast.num = num;
    return ast;
}

#pragma mark - override
- (CGFloat)visit{
    return self.num.value.floatValue;
}

- (NSString *)toString{
    return self.num.value;
}

- (NSString *)toLispStyle{
    return self.toString;
}

- (NSString *)toBackStyle{
    return self.toString;
}
@end
