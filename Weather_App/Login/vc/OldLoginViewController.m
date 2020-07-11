//
//  OldLoginViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "OldLoginViewController.h"
#import "OldRegistViewController.h"
#import "OldForgetPswViewController.h"
#import "XXXLoginInputView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Masonry.h"
#import "XXXLoginCommitButton.h"
#import "XXXLoginNotiView.h"

@interface OldLoginViewController ()

@property (nonatomic ,strong) XXXLoginInputView * accountView;
@property (nonatomic ,strong) XXXLoginInputView * pswView;
@property (nonatomic ,strong) XXXLoginCommitButton * loginButton;
@end

@implementation OldLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    
    self.accountView = [[XXXLoginInputView alloc] initWithPlaceholder:@"请输入账号"];
    [self.view addSubview:self.accountView];
    
    self.pswView = [[XXXLoginInputView alloc] initWithPlaceholder:@"请输入密码"];
    [self.view addSubview:self.pswView];
    
    UIButton * registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registButton addTarget:self action:@selector(moveToRegist)
           forControlEvents:UIControlEventTouchUpInside];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    registButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:registButton];
    
    UIButton * forgetPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPswButton addTarget:self action:@selector(moveToForgetPsw)
           forControlEvents:UIControlEventTouchUpInside];
    [forgetPswButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPswButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    forgetPswButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:forgetPswButton];
    
    self.loginButton = [XXXLoginCommitButton new];
    [self.loginButton setupTitle:@"登录"];
    [self.loginButton addTarget:self action:@selector(onLoginAction)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin);
        make.right.equalTo(self.view.mas_rightMargin);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(200);
    }];
    
    [self.pswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountView);
        make.top.equalTo(self.accountView.mas_bottom).mas_offset(10);
    }];
    
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswView);
        make.top.equalTo(self.pswView.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [forgetPswButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pswView);
        make.width.height.top.equalTo(registButton);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswView).mas_offset(40);
        make.right.equalTo(self.pswView).mas_offset(-40);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.pswView.mas_bottom).mas_offset(50);
    }];
}

#pragma mark - Action

- (void) onLoginAction{
    
    if (self.accountView.text.length &&
        self.pswView.text.length) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[XXXLoginNotiView notiWith:@"请输入正确的账号信息"] show];
    }
}

#pragma mark  flow

- (void) moveToRegist{
    OldRegistViewController * vc = [OldRegistViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) moveToForgetPsw{
    OldForgetPswViewController * vc = [OldForgetPswViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
