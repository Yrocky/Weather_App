//
//  MM_FindFriendEntryViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/11/6.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MM_FindFriendEntryViewController.h"
#import "LayoutViewController.h"
#import "Masonry.h"

@interface MM_FindFriendEntryViewController ()

@property (nonatomic ,strong) LayoutViewController * layoutVC;

@property (nonatomic ,strong) UIView * customRightView;
@property (nonatomic ,strong) UIView * customBottomView;

@end

@implementation MM_FindFriendEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.layoutVC = [[LayoutViewController alloc] init];
    self.layoutVC.view.frame = CGRectMake(0, 0, 200, 300);
//    self.layoutVC.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.layoutVC.view];
    
    [self addChildViewController:self.layoutVC];
    
    self.customRightView = [[UIView alloc] init];
    self.customRightView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.customRightView];
    
    self.customBottomView = [[UIView alloc] init];
    self.customBottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.customBottomView];
    
    [self.customBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
        make.height.mas_equalTo(40);
    }];
    
    [self.customRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.customBottomView.mas_top);
    }];
    
    [self.layoutVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.customBottomView.mas_top);
        make.right.mas_equalTo(self.customRightView.mas_left);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UIEdgeInsets additionalSafeAreaInsets = UIEdgeInsetsZero;
    
    additionalSafeAreaInsets.right += self.customRightView.frame.size.width;
    
    additionalSafeAreaInsets.bottom += self.customBottomView.frame.size.height;
    
    self.layoutVC.additionalSafeAreaInsets = additionalSafeAreaInsets;
}
@end
