//
//  XXXWebViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "XXXWebViewController.h"
#import "MMWebView.h"
#import "Masonry.h"

@interface XXXWebViewController ()<MMWebViewDelegate>
@property (nonatomic ,strong) MMWebView * webView;
@end

@implementation XXXWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [MMWebView new];
    self.webView.delegate = self;
    [self.webView addProgressView];
    [self.webView addDefaultPlugins];
//    [self.webView setupUrlStirng:@"http://www.baidu.com/"];
//    [self.webView startLoad];
    [self.webView loadHTML:@"testwebview"];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - MMWebViewDelegate

@end
