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
#import "Masonry.h"

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
//    self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:self.containerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(0);
        }
        make.width.mas_equalTo(self.view);
    }];
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

- (BOOL)allowBillContainerViewLoadPreContentView:(HomeBillContainerView *)containterView{
    
    // 在这里根据contentView的日期判断是否可以加载
    return YES;
}

- (BOOL)allowBillContainerViewLoadNextContentView:(HomeBillContainerView *)containterView{
    return YES;
}

@end
