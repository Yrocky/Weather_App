//
//  MMScriptMessageHandler.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/23.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMEvaluateJaveScriptAble.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kWebMsgHandlerNameiMMWebViewPlugin = @"MMWebViewPlugin";

///< 提供一个messageHandler的抽象数据，不使用对象
typedef struct MMMessageHandler{
    NSString *name;
    SEL method;
} MMMessageHandler;

@class MMPlugin;
@class MMScriptMessageHandler;
@protocol MMScriptMessageHandlerDelegate <NSObject>

@optional;
////<设置需要添加和js交互的message-handler
- (NSSet<NSValue *> *) messageHandlerResponseMessages:(MMScriptMessageHandler *)msgHandler;
- (void) messageHandler:(MMScriptMessageHandler *)msgHandler didReceiveScriptMessage:(WKScriptMessage *)message;

- (void) messageHandler:(MMScriptMessageHandler *)msgHandler willPerformPlugin:(__kindof MMPlugin *)plugin;
@end

@protocol MMEvaluateJaveScriptAble;
// 一个中间类，用来打破WKWebView中和ucc的循环引用
@interface MMScriptMessageHandler : NSObject<WKScriptMessageHandler,MMEvaluateJaveScriptAble>

@property (nonatomic ,weak ,readonly) WKWebView * webView;
@property (nonatomic ,weak) id<MMScriptMessageHandlerDelegate> delegate;

- (void) setupWebView:(WKWebView *)webView;
- (void) enumDelegateForGetMessageHandler:(void(^)(MMMessageHandler msgHandler))cb;
@end


#pragma mark - InLine MMMessageHandler

NS_INLINE MMMessageHandler
MMMessageHandlerMake(NSString *name, SEL method){
    MMMessageHandler msgHandler;
    msgHandler.name = name;
    msgHandler.method = method;
    return msgHandler;
};

NS_INLINE MMMessageHandler
MMMessageHandlerFromNSValue(NSValue * value){
    MMMessageHandler msgHandler;
    [value getValue:&msgHandler];
    return msgHandler;
};

NS_INLINE NSValue *
NSValueFromMessageHandler(MMMessageHandler msgHandler){
    NSValue *msgHandlerValue = [NSValue valueWithBytes:&msgHandler
                                              objCType:@encode(struct MMMessageHandler)];
    return msgHandlerValue;
};
NS_ASSUME_NONNULL_END
