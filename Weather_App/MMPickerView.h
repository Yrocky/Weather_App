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
- (void) defaultSelect:(NSUInteger (^_Nullable)(NSUInteger column))callback;

// 装有字符串的数组
- (void) configRowAt:(NSArray <NSString *>*_Nullable(^_Nullable)(NSUInteger cloumn))callBack;

// 装有对象的数组，可以根据callBack2进行对应的属性获取
- (void) configRowAt:(NSArray <id>*_Nullable(^_Nullable)(NSUInteger cloumn))callback displayText:(NSString *_Nullable(^_Nullable)(id _Nullable data,NSUInteger column))callback2;

// pickerView选中的事件回调
- (void) monitorSelect:(void(^_Nullable)(NSUInteger column,NSUInteger row,id _Nullable data))callback;
@end

@interface MMDatePickerViewConfig : MMPickerViewConfig

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nullable, nonatomic, strong) NSDate *minimumDate;
@property (nullable, nonatomic, strong) NSDate *maximumDate;
@end

@interface MMPickerView : UIView

@property (nonatomic ,strong ,readonly) MMPickerViewConfig *  _Nullable config;

@property (nonatomic ,copy) void (^ _Nullable bCancelAction)(MMPickerView *_Nullable);
@property (nonatomic ,copy) void (^ _Nonnull bDoneAction)(MMPickerView *_Nullable);

- (instancetype _Nullable ) initWithConfig:(MMPickerViewConfig *_Nonnull)config;

- (instancetype _Nullable ) initWithDatePickerConfig:(MMDatePickerViewConfig *_Nullable)config;

- (void) show;
- (void) dismiss;
@end
