//
//  MMInterpreter.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLexer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MMParseExpressionResult) {
    MMParseExpressionValid,// 有效的
    MMParseExpressionInvalid,
};

@interface MMInterpreter : NSObject

+ (instancetype) interpreter:(MMLexer *)lexer;
+ (instancetype) interpreterWith:(NSString *)text;

- (MMParseExpressionResult) parseResult;
- (double) expr;
@end

NS_ASSUME_NONNULL_END
