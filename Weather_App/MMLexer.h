//
//  MMLexer.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MMToken;
// Lexical analyzer:词法分析类，将文本进行处理，处理结果使用token流来表示，这一部分具备通用性
@interface MMLexer : NSObject

@property (nonatomic ,copy ,readonly) NSString * text;

+ (instancetype) lexer:(NSString *)text;
- (NSString *) intergerString;
- (NSString *) floatString;
- (MMToken *) nextToken;
@end

NS_ASSUME_NONNULL_END
