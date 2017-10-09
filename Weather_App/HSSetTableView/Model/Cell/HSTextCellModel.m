//
//  HSTextRightModel.m
//  HSSetTableView
//
//  Created by hushaohui on 2017/4/19.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSTextCellModel.h"
#import "HSSetTableViewControllerConst.h"
#import <CoreText/CoreText.h>
#import "NSString+Exten.h"

@interface HSTextCellModel()
@property (nonatomic, assign) CGFloat heightOne;  ///<一行文本的高度
@property (nonatomic, assign) CGFloat heightMore;  ///<多行文本高度

@end
@implementation HSTextCellModel

- (instancetype)initWithTitle:(NSString *)title actionBlock:(ClickActionBlock)block{
    
    if (self = [super initWithTitle:title actionBlock:block]) {
        self.leftPading = HS_KCellTextLeftPading;
        self.detailFont = HS_KDetailFont;
        self.detailColor = HS_KDetailColor;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detailText:(NSString *)detailText actionBlock:(ClickActionBlock)block
{
    if(self = [super initWithTitle:title actionBlock:block]){
        self.leftPading = HS_KCellTextLeftPading;
        self.detailFont = HS_KDetailFont;
        self.detailColor = HS_KDetailColor;
        self.detailText = detailText;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title attributrDetailText:(NSAttributedString *)attributrDetailText actionBlock:(ClickActionBlock)block
{
    if(self = [super initWithTitle:title actionBlock:block]){
        self.leftPading = HS_KCellTextLeftPading;
        self.detailFont = HS_KDetailFont;
        self.detailColor = HS_KDetailColor;
        self.attributeDetailText = attributrDetailText;
    }
    return self;
}

- (instancetype)initWithAttributeTitle:(NSAttributedString *)attributeTitle detailAttributeText:(NSAttributedString *)attributeDetailText actionBlock:(ClickActionBlock)block
{
    if(self = [super initWithAttributeTitle:attributeTitle actionBlock:block]){
        self.leftPading = HS_KCellTextLeftPading;
        self.attributeDetailText = attributeDetailText;
    }
    return self;
}

- (instancetype)initWithAttributeTitle:(NSAttributedString *)attributeTitle detailText:(NSString *)detailText actionBlock:(ClickActionBlock)block

{
    if(self = [super initWithAttributeTitle:attributeTitle actionBlock:block]){
        self.leftPading = HS_KCellTextLeftPading;
        self.detailFont = HS_KDetailFont;
        self.detailColor = HS_KDetailColor;
        self.detailText = detailText;
    }
    return self;
}

- (NSString *)cellClass
{
    return HSTextCellModelCellClass;
}

- (void)setShowArrow:(BOOL)showArrow
{
    [super setShowArrow:showArrow];
    [self setDetailText:self.detailText];
}

- (void)setDetailFont:(UIFont *)detailFont
{
    _detailFont = detailFont;
    [self setDetailText:self.detailText];
}

- (void)setArrowControlRightOffset:(CGFloat)arrowControlRightOffset
{
    [super setArrowControlRightOffset:arrowControlRightOffset];
    [self setDetailText:self.detailText];
}

- (void)setControlRightOffset:(CGFloat)controlRightOffset
{
    [super setControlRightOffset:controlRightOffset];
    [self setDetailText:self.detailText];
}

- (void)setLeftPading:(CGFloat)leftPading
{
    _leftPading = leftPading;
    [self setDetailText:self.detailText];
}

- (void)setDetailText:(NSString *)detailText
{
    //如果detailText为nil 直接返回，为空不能返回
    if(detailText == nil){
        return;
    }
    _detailText = detailText;
    if(self.attributeDetailText) {
        //如果外部设置过富文本，则忽略纯文本计算
        return;
    }
    [self heightSizeWithTextObject:detailText];
   
}

- (void)setAttributeDetailText:(NSAttributedString *)attributeDetailText
{
    if(attributeDetailText == nil) {
        return;
    }
    _attributeDetailText = attributeDetailText;
    [self heightSizeWithTextObject:attributeDetailText];
    
}

- (void)heightSizeWithTextObject:(id)object
{
    //初始化文本高度  外部不可任意改变不然界面看起来很奇怪
    self.cellHeight = 0.0f;
    UIDeviceOrientation duration = [[UIDevice currentDevice]orientation];
    CGFloat screenWidth = 0;
    if(duration == UIDeviceOrientationLandscapeLeft || duration == UIDeviceOrientationLandscapeRight){
        screenWidth = HS_SCREEN_HEIGHT > HS_SCREEN_WIDTH ? HS_SCREEN_HEIGHT:HS_SCREEN_WIDTH;
    }else{
        screenWidth = HS_SCREEN_HEIGHT < HS_SCREEN_WIDTH ? HS_SCREEN_HEIGHT:HS_SCREEN_WIDTH;
    }
    CGFloat height = 0;
    UIFont *font;
    if([object isKindOfClass:[NSString class]]){
       height = [(NSString *)object hs_heightWithFont:self.detailFont constrainedToWidth:screenWidth - self.leftPading - (self.showArrow ?  self.controlRightOffset + self.arrowControlRightOffset + self.arrowWidth : self.controlRightOffset)];
        font = self.detailFont;
        
    }else{
        
    }
    
    if(height < font.pointSize + 5 || height == 0){
        //说明只有一行
        self.heightOne = height;
        self.heightMore = .0f;
        self.cellHeight = HS_KCellHeight;
    }else{
        self.heightOne = .0f;
        self.heightMore = height;
        //cell足够大
        self.cellHeight = height + 2 * HS_KCellPading;
    }
}


@end
