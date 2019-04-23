//
//  MMSharePlugin.m
//  Weather_App
//
//  Created by Rocky Young on 2019/4/22.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMSharePlugin.h"

@implementation MMSharePlugin

- (void) wechat{
    NSLog(@"[webView][plugin][share wechat]:%@",self.data);
}
- (void) qq{
    NSLog(@"[webView][plugin][share qq]:%@",self.data);
}
- (void) qq2{
    
    ///模拟一个异步操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///模拟这个异步操作的回调
        [self callback:@{@"success":@"YES"}];
//        [self errorCallback:@"error call back"];
    });
}
@end
