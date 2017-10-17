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

@interface TableDemoViewController ()

@end

@implementation TableDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Demo";
    
    [self.tableViewModel addSection:({
        
        HSSectionModel * s = [[HSSectionModel alloc] init];
        s.heightForHeader = 0;
        
        HSTitleCellModel * c = [[HSTitleCellModel alloc] initWithTitle:@"Title - 月-日-时间" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
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
            MMPickerViewConfig * config = [[MMPickerViewConfig alloc] init];
            config.columns = 2;
            [config configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
                return cloumn == 0 ? citys : co;
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
            MMPickerViewConfig * config = [[MMPickerViewConfig alloc] init];
            config.columns = 2;
            [config configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
                return cloumn == 0 ? citys : co;
            }];
            MMPickerView * pickerView = [[MMPickerView alloc] initWithConfig:config];
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
            MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
            dateConfig.datePickerMode = UIDatePickerModeDate;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        [s addCellModel:c];
        
        c = [[HSTextCellModel alloc] initWithTitle:@"Text - 时间" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
            dateConfig.datePickerMode = UIDatePickerModeTime;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        ((HSTextCellModel *)c).detailText = @"detail";
        ((HSTextCellModel *)c).detailColor = [UIColor lightGrayColor];
        [s addCellModel:c];
        
        c = [[HSSwitchCellModel alloc] initWithTitle:@"Switch" switchType:NO switchBlock:^(HSBaseCellModel *model, BOOL on) {
            NSLog(@"model:%@",model);
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
        [s addCellModel:c];
        
        s;
    })];
}

@end
