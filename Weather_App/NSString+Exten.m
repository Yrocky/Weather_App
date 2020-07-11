//
//  NSString+Exten.m
//  memezhibo
//
//  Created by Raymone on 2017/1/18.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import "NSString+Exten.h"
#import "HLLAttributedBuilder.h"
#import "NSArray+Sugar.h"

@implementation NSString (Exten)

- (NSInteger)countEnglishWords{
    NSInteger count = 0;
    for(int i = 0; i < self.length ; i++){
        unichar c = [self characterAtIndex:i];
        if ((c >= 0x41 && c <= 0x5A)||(c >= 0x61 && c<= 0x7A)) {
            count ++;
        }
    }
    
    return count;
}

- (NSInteger)countNumber{
    NSInteger count = 0;
    for(int i = 0; i < self.length ; i++){
        unichar c = [self characterAtIndex:i];
        if (c >= 0x30 && c <= 0x39) {
            count ++;
        }
    }
    return count;
}

- (NSInteger)countChinsesCharacters{
    NSInteger count = 0;
    for(int i = 0; i < self.length ; i++){
        unichar c = [self characterAtIndex:i];
        if (c >= 0xE00 && c <= 0x9FA5) {
            count ++;
        }
    }
    return count;
}

- (NSInteger)countOtherChar{
    
    NSInteger count = 0;
    for(int i = 0; i < self.length ; i++){
        unichar c = [self characterAtIndex:i];
        if ((c >= 0x00 && c <= 0x2F) || (c >= 0x3A && c<= 0x40) || (c >= 0x5B && c<= 0x60) || (c >= 0x7B && c<= 0x7F)) {
            count ++;
        }
    }
    
    return count;
}

- (CGFloat)hs_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width{

    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

- (NSArray<NSString *> *) separatedByStrings:(NSArray<NSString *> *)strings contained:(BOOL)contained{
    
    if (nil == strings) {
        return nil;
    }
    NSString * joinStrings = [strings componentsJoinedByString:@""];
    NSString * pattern = [NSString stringWithFormat:@"[%@]",joinStrings];
    NSArray <NSTextCheckingResult *>* matched = [RX(pattern) matches:self];
    
    if (matched.count) {

        NSMutableArray<NSString *> *separatedStrings = [NSMutableArray array];
        
        for (NSUInteger index = 0; index < matched.count + 1; index ++) {
            
            NSTextCheckingResult * matchResult = index == matched.count ? nil : matched[index];
            NSString * separatedString = nil;
            
            if (index) {
                NSRange preRange = matched[index - 1].range;
                if (index == matched.count) {
                    NSUInteger location = NSMaxRange(preRange);
                    NSUInteger length = self.length - location;
                    NSRange range = NSMakeRange(location, length);
                    separatedString = [self substringWithRange:range];
                } else {
                    NSUInteger location = NSMaxRange(preRange);
                    NSUInteger length = NSMaxRange(matchResult.range) - location;
                    length = contained ? length : length - 1;
                    NSRange range = NSMakeRange(location,length);
                    separatedString = [self substringWithRange:range];
                }
            } else {// 第一个
                NSUInteger toIndex = NSMaxRange(matchResult.range);
                toIndex = contained ? toIndex : toIndex - 1;
                separatedString = [self substringToIndex:toIndex];
            }
            if (separatedString && separatedString.length) {
                [separatedStrings addObject:separatedString];
            }
        }
        return separatedStrings;
    }
    return @[self.copy];
}

- (CGSize)YYY_sizeWithFont:(UIFont*)font maxSize:(CGSize)maxSize{
    if(self && [self isKindOfClass:[NSString class]] && self.length){
        CGSize size = [self boundingRectWithSize: maxSize
                                         options: NSStringDrawingUsesLineFragmentOrigin
                                      attributes: @{ NSFontAttributeName: font }
                                         context: nil].size;
        return size;
    }
    return CGSizeMake(0, 0);
}

@end
