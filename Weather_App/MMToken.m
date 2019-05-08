//
//  MMToken.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMToken.h"

@interface MMToken ()
@property (nonatomic ,assign ,readwrite) MMTokenType type;
@property (nonatomic ,copy ,readwrite) NSString * value;
@end

@implementation MMToken

+ (instancetype) floatToken:(NSString *)value{
    return [self token:MMTokenFloat value:value];
}

+ (instancetype) plusToken{
    return [self token:MMTokenPlus value:MM_opString(MMTokenPlus)];
}

+ (instancetype) minusToken{
    return [self token:MMTokenMinus value:MM_opString(MMTokenMinus)];
}

+ (instancetype) mulToken{
    return [self token:MMTokenMul value:MM_opString(MMTokenMul)];
}

+ (instancetype) divToken{
    return [self token:MMTokenDiv value:MM_opString(MMTokenDiv)];
}

+ (instancetype) lParenToken{
    return [self token:MMTokenLParen value:MM_opString(MMTokenLParen)];
}

+ (instancetype) rParenToken{
    return [self token:MMTokenRParen value:MM_opString(MMTokenRParen)];
}

+ (instancetype) eofToken{
    return [self token:MMTokenEOF value:@"EOF"];
}

+ (instancetype) token:(MMTokenType)type value:(NSString *)value{
    
    MMToken * token = [MMToken new];
    token.type = type;
    token.value = value;
    return token;
}

- (MMOperatorPriority) operatorPriorityWith:(MMToken *)otherToken{

    if (self.type <= 0 || otherToken.type <= 0) {
        return MMOperatorPriorityDefault;
    }
    if (self.type == otherToken.type + 1 ||
        self.type == otherToken.type - 1 ||
        self.type == otherToken.type) {
        return MMOperatorPriorityEqual;
    } else if (self.type < otherToken.type) {
        return MMOperatorPriorityLow;
    } else if (self.type > otherToken.type) {
        return MMOperatorPriorityHigh;
    }
    return MMOperatorPriorityDefault;
}

- (NSString *) toString{
    return [NSString stringWithFormat:@"MMToken(%@ , %@)",MM_opString(self.type),self.value];
}

- (NSString *)description{
    return [self toString];
}

@end

inline BOOL MM_isOps(NSString * str) {
    return [ops containsString:str];
}

inline NSString * MM_opString(MMTokenType type) {
    
    if (type == MMTokenFloat) {
        return @"float";
    } else if (type == MMTokenPlus) {
        return @"+";
    } else if (type == MMTokenMinus) {
        return @"-";
    } else if (type == MMTokenMul) {
        return @"*";
    } else if (type == MMTokenDiv) {
        return @"/";
    } else if (type == MMTokenLParen) {
        return @"(";
    } else if (type == MMTokenRParen) {
        return @")";
    } else if (type == MMTokenEOF) {
        return @"EOF";
    }

    return @"";
}

inline BOOL MM_isInterger(NSString * str){
    
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}
