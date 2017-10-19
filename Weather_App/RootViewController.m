//
//  RootViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "RootViewController.h"
#import "HSTitleCellModel.h"
#import "MM_AutoReplyViewController.h"
#import "MMGiftEffectViewController.h"
#import "TableDemoViewController.h"
#import "MMSearchViewController.h"
#import "ANYMethodLog.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Root";
    
    [ANYMethodLog logMethodWithClass:[HSTableViewModel class] condition:^BOOL(SEL sel) {
        
        return [NSStringFromSelector(sel) isEqualToString:@"addSection:"];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        NSLog(@" before target:%@ sel:%@",target,NSStringFromSelector(sel));
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        
    }];
    
    [self.tableViewModel addSection:({
        
        HSSectionModel * s = [[HSSectionModel alloc] init];
        s.heightForHeader = 0;
        
        HSTitleCellModel * c = [[HSTitleCellModel alloc] initWithTitle:@"原来的Main控制器" actionBlock:^(HSBaseCellModel *model) {
            
            [self performSegueWithIdentifier:@"RootToMain" sender:nil];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"礼物效果" actionBlock:^(HSBaseCellModel *model) {
            
            MMGiftEffectViewController * vc = [[MMGiftEffectViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"自动回复" actionBlock:^(HSBaseCellModel *model) {
            
            MM_AutoReplyViewController * vc = [[MM_AutoReplyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"模型化TableView" actionBlock:^(HSBaseCellModel *model) {
            
            TableDemoViewController * vc = [[TableDemoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"CollectionView折叠" actionBlock:^(HSBaseCellModel *model) {
            
            MMSearchViewController * vc = [[MMSearchViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        s;
    })];
}


@end
