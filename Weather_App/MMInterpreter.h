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

@interface MMInterpreter : NSObject

+ (instancetype) interpreter:(MMLexer *)lexer;
+ (instancetype) interpreterWith:(NSString *)text;

- (NSInteger) expr;
@end

NS_ASSUME_NONNULL_END
