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
    NSLog(@"[webView] share wechat:%@",self.data);
}
- (void) qq{
    NSLog(@"[webView] share qq:%@",self.data);
}
- (void) qq2{
    
    //模拟native调用js并通知delegate
//    NSString * msg = [NSString stringWithFormat:@"Your share to qq <%@> is SUCCESS",self.data];
//    [self callback:@{@"success":msg}];
//    if (self.delegate &&
//        [self.delegate respondsToSelector:@selector(sharePlugin:didShareSuccess:)]) {
//        [self.delegate sharePlugin:self didShareSuccess:@{@"success":msg}];
//    }
//    return;
    ///模拟一个异步操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///模拟这个异步操作的回调
        NSUInteger random = arc4random_uniform((UInt32)10);
        if (random % 2) {
            ///<插件给js提供成功的回调
            NSString * msg = [NSString stringWithFormat:@"Your share to qq <%@> is SUCCESS",self.data];
            [self callback:@{@"success":msg}];
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(sharePlugin:didShareSuccess:)]) {
                [self.delegate sharePlugin:self didShareSuccess:@{@"success":msg}];
            }
        } else {
            ///<插件给js提供失败的回调
            NSString * msg = [NSString stringWithFormat:@"Your share to qq <%@> is FAILED",self.data];
            [self errorCallback:msg];
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(sharePlugin:didShareFailed:)]) {
                NSError * e = [NSError errorWithDomain:@"MMWebView-Share-Plugin"
                                                  code:1009
                                              userInfo:@{NSLocalizedFailureReasonErrorKey:msg}];
                [self.delegate sharePlugin:self didShareFailed:e];
            }
        }
    });
}
@end
