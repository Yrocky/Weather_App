//
//  MMKVViewController.m
//  Weather_App
//
//  Created by skynet on 2019/12/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMKVViewController.h"
#import <MMKV/MMKV.h>

@interface MMKVViewController ()

@end

@implementation MMKVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
