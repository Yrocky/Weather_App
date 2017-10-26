//
//  MMPickerViewController.h
//  Weather_App
//
//  Created by user1 on 2017/10/20.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPickerView.h"

@interface MMPickerViewController : UIViewController

@property (nonatomic ,strong ,readonly) __kindof MMPickerViewConfig *  _Nullable config;

@property (nonatomic ,copy) void (^ _Nullable bCancelAction)(MMPickerViewController *_Nullable);
@property (nonatomic ,copy) void (^ _Nonnull bDoneAction)(MMPickerViewController *_Nullable);

- (instancetype _Nullable ) initWithConfig:(MMPickerViewConfig *_Nonnull)config;
- (instancetype _Nullable ) initWithDatePickerConfig:(MMDatePickerViewConfig *_Nullable)config;

- (void) setupInterface:(MMPickerViewInterface *_Nonnull)interface;

- (void) update;
- (void) updateColumn:(NSUInteger)column;

- (void) showIn:(UIView *_Nonnull)view;
- (void) show;

- (void) dismiss;
- (void) dismiss:(void (^ __nullable)(void))completion;
@end
