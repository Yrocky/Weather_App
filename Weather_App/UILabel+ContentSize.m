//
//  UILabel+ContentSize.m
//  CategoryDemo
//
//  Created by Rocky Young on 16/8/9.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)

+ (void)load{
//    NSLog(@"+load UILabel(ContentSize)");
}

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
