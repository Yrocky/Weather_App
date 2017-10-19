//
//  HSInputCellModel.h
//  PointChat
//
//  Created by Rocky Young on 2017/10/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HSTitleCellModel.h"

typedef void(^bInputBlock)(HSBaseCellModel *model,NSString * text);

@interface HSInputCellModel : HSTitleCellModel

@property (nonatomic ,copy) NSString * placeholder;
@property (nonatomic ,copy) NSString * inputText;

@property (nonatomic, strong) UIColor *inputTextColor;  ///<输入框文本color
@property (nonatomic, strong) UIFont *inputTextFont;  ///<输入框文本Font

@property (nonatomic ,assign) UIKeyboardType keyboardType;

@property (nonatomic, copy)bInputBlock doneBlock;  ///< block调用

- (instancetype)initWithTitle:(NSString *)title inputText:(NSString *)inputText doneInput:(bInputBlock)block;

- (instancetype)initWithInputText:(NSString *)inputText doneInput:(bInputBlock)block;
@end

@interface HSInputTextCellModel : HSInputCellModel

@property (nonatomic, strong) UIColor *placeholderColor;  ///<占位文字的颜色

@property (nonatomic ,assign) BOOL haveBorder;///< 文本框是否需要边框
@property (nonatomic ,assign) CGFloat inputTextCornerRadius;///< 文本框的圆角度数
@property (nonatomic, strong) UIColor *inputTextBorderColor;  ///<文本框边框颜色
@end
