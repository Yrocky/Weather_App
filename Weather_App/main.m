//
//  main.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HLLAttributedBuilder.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSString * display = @"hello = nihao = Hello = 你好 = nihao";
        
        NSAttributedString * atttStr = [[[HLLAttributedBuilder builderWithString:display]
                                          configString:@"H" forStyle:@{NSBackgroundColorAttributeName:[UIColor orangeColor]}]
                                        attributedString];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
