//
//  HLLPlaceholderTextView.h
//  CategoryDemo
//
//  Created by Rocky Young on 16/8/9.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//
//
// 拥有占位文字的UITextView子类，支持代码以及xib创建
//

#import <UIKit/UIKit.h>

@interface UIPlaceholderTextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic, strong) IBInspectable NSString *placeholder;
/**
 *  占位文字的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end


@interface UILimitTextView : UIPlaceholderTextView
{
@protected
    UILabel         *_limitText;
}

@property (nonatomic, readonly) UILabel *limitText; // 设置limitLength>0后有效

@property (nonatomic, assign) NSInteger limitLength;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)updateLimitText;
@end

