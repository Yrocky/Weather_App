//
//  ExtensionViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "ExtensionViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "BillExtensionView.h"
#import "HLLAlert.h"
#import "BillInputView.h"
#import "BillKeyboardView.h"

@interface ExtensionViewController ()<BillExtensionViewDelegate>

@property (nonatomic ,strong) BillInputView * inputView;
@property (nonatomic ,strong) BillKeyboardView * keyboardView;
@property (nonatomic ,strong) MASConstraint * keyboardViewBottomConstraint;
@property (nonatomic ,strong) BillExtensionView * extensionView;
@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拓展功能";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat keyboardHeight = (screenWidth - 3)/1.68 + 3;
    
    self.inputView = [[BillInputView alloc] init];
    [self.view addSubview:self.inputView];
    
    self.keyboardView = [[BillKeyboardView alloc] init];
    [self.view addSubview:self.keyboardView];
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(keyboardHeight);
        if (@available(iOS 11.0, *)) {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    return;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.keyboardView.mas_top).mas_offset(-20);
    }];
    
    BillExtensionView * extensionView = [[BillExtensionView alloc] init];
    extensionView.delegate = self;
    [self.view addSubview:extensionView];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.inputView.mas_bottom);
        make.bottom.mas_equalTo(self.keyboardView.mas_bottom).mas_offset(-40);
    }];
    self.extensionView = extensionView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    

@end
