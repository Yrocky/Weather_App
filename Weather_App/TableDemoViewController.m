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
        
        HSTitleCellModel * c = [[HSTitleCellModel alloc] initWithTitle:@"Title" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMDatePickerViewConfig * dateConfig = [[MMDatePickerViewConfig alloc] init];
            dateConfig.datePickerMode = UIDatePickerModeDateAndTime;
            MMPickerView * pickerView = [[MMPickerView alloc] initWithDatePickerConfig:dateConfig];
            [pickerView show];
        }];
        [s addCellModel:c];
        c = [[HSTitleCellModel alloc] initWithTitle:@"Title - again" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
            MMPickerViewConfig * dateConfig = [[MMPickerViewConfig alloc] init];
            dateConfig.columns = 2;
            [dateConfig configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
                return @[@"1",@"2",@"3",@"4"];
            }];
            MMPickerView * pickerView = [[MMPickerView alloc] initWithConfig:dateConfig];
            [pickerView show];
        }];
        c.showArrow = NO;
        [s addCellModel:c];
        
        c = [[HSTextCellModel alloc] initWithTitle:@"Text" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
        }];
        [s addCellModel:c];
        
        c = [[HSTextCellModel alloc] initWithTitle:@"Text - again" actionBlock:^(HSBaseCellModel *model) {
            NSLog(@"model:%@",model);
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
