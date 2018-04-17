//
//  HSTitleCellModel.m
//  HSSetTableViewCtrollerDemo
//
//  Created by hushaohui on 2017/6/9.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSTitleCellModel.h"
#import "HSSetTableViewControllerConst.h"

@implementation HSTitleCellModel

+ (void)initialize{
    NSLog(@"+initialize HSTitleCellModel");
}

- (instancetype)initWithTitle:(NSString *)title actionBlock:(ClickActionBlock)block;
{
    if(self = [super init]){
        self.cellHeight = HS_KCellHeight;
        self.title = title;
        self.showArrow = YES;
        self.actionBlock = [block copy];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.separatorInset = UIEdgeInsetsMake(0, HS_KCellMargin, 0, HS_KCellMargin);
        self.separateColor = HS_KSeparateColor;
        self.separateHeight = HS_KSeparateHeight;
        self.titleFont = HS_KTitleFont;
        self.titleColor = HS_KTitleColor;
        self.arrowImage = [UIImage imageNamed:@"cell_arrow_right"];
        self.arrowWidth = HS_KArrowWidth;
        self.arrowHeight = HS_kArrowHeight;
        self.controlRightOffset = HS_KCellMargin;
        self.arrowControlRightOffset = HS_KCellMargin/2;
        self.titileTextAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (instancetype)initWithAttributeTitle:(NSAttributedString *)attributeTitle actionBlock:(ClickActionBlock)block
{
    if(self = [super init]){
        self.cellHeight = HS_KCellHeight;
        self.attributeTitle = attributeTitle;
        self.showArrow = YES;
        self.actionBlock = [block copy];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.separatorInset = UIEdgeInsetsMake(0, HS_KCellMargin, 0, HS_KCellMargin);
        self.separateColor = HS_KSeparateColor;
        self.separateHeight = HS_KSeparateHeight;
        self.titleFont = HS_KTitleFont;
        self.titleColor = HS_KTitleColor;
        self.arrowImage = [UIImage imageNamed:@"cell_arrow_right"];
        self.arrowWidth = HS_KArrowWidth;
        self.arrowHeight = HS_kArrowHeight;
        self.controlRightOffset = HS_KCellMargin;
        self.arrowControlRightOffset = HS_KCellMargin/2;
        self.titileTextAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (NSString *)cellClass
{
    return HSTitleCellModelCellClass;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.title];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, self.description];
}
@end
