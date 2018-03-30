//
//  MMLabel.m
//  Weather_App
//
//  Created by user1 on 2017/11/16.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMLabel.h"

@implementation MMLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layoutMargins = UIEdgeInsetsMake(10, 20, 10, 20);
    }
    return self;
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    [self sizeToFit];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}
@end
