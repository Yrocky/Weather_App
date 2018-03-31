//
//  HomeViewController.m
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeBillContainerView.h"
#import "UIColor+Common.h"

@interface HomeViewController ()<HomeBillContainerViewDelegate>

@property (nonatomic ,strong) HomeBillContainerView * containerView;

@property (nonatomic ,strong) UIView * contentView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bill";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.containerView = [[HomeBillContainerView alloc] init];
    self.containerView.tag = 0;
    self.containerView.delegate = self;
    self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:self.containerView];
    
    UIView * contentView = [UIView new];
    contentView.backgroundColor = [UIColor purpleColor];
    self.contentView = contentView;
    
    [self.containerView configBillContentView:self.contentView];
}

#pragma mark - HomeBillContainerViewDelegate

- (void) billContainerViewNeedUpdatePreContentView:(HomeBillContainerView *)containerView{

    containerView.contentView.backgroundColor = [UIColor randomColor];
    NSLog(@"pre:%ld",(long)containerView.tag);
}

- (void) billContainerViewNeedUpdateNextContentView:(HomeBillContainerView *)containerView{
    containerView.contentView.backgroundColor = [UIColor randomColor];
    NSLog(@"next:%ld",(long)containerView.tag);
}
@end
