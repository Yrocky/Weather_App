//
//  MMKVViewController.m
//  Weather_App
//
//  Created by skynet on 2019/12/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMKVViewController.h"
#import <MMKV/MMKV.h>
#import "Masonry.h"

@interface MMKVViewController ()

@end

@implementation MMKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView * scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    UIView * redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redView];
    
    UIView * button = [UIView new];
    button.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:button];
    
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.centerX.equalTo(scrollView);
        make.top.equalTo(redView.mas_bottom).mas_offset(70);
        make.bottom.equalTo(scrollView.mas_bottom).mas_offset(-50);
    }];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.width.equalTo(self.view);
        make.top.equalTo(scrollView);
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        //        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        //        make.height.mas_equalTo(100);
        make.bottom.equalTo(self.view);
    }];
    
    NSInteger count = 10;
    for (NSInteger index = 0; index < count; index ++) {
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor orangeColor];
        [redView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (index == 0) {
                make.top.equalTo(redView);
            } else {
                make.top.equalTo(redView.subviews[index - 1].mas_bottom).mas_offset(10);
            }
            make.left.right.equalTo(redView);
            make.height.mas_equalTo(60);
            if (index == count - 1) {
                make.bottom.equalTo(redView);
            }
        }];
    }
    
    MMKV * aaa = [MMKV mmkvWithID:@"aaa"];
    [MMKV setLogLevel:MMKVLogNone];
    
    [aaa setBool:YES forKey:@"bool-key"];
    [aaa setString:@"rocky" forKey:@"user-name"];
    
    BOOL aValue = [aaa getBoolForKey:@"bool-key"];
    NSLog(@"aValue:%d",aValue);
    
    MMKV * bbb = [MMKV mmkvWithID:@"bbb"];
    BOOL bValue = [bbb getBoolForKey:@"bool-key"];
    [bbb setBool:YES forKey:@":a:"];
    NSLog(@"bValue:%d",bValue);
    
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
