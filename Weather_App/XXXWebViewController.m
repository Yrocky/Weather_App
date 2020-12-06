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
#import "MMSharePlugin.h"
#import <WebKit/WebKit.h>

@interface XXXWebViewController ()<
MMWebViewDelegate,
MMScriptMessageHandlerDelegate,
MMSharePluginDelegate>
@property (nonatomic ,strong) MMWebView * webView;
@end

@implementation XXXWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [MMWebView new];
    self.webView.delegate = self;
    self.webView.messageHandler.delegate = self;
    [self.webView addProgressView];
    [self.webView addDefaultPlugins];
    [self.webView viewWillAppear];///<一定要在 设置`webView.messageHandler.delegate`之后
    [self.webView setupUrlStirng:@"https://dev.91banban.com/1.html?token=ODQ0NzhfRjU5QkQ2NUY3RURBRkIwODdBODFENERDQTA2QzQ5MTBfMl8zNDlDMEU4NS1CMjBGLTQzQ0QtQjI2Mi01MUZENTI3Q0ZERTZfMTYwNjg5NzU5NF9iYW5iYW4xMjM0NTY=&showtype=0&tt=1606897613.491665&type=ios&os=2&versionCode=275&deviceId=349C0E85-B20F-43CD-B262-51FD527CFDE6&uid=84478&roomid=80560"];
    [self.webView startLoad];
//    [self.webView loadHTML:@"testwebview"];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) onSomeValue:(id)data{
    NSLog(@"on some value:%@",data);
}

- (void) onJsMethod{
    NSLog(@"onJsMethod exchange");
}

#pragma mark - MMWebViewDelegate

#pragma mark - MMScriptMessageHandlerDelegate

- (NSSet<NSValue *> *) messageHandlerResponseMessages:(MMScriptMessageHandler *)msgHandler{
    
    return [NSSet setWithObjects:
            NSValueFromMessageHandler(MMMessageHandlerMake(@"SomeValue", @selector(onSomeValue:))),
            NSValueFromMessageHandler(MMMessageHandlerMake(@"JSMethod", @selector(onJsMethod))),
            nil];
}

- (void)messageHandler:(MMScriptMessageHandler *)msgHandler willPerformPlugin:(__kindof MMPlugin *)plugin{
    if ([plugin isKindOfClass:[MMSharePlugin class]]) {
        MMSharePlugin * sharePlugin = (MMSharePlugin *)plugin;
        sharePlugin.delegate = self;
    }
}

- (NSString *)messageHandler:(MMScriptMessageHandler *)msgHandler didReceiveSyncMessage:(NSDictionary *)message{
    NSString * name = message[@"action"];
    if ([name isEqualToString: @"modif"]) {
        return @"2222222";
    }
    if ([name isEqualToString:@"add"]) {
        return @"33333";
    }
    
    return @"";
}
#pragma mark - MMSharePluginDelegate

- (void) sharePlugin:(MMSharePlugin *)plugin didShareSuccess:(id)info{
    NSLog(@"on share success:%@",info);
}
- (void) sharePlugin:(MMSharePlugin *)plugin didShareFailed:(NSError *)error{
    NSLog(@"on share error:%@",error);
}

@end
