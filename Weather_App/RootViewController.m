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

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Root";
    
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
        
        s;
    })];
}


@end
