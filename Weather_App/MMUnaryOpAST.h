//
//  MMUnaryOpAST.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMAST.h"

NS_ASSUME_NONNULL_BEGIN

@class MMToken;
@interface MMUnaryOpAST : MMAST

@property (nonatomic ,strong ,readonly) MMToken * op;///<运算符
@property (nonatomic ,strong ,readonly) MMAST * expr;///<表达式

+ (instancetype) unaryOpAST:(MMToken *)op expr:(MMAST *)expr;
@end

NS_ASSUME_NONNULL_END
