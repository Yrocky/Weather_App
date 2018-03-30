//
//  MMXibViewController.m
//  Weather_App
//
//  Created by user1 on 2017/12/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMXibViewController.h"
#import "MMXibCustomView.h"
#import "Masonry.h"

@interface MMXibViewController ()

@end

@implementation MMXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    MMXibCustomOneView * oneView = [MMXibCustomOneView xibView];
    [self.view addSubview:oneView];
    
    MMXibCustomTwoView * twoView = [MMXibCustomTwoView xibView];
    [self.view addSubview:twoView];
    
    MMXibCustomThreeView * threeView = [MMXibCustomThreeView xibView];
    [self.view addSubview:threeView];
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.height.mas_equalTo(55);
    }];
    
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView);
        make.top.mas_equalTo(oneView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(oneView);
        make.height.mas_equalTo(oneView);
    }];
    
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView);
        make.top.mas_equalTo(twoView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(oneView);
        make.height.mas_equalTo(oneView);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
