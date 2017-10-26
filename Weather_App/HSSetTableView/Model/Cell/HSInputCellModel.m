//
//  HSInputCellModel.m
//  PointChat
//
//  Created by Rocky Young on 2017/10/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HSInputCellModel.h"
#import "HSSetTableViewControllerConst.h"

@implementation HSInputCellModel

- (instancetype)initWithInputText:(NSString *)inputText doneInput:(bInputBlock)block{
    
    return [self initWithTitle:nil inputText:inputText doneInput:block];
}

- (instancetype)initWithTitle:(NSString *)title inputText:(NSString *)inputText doneInput:(bInputBlock)block{
    
    if(self = [super initWithTitle:title actionBlock:nil]){
        self.showArrow = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.inputTextFont = [UIFont systemFontOfSize:15.0];
        self.inputTextColor = [UIColor blackColor];
        self.inputText = inputText;
        self.keyboardType = UIKeyboardTypeDefault;
        self.doneBlock = [block copy];
    }
    return self;
}

- (NSString *)cellClass
{
    return HSInputCellModelCellClass;
}
@end

@implementation HSInputTextCellModel

- (instancetype)initWithTitle:(NSString *)title inputText:(NSString *)inputText doneInput:(bInputBlock)block{
    
    if(self = [super initWithTitle:title inputText:inputText doneInput:block]){
        self.cellHeight = 80;
        self.inputTextCornerRadius = 5;
        self.haveBorder = NO;
        self.inputTextBorderColor = [UIColor colorWithHexString:@"#8F8E94"];
        self.placeholderColor = [UIColor lightGrayColor];
    }
    return self;
}

- (NSString *)cellClass
{
    return HSInputTextCellModelCellClass;
}

@end
