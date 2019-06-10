//
//  XXXLoginInputView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXLoginInputView : UIView{
    UITextField *_textField;
}

@property (nonatomic ,copy ,readonly) NSString * text;

- (instancetype) initWithPlaceholder:(NSString *)placeholder;

- (void) setupKeybordType:(UIKeyboardType)type;
@end

NS_ASSUME_NONNULL_END
