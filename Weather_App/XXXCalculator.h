//
//  XXXCalculator.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXXContext;

NS_ASSUME_NONNULL_BEGIN

// 定义一个计算类，用于解释并实现解释文本的逻辑
@interface XXXCalculator : NSObject{
    NSString * _expression;
    XXXContext * _context;
}

- (float) calculatorWith:(NSString *)expression;
@end

NS_ASSUME_NONNULL_END
