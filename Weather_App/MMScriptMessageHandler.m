//
//  MMScriptMessageHandler.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/23.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMScriptMessageHandler.h"
#import "MMPlugin.h"

@interface MMScriptMessageHandler ()
@property (nonatomic ,weak ,readwrite) WKWebView * webView;
@end

@implementation MMScriptMessageHandler

- (void)dealloc{
    NSLog(@"[webView] MMScriptMessageHandler dealloc");
}

- (void) setupWebView:(WKWebView *)webView{
    self.webView = webView;
}

- (void) enumDelegateForGetMessageHandler:(void(^)(MMMessageHandler msgHandler))cb{
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(messageHandlerResponseMessages:)]) {
        NSSet<NSValue *> * set = [self.delegate messageHandlerResponseMessages:self];
        [set enumerateObjectsUsingBlock:^(NSValue * _Nonnull value, BOOL * _Nonnull stop) {
            MMMessageHandler msgHandler = MMMessageHandlerFromNSValue(value);
            if (cb) {
                cb(msgHandler);
            }
        }];
    }
}

- (NSString *) handleSyncMessageWithData:(NSDictionary *)data{

    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([self.delegate respondsToSelector:@selector(messageHandler:didReceiveSyncMessage:)]) {
            return [self.delegate messageHandler:self didReceiveSyncMessage:data];
        }
    }
    return @"";
}

#pragma mark - MMEvaluateJaveScriptAble

- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script{
    [self safeAsyncEvaluateJavaScriptString:script completionBlock:nil];
}

- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)block{
    if (!script || script.length <= 0 || nil == self.webView) {
        NSLog(@"[webView]无效的 脚本 或者 webView[%@] 无效",self.webView);
        if (block) {
            block(@"");
        }
        return;
    }
    
    [self.webView evaluateJavaScript:script
                   completionHandler:^(id result, NSError *_Nullable error) {
                       
                       if (!error) {
                           if (block) {
                               NSObject *resultObj = @"";
                               if (!result || [result isKindOfClass:[NSNull class]]) {
                                   resultObj = @"";
                               } else if ([result isKindOfClass:[NSNumber class]]) {
                                   resultObj = ((NSNumber *)result).stringValue;
                               } else if ([result isKindOfClass:[NSObject class]]){
                                   resultObj = (NSObject *)result;
                               } else {
                                   NSLog(@"[webView] 执行js脚本:%@ 返回类型:%@",
                                         NSStringFromClass([result class]),
                                         script);
                               }
                               if (block) {
                                   block(resultObj);
                               }
                           }
                       } else {
                           NSLog(@"[webView] 执行js脚本:%@ 出错: %@", script,error.description);
                           if (block) {
                               block(@"");
                           }
                       }
                   }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    ///< 交给代理处理原始WKMessage数据
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(messageHandler:didReceiveScriptMessage:)]) {
        [self.delegate messageHandler:self didReceiveScriptMessage:message];
    }
    
    ///< 常规消息处理
    [self enumDelegateForGetMessageHandler:^(MMMessageHandler msgHandler) {
        if ([msgHandler.name isEqualToString:message.name] &&
            [self.delegate respondsToSelector:msgHandler.method]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.delegate performSelector:msgHandler.method withObject:message.body];
#pragma clang diagnostic pop
        }
    }];
    
    ///<插件
    if ([message.name isEqualToString:kWebMsgHandlerNameMMWebViewPlugin]) {
        if (nil != message.body && [message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary * body = message.body;
            NSString * className = body[@"className"];
            NSString * funcName = body[@"functionName"];
//            className = @"MMLocalPlugin";// test 不存在的类
//            className = @"MMNode";// test 存在，但不是插件类
            if (nil != className) {
                if (nil != funcName) {
                    MMPlugin * plugin = [NSClassFromString(className) new];
                    @try {
                        plugin.wk = self;
                        plugin.taskId = [body[@"taskId"] integerValue];
                        plugin.data = body[@"data"];
                        if ([plugin respondsToSelector:NSSelectorFromString(funcName)]) {
                            if (self.delegate &&
                                [self.delegate respondsToSelector:@selector(messageHandler:willPerformPlugin:)]) {
                                [self.delegate messageHandler:self willPerformPlugin:plugin];
                            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            [plugin performSelector:NSSelectorFromString(funcName)];
#pragma clang diagnostic pop
                        }
                    } @catch (NSException *exception) {
                        NSLog(@"[webView][plugin] 没有对应的方法，或没有设置对插件类%@",exception);
                    } @finally {
                        
                    }
                } else {
                    NSLog(@"[webView] 没有设置方法[%@]",funcName);
                }
            } else {
                NSLog(@"[webView] 没有设置插件类[%@]",className);
            }
        }
    }
}

@end
