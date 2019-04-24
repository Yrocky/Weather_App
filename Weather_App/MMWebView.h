//
//  MMWebView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMScriptMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class MMWebView;
@protocol MMWebViewDelegate <NSObject>

@optional
- (void) webViewDidStartNavigation:(MMWebView *)webView;
- (void) webViewDidFinishNavigation:(MMWebView *)webView;
- (void) webViewDidFailedNavigation:(MMWebView *)webView error:(nullable NSError *)error;

/// KVO for estimatedProgress
- (void) webViewDidLoadNavigation:(MMWebView *)webView progress:(float)progress;

- (void) webViewDidPerformCloseAction:(MMWebView *)webView;///<关闭
@end

@interface MMWebView : UIView{
    NSString *_urlString;
}

@property (nonatomic ,copy ,readonly) NSString * title;
@property (nonatomic ,copy ,readonly) NSString * urlString;

@property (nonatomic ,strong ,readonly) MMScriptMessageHandler * messageHandler;
@property (nonatomic ,weak) id<MMWebViewDelegate> delegate;

@property (nonatomic ,copy) NSDictionary * extraParams;///<对于有些url需要额外的添加参数

@property (nonatomic ,assign) BOOL scrollEnabled;
@property (nonatomic ,assign) BOOL bounces;

///<添加一套视图的显示消失逻辑，在这里进行messageHandler的添加和移除，
- (void) viewWillAppear;
- (void) viewWillDisappear;

- (void) addProgressView;
- (void) addProgressViewWithColor:(nullable UIColor *)color;

- (void) setupUrlStirng:(NSString *)urlString;///<hostType为InUrl，也就是包含在urlString内部

- (void) loadHTML:(NSString *)html;
- (void) loadHTMLString:(NSString *)htmlString;

- (void) reload;
- (void) goBack;

- (void) startLoad;
- (void) stopLoad;

- (void) clearCache;
@end

@interface MMWebView (EvaluateJSExtension)<MMEvaluateJaveScriptAble>

@end

@interface MMWebView (Cookie)

///手动设置cookies
- (void)setCookieWithName:(NSString *)name
                    value:(NSString *)value
                   domain:(NSString *)domain
                     path:(NSString *)path
              expiresDate:(NSDate *)expiresDate
          completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)completionBlock;

///删除相应name的cookie
- (void)deleteCookiesWithName:(NSString *)name
              completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)completionBlock;

///获取全部通过setCookieWithName注入的cookieName
- (NSSet<NSString *> *)getAllCustomCookiesName;

///删除所有通过setCookieWithName注入的cookie
- (void)deleteAllCustomCookies;
@end

@interface MMWebView (Plugin)

- (void) addDefaultPlugins;
///<外部如果需要添加自定义的插件，需要在plugins文件夹下添加对应的脚本以及对应的插件类
- (void) addPlugins:(NSArray<NSString *> *)plugins;
@end

NS_ASSUME_NONNULL_END
