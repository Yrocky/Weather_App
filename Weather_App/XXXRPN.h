//
//  XXXRPN.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/7.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 使用逆波兰表达式来解决 算数四则运算
@interface XXXRPN : NSObject

+ (instancetype) rpnWithExpression:(NSString *)expression;

- (CGFloat) result;
- (NSString *)rpnString;
@end

NS_ASSUME_NONNULL_END
