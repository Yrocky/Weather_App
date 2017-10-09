//
//  NSString+Exten.m
//  memezhibo
//
//  Created by Raymone on 2017/1/18.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import "NSString+Exten.h"

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

@end
