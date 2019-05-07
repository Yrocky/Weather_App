//
//  MMUnaryOpAST.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMUnaryOpAST.h"
#import "MMToken.h"

@interface MMUnaryOpAST ()
@property (nonatomic ,strong ,readwrite) MMToken * op;///<运算符
@property (nonatomic ,strong ,readwrite) MMAST * expr;///<表达式
@end

@implementation MMUnaryOpAST

+ (instancetype) unaryOpAST:(MMToken *)op expr:(MMAST *)expr{

    MMUnaryOpAST * ast = [MMUnaryOpAST new];
    ast.op = op;
    ast.expr = expr;
    return ast;
}

#pragma mark - override

- (CGFloat)visit{
    if (self.op.type == MMTokenPlus) {
        return self.expr.visit;
    }
    return 0 - self.expr.visit;
}

- (NSString *)toLispStyle{
    return [NSString stringWithFormat:@"(%@ %@)",self.op.value,self.expr.toLispStyle];
}

- (NSString *)toBackStyle{
    return [NSString stringWithFormat:@"%@%@",self.expr.toBackStyle,self.op.value];
}

- (NSString *)toString{
    return [NSString stringWithFormat:@"%@%@",self.op.value,self.expr.toString];
}
@end
