//
//  FishBoViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/24.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "FishBoViewController.h"
#import "UIColor+Common.h"
#import "Masonry.h"
#import "XXXHTTPProtocol.h"
#import "AFNetworking.h"

@interface FishBoViewController ()
@end

@implementation FishBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    
    UIButton * sessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sessionButton setTitle:@"Session" forState:UIControlStateNormal];
    [sessionButton addTarget:self action:@selector(session) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sessionButton];
    
    UIButton * afnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [afnButton setTitle:@"AFN" forState:UIControlStateNormal];
    [afnButton addTarget:self action:@selector(afn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afnButton];
    
    [sessionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(30);
    }];
    
    [afnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(sessionButton);
        make.top.equalTo(sessionButton.mas_bottom).mas_offset(30);
        make.centerX.equalTo(sessionButton);
    }];
}

- (void) session{
    NSURLSession * s = [NSURLSession sharedSession];
    NSURLSessionDataTask * t = [s dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [t resume];
}

- (void) afn{
    
    //实际上 ULS允许加载多个NSURLProtocol，它们被存在一个数组里，默认情况下，AFNETWorking只会使用数组里的第一个protocol。
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/javascript",@"text/html",nil];
    
    [manager GET:@"https://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"[custom protocol] %@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"[custom protocol] %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"[custom protocol] %@", error);
    }];
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
