//
//  MMPickerView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPickerView;

#pragma mark - config

@interface MMPickerViewConfig<T> : NSObject

+ (instancetype _Nullable ) config;

@property (nonatomic ,weak) MMPickerView * _Nullable pickerView;

@property (nonatomic ,assign) NSUInteger columns;

// 默认选中
- (void) defaultSelect:(NSUInteger (^_Nullable)(NSUInteger column))callback;

// 装有字符串的数组
- (void) configRowAt:(NSArray <NSString *>*_Nullable(^_Nullable)(NSUInteger cloumn))callback;

// 装有对象的数组，可以根据callBack2进行对应的属性获取
- (void) configRowAt:(NSArray <T>*_Nullable(^_Nullable)(NSUInteger cloumn))callback
         displayText:(NSString *_Nullable(^_Nullable)(T _Nullable data,NSUInteger column))callback2;

// pickerView选中的事件回调
- (void) monitorSelect:(void(^_Nullable)(NSUInteger column,NSUInteger row,id _Nullable data))callback;
@end

@interface MMDatePickerViewConfig : MMPickerViewConfig

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDate * _Nullable date;
@property (nullable, nonatomic, strong) NSDate *minimumDate;
@property (nullable, nonatomic, strong) NSDate *maximumDate;
@property (nonatomic) NSTimeInterval countDownDuration;// 仅针对于 UIDatePickerModeCountDownTimer ，其他类型忽略
@end

#pragma mark - interface

@interface MMPickerViewInterface : NSObject

+ (instancetype _Nullable ) interface;

@property (nonatomic ,strong) UIColor * _Nullable bgColor;// default is clear

@property (nonatomic ,strong) NSString * _Nonnull title;// default is nil
@property (nonatomic ,strong) UIColor * _Nullable titleColor;// default is gray
@property (nonatomic ,strong) UIFont * _Nonnull titleFont;// default is 13

@property (nonatomic ,strong) NSString * _Nonnull cancelText;// default is "取消"
@property (nonatomic ,strong) UIColor * _Nullable cancelTextColor;// default is blueColor
@property (nonatomic ,strong) UIFont * _Nonnull cancelTextFont;// default is 15

@property (nonatomic ,strong) NSString * _Nonnull doneText;// default is "确定"
@property (nonatomic ,strong) UIColor * _Nullable doneTextColor;// default is blueColor
@property (nonatomic ,strong) UIFont * _Nonnull doneTextFont;// default is 15

@end

#pragma mark - PickerView

@interface MMPickerView : UIView

@property (nonatomic ,strong ,readonly) __kindof MMPickerViewConfig *  _Nullable config;

@property (nonatomic ,copy) void (^ _Nullable bCancelAction)(MMPickerView *_Nullable _pickerView);
@property (nonatomic ,copy) void (^ _Nonnull bDoneAction)(MMPickerView *_Nullable _pickerView);

- (instancetype _Nullable ) initWithConfig:(MMPickerViewConfig *_Nonnull)config;
- (instancetype _Nullable ) initWithDatePickerConfig:(MMDatePickerViewConfig *_Nullable)config;

+ (instancetype _Nullable ) pickerViewWithConfig:(void(^)(MMPickerViewConfig *_Nonnull config))configHandle;
+ (instancetype _Nullable ) pickerViewWithDatePickerConfig:(void(^)(MMDatePickerViewConfig *_Nonnull config))configHandle;

- (void) setupInterface:(MMPickerViewInterface *_Nonnull)interface;

- (void) update;
- (void) updateColumn:(NSUInteger)column;

- (void) show;

- (void) dismiss;
//- (void) dismiss:(void (^ __nullable)(void))completion;
@end
