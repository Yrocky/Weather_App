//
//  MMPickerView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMPickerViewConfig : NSObject

@property (nonatomic ,assign) NSUInteger columns;

// 默认选中 - todo
- (void) defaultSelect:(NSUInteger (^)(NSUInteger column))callback;

// 装有字符串的数组
- (void) configRowAt:(NSArray <NSString *>*(^)(NSUInteger cloumn))callBack;

// 装有对象的数组，可以根据callBack2进行对应的属性获取
- (void) configRowAt:(NSArray <id>*(^)(NSUInteger cloumn))callback displayText:(NSString *(^)(id data,NSUInteger column))callback2;

// pickerView选中的事件回调
- (void) monitorSelect:(void(^)(NSUInteger column,NSUInteger row,id data))callback;
@end

@interface MMPickerView : UIView

@property (nonatomic ,strong ,readonly) MMPickerViewConfig * config;

@property (nonatomic ,copy) void (^bCancelAction)(MMPickerView *);
@property (nonatomic ,copy) void (^bDoneAction)(MMPickerView *);

- (instancetype) initWithConfig:(MMPickerViewConfig *)config;

- (void) show;
- (void) dismiss;
@end
