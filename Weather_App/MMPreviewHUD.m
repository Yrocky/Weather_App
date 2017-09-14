//
//  MMPreviewHUD.m
//  Weather_App
//
//  Created by Rocky Young on 2017/9/14.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMPreviewHUD.h"
#import "HLLAttributedBuilder.h"

static CGFloat kMaxPreviewWidth = 200;

@interface MMPreviewLabel : UILabel<NSCopying>

+ (instancetype)label;

- (CGSize) configAttributedString:(NSAttributedString *)attString;
- (CGSize) configText:(NSString *)text;
@end

@implementation MMPreviewLabel

+ (instancetype)label {
    
    MMPreviewLabel *label = [[MMPreviewLabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (CGSize) configAttributedString:(NSAttributedString *)attString{
    
    [self setAttributedText:attString];
    CGSize size = [attString size];
    return size;
}
- (CGSize) configText:(NSString *)text{
    
    [self setText:text];
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.font.pointSize)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.font} context:nil].size;
    return size;
}

@end

@implementation MMPreviewHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

+ (instancetype) previewHUD{

    return [[self alloc] init];
}

- (void) configWithText:(NSString *)text{

    MMPreviewLabel * l = [MMPreviewLabel label];
    NSAttributedString * att = [HLLAttributedBuilder builderWithString:text].attributedStr();
    
    CGSize s = [l configAttributedString:att];
}

+ (void) showHUD:(NSString *)text inView:(UIView *)view target:(id)target action:(SEL)action{
    
    MMPreviewHUD * previewHUD = [MMPreviewHUD previewHUD];
    
    
}

@end
