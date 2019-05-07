//
//  MMBinAST.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMBinAST.h"
#import "MMToken.h"

@interface MMBinAST ()
@property (nonatomic ,strong ,readwrite) MMAST * left;
@property (nonatomic ,strong ,readwrite) MMToken * op;///<操作符
@property (nonatomic ,strong ,readwrite) MMAST * right;
@end

@implementation MMBinAST

+ (instancetype) binAST:(MMAST *)left op:(MMToken *)op right:(MMAST *)right{
    
    MMBinAST * ast = [MMBinAST new];
    ast.left = left;
    ast.op = op;
    ast.right = right;
    return ast;
}

#pragma mark - override
- (CGFloat)visit{
    
    MMTokenType tokenType = self.op.type;
    if (tokenType == MMTokenPlus) {
        return self.left.visit + self.right.visit;
    }
    else if (tokenType == MMTokenMinus) {
        return self.left.visit - self.right.visit;
    }
    else if (tokenType == MMTokenMul) {
        return self.left.visit * self.right.visit;
    }
    else if (tokenType == MMTokenDiv) {
        return self.left.visit / self.right.visit;
    }
    
    return 0.0;
}

- (NSString *)toLispStyle{
    return [NSString stringWithFormat:@"(%@ %@ %@ )",self.op.value,self.left.toLispStyle,self.right.toLispStyle];
}

- (NSString *)toBackStyle{
    return [NSString stringWithFormat:@"%@ %@ %@",self.left.toBackStyle,self.right.toBackStyle,self.op.value];
}

- (NSString *)toString{
    return [NSString stringWithFormat:@"%@ %@ %@",self.left.toString,self.op.value,self.right.toString];
}

@end
