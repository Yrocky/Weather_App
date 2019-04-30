//
//  MMParserr.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSyntaxDiagramAble.h"

NS_ASSUME_NONNULL_BEGIN

@class MMAST;
@class MMLexer;
@interface MMParserr<T> : NSObject<MMSyntaxDiagramAble>

@property (nonatomic ,strong, readonly) MMLexer * lexer;

+ (instancetype) parser:(MMLexer *)lexer;

- (MMAST *) parse;
@end

NS_ASSUME_NONNULL_END
