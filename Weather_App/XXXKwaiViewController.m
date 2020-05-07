//
//  XXXKwaiViewController.m
//  Weather_App
//
//  Created by skynet on 2019/12/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXKwaiViewController.h"
#import "XXXKwaiFrameAdjustView.h"
#import "Masonry.h"
#import "XXXElevator.h"
#import "UIColor+Common.h"

@interface XXXKwaiViewController ()

@property (nonatomic ,strong) XXXKwaiFrameAdjustView * adjustView;
@property (nonatomic ,strong) XXXElevator * elevator;
@end

@implementation XXXKwaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton new];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.center.equalTo(self.view);
    }];
    button.backgroundColor = [UIColor orangeColor];
    
    self.view.backgroundColor = [UIColor randomColor];
    [button addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];

    //    self.adjustView = [XXXKwaiFrameAdjustView new];
//    [self.adjustView addGestures];
//    [self.view addSubview:self.adjustView];
//
//
//    [self.adjustView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(300, 500));
//    }];
    
}

- (void) onTap{
    
    [self presentViewController:XXXKwaiViewController.new animated:YES completion:nil];
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
