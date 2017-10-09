//
//  NSString+Exten.h
//  memezhibo
//
//  Created by Raymone on 2017/1/18.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Exten)


/**
 返回字符串中字母的个数
 */
- (NSInteger)countEnglishWords;

/**
 返回字符串中数字的个数
 */
- (NSInteger)countNumber;

/**
 返回字符串中汉子的个数
 */
- (NSInteger)countChinsesCharacters;

/**
 返回字符串中其他字符的个数
 */
- (NSInteger)countOtherChar;

- (CGFloat)hs_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
@end
