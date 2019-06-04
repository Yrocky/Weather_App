//
//  TableDemoViewController.m
//  Weather_App
//
//  Created by user1 on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "TableDemoViewController.h"
#import "HSTitleCellModel.h"
#import "HSTextCellModel.h"
#import "HSImageCellModel.h"
#import "HSSwitchCellModel.h"
#import "HSInputCellModel.h"
#import "MMAssetsCellModel.h"
#import "MMPickerView.h"
#import "HLLAlert.h"

@interface TableDemoViewController ()

@end

@implementation TableDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Demo";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_mm_custom" object:nil];
    });
    
    UILabel * label = [UILabel new];
    label.text = @"Cancel";
    label.textColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
//    self.navigationItem.rightBarButtonItem = nil;
//
//    if (self.navigationItem.rightBarButtonItem != nil) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }

    UIView * customView =self.navigationItem.rightBarButtonItem.customView;
    customView.hidden = YES;
    
    
    
    
    if(0){
        MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
        dateConfig.datePickerMode = UIDatePickerModeCountDownTimer;
        //    dateConfig.countDownDuration = 66;
        MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
        pickerView.bDoneAction = ^(MMPickerView * _Nullable _pickerView) {
            MMDatePickerViewConfig * _dateConfig = _pickerView.config;
            NSLog(@"date:%@",_dateConfig.date);
        };
        [pickerView setupInterface:[MMPickerViewInterface interface]];
        [pickerView show];
    }
    {
        MMPickerView * pickerView = [MMPickerView pickerViewWithDatePickerConfig:^(MMDatePickerViewConfig * _Nonnull config) {
            config.datePickerMode = UIDatePickerModeCountDownTimer;
            config.countDownDuration = 60*3;//60s*3 = 3分钟
        }];
        pickerView.bDoneAction = ^(MMPickerView * _Nullable _pickerView) {
            MMDatePickerViewConfig * _dateConfig = _pickerView.config;
            NSLog(@"date:%@",_dateConfig.date);
        };
        [pickerView setupInterface:[MMPickerViewInterface interface]];
        [pickerView show];
    }
    
    [self.tableViewModel addSection:({
        
        HSSectionModel * s = [[HSSectionModel alloc] init];
        s.heightForHeader = 0;
        
        __weak typeof(self) weakSelf = self;
        
        HSTitleCellModel * c = [[HSTitleCellModel alloc] initWithTitle:@"Title - 月-日-时间" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [MMDatePickerViewConfig config];
            dateConfig.datePickerMode = UIDatePickerModeDateAndTime;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        [s addCellModel:c];
        
        NSArray * citys = @[@"sh",@"bj"];
        __block NSArray * co ;
        NSArray * sh = @[@"hk",@"pd",@"bs",@"xh"];
        NSArray * bj = @[@"dc",@"xc",@"cy"];
        co = sh;
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Title - 联动" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMPickerViewConfig * config = [MMPickerViewConfig config];
            config.columns = 2;
            [config configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
                return cloumn == 0 ? citys : co;
            }];
            // 默认选中bj-cy
            [config defaultSelect:^NSUInteger(NSUInteger column) {
                if (column == 0){
                    return 1;
                }
                else if(column == 1){
                    return 2;
                }
                return 0;
            }];
            [config monitorSelect:^(NSUInteger column, NSUInteger row, id  _Nullable data) {
                if (column == 0) {
                    if (row == 0) {
                        co  = sh;
                    }else{
                        co = bj;
                    }
                    [config.pickerView updateColumn:1];
                }
            }];
            MMPickerView * pickerView = [[MMPickerView alloc] initWithConfig:config];
            [pickerView show];
        }];
        c.showArrow = NO;
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Title - 固定" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            
            MMPickerViewInterface * interface = [MMPickerViewInterface interface];
            interface.bgColor = [UIColor whiteColor];
            
            MMPickerViewConfig * config = [MMPickerViewConfig config];
            config.columns = 2;
            [config configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
                return cloumn == 0 ? citys : co;
            }];
            MMPickerView * pickerView = [[MMPickerView alloc] initWithConfig:config];
            [pickerView setupInterface:interface];
            
            [pickerView show];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Title - 倒计时" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
            dateConfig.datePickerMode = UIDatePickerModeCountDownTimer;
            dateConfig.countDownDuration = 66;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        c.showArrow = NO;
        [s addCellModel:c];
        
        c = [[HSTextCellModel alloc] initWithTitle:@"Text - 月-日" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [MMDatePickerViewConfig config];
            dateConfig.datePickerMode = UIDatePickerModeDate;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        [s addCellModel:c];
        
        c = [[HSTextCellModel alloc] initWithTitle:@"Text - 时间" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
//            MMDatePickerViewConfig * dateConfig = [MMDatePickerViewConfig config];
//            dateConfig.datePickerMode = UIDatePickerModeTime;
//            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
//            [pickerView show];
            
            [[[[HLLAlertUtil message:@"msg"] addButton:^(NSInteger index) {
                NSLog(@"index:%d",index);
            } title:@"default" style:UIAlertActionStyleDefault] addButton:^(NSInteger index) {
                NSLog(@"index:%d",index);
            } title:@"cancel" style:UIAlertActionStyleDefault] showIn:self];
            
        }];
        ((HSTextCellModel *)c).detailText = @"detail";
        ((HSTextCellModel *)c).detailColor = [UIColor lightGrayColor];
        [s addCellModel:c];
        
        c = [[HSSwitchCellModel alloc] initWithTitle:@"Switch" switchType:NO switchBlock:^(HSBaseCellModel *model, BOOL on) {
            NSLog(@"model:%@",model);
            id<HLLAlertActionSheetProtocol> alert = [[HLLAlertUtil message:@"show some msg for u"]showIn:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismiss:^{
                    NSLog(@"延时alert已经消失");
                }];
            });
        }];
        [s addCellModel:c];
        
        c = [[HSInputCellModel alloc] initWithTitle:@"TextField" inputText:@"text" doneInput:^(HSBaseCellModel *model, NSString *text) {
            NSLog(@"model:%@",model);
        }];
        ((HSInputCellModel *)c).placeholder = @"placeholder";
        [s addCellModel:c];
        
        c = [[HSInputTextCellModel alloc] initWithTitle:@"TextView" inputText:@"text" doneInput:^(HSBaseCellModel *model, NSString *text) {
            NSLog(@"model:%@",model);
        }];
        ((HSInputTextCellModel *)c).placeholder = @"placeholder - text view";
        ((HSInputTextCellModel *)c).placeholderColor = [UIColor redColor];

        [s addCellModel:c];
        
        s;
    })];
    
    [self dateList];
}

- (void) dateList{
    
    NSDate * min = [NSDate dateWithTimeIntervalSinceNow:- 60 * 60 * 24 * 2];// 2天前
    NSDate * max = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];// 1天后
    
    NSMutableArray * dates = [NSMutableArray array];
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger dayCount = 0;
    
    do {
        dateComponents.day = dayCount;
        dayCount ++;
        NSDate * date = [calendar dateByAddingComponents:dateComponents toDate:min options:NSCalendarMatchStrictly];
        if ([date compare:max] == NSOrderedDescending) {
            break;
        }
        [dates addObject:date];
    } while (true);
    
}
@end
