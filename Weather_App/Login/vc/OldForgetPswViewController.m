//
//  OldForgetPswViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "OldForgetPswViewController.h"
#import "OldForgetPswConfirmViewController.h"
#import "XXXLoginCommitButton.h"
#import "XXXLoginInputView.h"
#import "XXXLoginNotiView.h"
#import "Masonry.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface OldForgetPswViewController ()

@property (nonatomic ,strong) XXXLoginInputView * accountView;
@property (nonatomic ,strong) XXXLoginCommitButton * fetchCodeButton;

@property (nonatomic ,strong) XXXLoginInputView * codeView;

@property (nonatomic ,strong) XXXLoginCommitButton * nextButton;

@property (nonatomic ,assign) NSInteger code;
@end

@implementation OldForgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    _code = NSNotFound;
    
    self.accountView = [[XXXLoginInputView alloc] initWithPlaceholder:@"请输入你的账号"];;
    [self.view addSubview:self.accountView];
    
    self.fetchCodeButton = [XXXLoginCommitButton new];
    [self.fetchCodeButton setupTitle:@"获取验证码"];
    self.fetchCodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.fetchCodeButton addTarget:self action:@selector(onFetchCodeAction)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fetchCodeButton];
    
    self.codeView = [[XXXLoginInputView alloc] initWithPlaceholder:@"请输入验证码"];
    [self.view addSubview:self.codeView];
    
    self.nextButton = [XXXLoginCommitButton new];
    [self.nextButton setupTitle:@"下一步"];
    [self.nextButton addTarget:self action:@selector(moveToPswConfirm)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
 
    [self.fetchCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.equalTo(self.view.mas_rightMargin);
        make.centerY.equalTo(self.accountView);
    }];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_leftMargin);
        make.right.equalTo(self.fetchCodeButton.mas_left).mas_offset(-12);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(200);
    }];
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.accountView);
        make.right.equalTo(self.view.mas_rightMargin);
        make.top.equalTo(self.accountView.mas_bottom).mas_offset(10);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeView).mas_offset(40);
        make.right.equalTo(self.codeView).mas_offset(-40);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.codeView.mas_bottom).mas_offset(50);
    }];
}

- (void) onFetchCodeAction{
    
    if (self.accountView.text.length) {
        _code = arc4random() % 100000;
        
        [[XXXLoginNotiView notiWith:[NSString stringWithFormat:@"您的验证码为%ld",(long)_code]] show];
    } else {
        [[XXXLoginNotiView notiWith:@"请输入您的账号"] show];
    }
}

#pragma mark - flow

- (void) moveToPswConfirm{
    
    if (self.codeView.text.integerValue == _code) {
        OldForgetPswConfirmViewController * vc = [OldForgetPswConfirmViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[XXXLoginNotiView notiWith:@"请输入正确的验证码"] show];
    }
}

@end
