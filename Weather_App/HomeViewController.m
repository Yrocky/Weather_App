//
//  HomeViewController.m
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeBillContainerView.h"

@interface HomeViewController ()
@property (nonatomic ,strong) HomeBillContainerView * containerView;

@property (nonatomic ,strong) UIView * contentView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bill";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.containerView = [[HomeBillContainerView alloc] init];
    self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:self.containerView];
    
    UIView * weakContentView = [UIView new];
    weakContentView.backgroundColor = [UIColor purpleColor];
    self.contentView = weakContentView;
    
    [self.containerView configBillContentView:self.containerView];
}

@end
