//
//  UILabel+ContentSize.m
//  Weather_App
//
//  Created by user1 on 2017/10/19.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)

- (CGSize)contentSize
{
    return [self textSizeIn:self.bounds.size];
}

- (CGSize)textSizeIn:(CGSize)size
{
    NSLineBreakMode breakMode = self.lineBreakMode;
    UIFont *font = self.font;
    
    CGSize contentSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    
    
    contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
    return contentSize;
}

@end
