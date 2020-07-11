//
//  XXXExpression.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXExpression.h"
#import "XXXContext.h"

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

