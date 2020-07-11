//
//  MMWebView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMWebView.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MMPlugin.h"
#import "HLLAlert.h"

static inline void clearWebViewCacheFolderByType(NSString *cacheType) {
    static dispatch_once_t once;
    static NSDictionary *cachePathMap = nil;
    dispatch_once(&once,
                  ^{
                      NSString *bundleId = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
                      NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
                      NSString *storageFileBasePath = [libraryPath stringByAppendingPathComponent:
                                                       [NSString stringWithFormat:@"WebKit/%@/WebsiteData/", bundleId]];
                      cachePathMap = @{ @"WKWebsiteDataTypeCookies":
                                            [libraryPath stringByAppendingPathComponent:@"Cookies/Cookies.binarycookies"],
                                        @"WKWebsiteDataTypeLocalStorage":
                                            [storageFileBasePath stringByAppendingPathComponent:@"LocalStorage"],
                                        @"WKWebsiteDataTypeIndexedDBDatabases":
                                            [storageFileBasePath stringByAppendingPathComponent:@"IndexedDB"],
                                        @"WKWebsiteDataTypeWebSQLDatabases":
                                            [storageFileBasePath stringByAppendingPathComponent:@"WebSQL"] };
                  });
    NSString *filePath = cachePathMap[cacheType];
    if (filePath && filePath.length > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
                NSLog(@"removed file fail: %@ ,error %@", [filePath lastPathComponent], error);
            }
        }
    }
}

@interface MMInternalUserContentController : WKUserContentController

@property (nonatomic ,weak ,readonly) id<WKScriptMessageHandler> handler;

+ (instancetype) uccWithHandler:(id<WKScriptMessageHandler>)handler;

- (void) addScriptMessageHandler:(nonnull NSString *)messageHandler;
- (void) removeScriptMessageHandler:(nonnull NSString *)messageHandler;
- (void) removeAllScriptMessageHandlers;////<移除所有的message-handler
@end

// 使用WKWebView遇到的大多数问题都可以在这里找到解决方案，https://mp.weixin.qq.com/s/rhYKLIbXOsUJC_n6dt9UfA?
@interface MMWebView ()
<WKUIDelegate,
WKNavigationDelegate,
UIScrollViewDelegate
>{
    NSDate *_beforeRequestDate;
    NSDate *_afterRequestDate;
    BOOL _didAddWebViewObserver;
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *cookieDic;
@property (nonatomic ,strong) MMScriptMessageHandler * messageHandler;
@property (nonatomic ,weak) MMInternalUserContentController * userContentController;
@property (nonatomic, copy) NSString *lastUrlString;
@end

@implementation MMWebView

- (void)dealloc{
    NSLog(@"[webView] MMWebView dealloc");
    [self stopLoad];
    if (self.webView.scrollView.delegate == self) {
        self.webView.scrollView.delegate = nil;
    }
    if (_didAddWebViewObserver) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.messageHandler = [MMScriptMessageHandler new];
        [self.messageHandler setupWebView:self.webView];

        [self addSubview:self.webView];
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    return self;
}

#pragma mark - API
- (void) viewWillAppear{

    NSString * javascript = @"setTimeout(function(){window.js_exchange_method=function(str){window.webkit.messageHandlers.JSMethod.postMessage(null)};}, 1)";
    WKUserScript * userScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:userScript];
    
    [self.messageHandler enumDelegateForGetMessageHandler:^(MMMessageHandler msgHandler) {
        [self.userContentController addScriptMessageHandler:msgHandler.name];
    }];
}

- (void) viewWillDisappear{
    
    [self.userContentController removeAllScriptMessageHandlers];
}

- (void)addProgressView{
    [self addProgressViewWithColor:nil];
}
- (void) addProgressViewWithColor:(nullable UIColor *)color{
    if (_progressView) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
//    _progressView.fadeOutDelay = 0.5f;
    _progressView.alpha = 0;
    [_progressView setProgress:0 animated:YES];
    if (nil != color) {
//        _progressView.progressBarView.backgroundColor = color;
    }
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(2);
    }];
}

- (void) setupUrlStirng:(NSString *)urlString{
    _urlString = urlString;
    NSLog(@"[webview]设置要加载的网页%@",urlString);
}

- (void) loadHTML:(NSString *)html{
    
    [self.webView.configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:url allowingReadAccessToURL:url];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    [self addWebViewObserver];
}

- (void) loadHTMLString:(NSString *)htmlString{

    [self.webView.configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self addWebViewObserver];
}

- (void) reload{
    [self.webView reload];
}

- (void)goBack{
    [self.webView goBack];
}

- (void) startLoad{
    
    NSLog(@"[webview]开始加载%@",self.urlString);

    [self.webView.configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];

    if (nil != self.lastUrlString &&
        ![self.lastUrlString isEqualToString:self.urlString]) {
        //清空内容
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        //清除缓存
        [self clearCache];
    }
    
    self.lastUrlString = [NSString stringWithFormat:@"%@",self.urlString];
    
    NSURLRequest *urlReuqest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[self joinAuthForUrlString]]
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:5.0f];// 5-8s
    [self.webView loadRequest:urlReuqest];
    
    NSLog(@"[webView] loadRequest:");
    
    [self addWebViewObserver];
}

- (void) stopLoad{
    
    NSLog(@"[webview] 结束加载%@",self.urlString);
    [self.webView stopLoading];
    ///<将webView的显示内容置为空白
    [self safeAsyncEvaluateJavaScriptString:@"document.body.innerHTML='';"];
    [self.userContentController removeAllScriptMessageHandlers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Privates

- (void) addWebViewObserver{
    if (!_didAddWebViewObserver) {
        [self.webView addObserver:self forKeyPath:@"estimatedProgress"
                          options:NSKeyValueObservingOptionNew context:nil];
        _didAddWebViewObserver = YES;
    }
}

- (NSString *)joinAuthForUrlString{
    
    ///<拼接基础通用的参数
    __block NSString * fullUrl = [NSString stringWithFormat:@"%@?&tt=%f&type=ios",
                                  self.urlString,
                                  [NSDate date].timeIntervalSince1970];
    if (self.extraParams.allKeys) {
        [self.extraParams.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            fullUrl = [fullUrl stringByAppendingFormat:@"&%@=%@",key,self.extraParams[key]];
        }];
    }
    return fullUrl;
}

- (void) clearCache{
    
    if (@available(iOS 9.0, *)) {
        NSArray *types = @[
                           WKWebsiteDataTypeMemoryCache,
                           WKWebsiteDataTypeSessionStorage,
                           WKWebsiteDataTypeDiskCache,
                           WKWebsiteDataTypeOfflineWebApplicationCache,
                           WKWebsiteDataTypeCookies,
                           WKWebsiteDataTypeLocalStorage,
                           WKWebsiteDataTypeIndexedDBDatabases,
                           WKWebsiteDataTypeWebSQLDatabases
                           ]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {// iOS8以及以前的缓存
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        @"WKWebsiteDataTypeCookies",
                                                        @"WKWebsiteDataTypeLocalStorage",
                                                        @"WKWebsiteDataTypeIndexedDBDatabases",
                                                        @"WKWebsiteDataTypeWebSQLDatabases"
                                                        ]];
        for (NSString *type in websiteDataTypes) {
            clearWebViewCacheFolderByType(type);
        }
    }
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void) showWebViewWithAnimation:(BOOL)show{
    
    [UIView animateWithDuration:0.125 animations:^{
        //        self.webView.alpha = show ? 1 : 0;
    }];
}

#pragma mark - js action

- (void)jsActionWithCloseWebView{
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(webViewDidPerformCloseAction:)]) {
        [self.delegate webViewDidPerformCloseAction:self];
    }
    [self stopLoad];
    [self showWebViewWithAnimation:NO];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {///<进度
        float newValue = [change[NSKeyValueChangeNewKey] floatValue];
        NSLog(@"[webView] estimatedProgress:%f",newValue);
        
        [self.progressView setProgress:newValue animated:YES];
        if (newValue >= 1.0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.progressView.alpha = 0;
            }];
        }
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(webViewDidLoadNavigation:progress:)]) {
            [self.delegate webViewDidLoadNavigation:self progress:newValue];
        }
    }
}

#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self showWebViewWithAnimation:NO];
    
    self.progressView.alpha = 1;
    [self.progressView setProgress:0 animated:NO];
    
    NSLog(@"[webView] didStartProvisionalNavigation:");
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(webViewDidStartNavigation:)]) {
        [self.delegate webViewDidStartNavigation:self];
    }
}

/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    _afterRequestDate = [NSDate date];
    NSTimeInterval requestTime = [_afterRequestDate timeIntervalSinceDate:_beforeRequestDate];
    NSLog(@"[webview] 加载%@总共耗时%f",self.lastUrlString,requestTime);
    [self showWebViewWithAnimation:YES];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(webViewDidFinishNavigation:)]) {
        [self.delegate webViewDidFinishNavigation:self];
    }
}

/* 主页面加载新的url失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self showWebViewWithAnimation:NO];
    NSLog(@"[webview]内部点击失败%@",error.localizedDescription);
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(webViewDidFailedNavigation:error:)]) {
        [self.delegate webViewDidFailedNavigation:self error:error];
    }
}
// 主界面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self showWebViewWithAnimation:NO];
    NSLog(@"[webview]主界面加载失败%@",error.localizedDescription);
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(webViewDidFailedNavigation:error:)]) {
        [self.delegate webViewDidFailedNavigation:self error:error];
    }
}

///从webView loadRequest开始到走入这个方法，webView会一直是白屏的状态，这个
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    _beforeRequestDate = [NSDate date];
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    NSURL * url = [navigationAction.request URL];
    NSLog(@"[webView] decidePolicyForNavigationAction:");
    //一些302请求可以在这里进行最终地址的处理，
    // 在该回调函数里拦截302请求，copy request，在 request header 中带上 cookie 并重新 loadRequest
    
    // 在这里处理跨域问题，先不用
    //    if (WKNavigationTypeLinkActivated == navigationAction.navigationType &&
    //        [url.scheme containsString:@"https"]) {
    //        [[UIApplication sharedApplication] openURL:url];
    //        policy = WKNavigationActionPolicyCancel;
    //    }
    
    NSString *urlStr = [[url absoluteString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (nil == urlStr){///<可以在这里做非本host下url的限制
        policy = WKNavigationActionPolicyCancel;
    }
    
    decisionHandler(policy);
    
    return;
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"[webview]WKWebView总体内存占用过大");
    if (self.superview) {
        [self.webView reload];///<解决白屏问题，当webView因为占内存过大的时候回出现白屏，这里relpoad一下
    }
}

///https 请求会进这个方法，在里面进行https证书校验、白名单域名判断等操作
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//}
#pragma mark - WKUIDelegate
- (nullable WKWebView *) webView:(WKWebView *)webView
  createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
             forNavigationAction:(WKNavigationAction *)navigationAction
                  windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView{
    [self jsActionWithCloseWebView];
}

// 处理alert弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    [[[[[HLLAlertUtil title:self.title] message:message] buttons:@[@"ok"]] fetchClick:^(NSInteger index) {
        completionHandler();
    }] show];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(NO);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
    if ([self JSPromptIsTargetSyncMessageWithPrompt:prompt]){
        completionHandler(({
            [self.messageHandler handleSyncMessageWithData:({
                [MMWebView use_yy_dictionaryWithJSON:prompt];
            })];
        }));
    }else{
        completionHandler(@"");
    }
}

- (BOOL) JSPromptIsTargetSyncMessageWithPrompt:(NSString *)prompt{

    return [MMWebView use_yy_dictionaryWithJSON:prompt] != nil ? YES : NO;
}

+ (NSDictionary *) use_yy_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

#pragma mark - Getters

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        // ucc
        MMInternalUserContentController * ucc = [MMInternalUserContentController uccWithHandler:self.messageHandler];
        self.userContentController = ucc;
        configuration.userContentController = ucc;
        
        // preferences
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.multipleTouchEnabled = NO;
        _webView.autoresizesSubviews = YES;
        _webView.scrollView.alwaysBounceVertical = YES;
        _webView.scrollView.bounces = YES;
        _webView.scrollView.delegate = self;
        _webView.scrollView.bouncesZoom = NO;
        _webView.allowsBackForwardNavigationGestures = NO;
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (NSString *)title{
    return self.webView.title;
}
- (BOOL)scrollEnabled{
    return self.webView.scrollView.scrollEnabled;
}
- (void)setScrollEnabled:(BOOL)scrollEnabled{
    self.webView.scrollView.scrollEnabled = scrollEnabled;
}
- (BOOL)bounces{
    return self.webView.scrollView.bounces;
}
- (void)setBounces:(BOOL)bounces{
    self.webView.scrollView.bounces = bounces;
}
@end

@implementation MMWebView (EvaluateJSExtension)

- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script{
    [self safeAsyncEvaluateJavaScriptString:script completionBlock:nil];
}

- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)block{
    [self.messageHandler safeAsyncEvaluateJavaScriptString:script completionBlock:block];
}

@end

@implementation MMWebView (Cookie)

- (void) setCookieWithName:(NSString *)name
                     value:(NSString *)value
                    domain:(NSString *)domain
                      path:(NSString *)path
               expiresDate:(NSDate *)expiresDate
           completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)completionBlock {
    if (!name || name.length <= 0) {
        return;
    }
    
    NSMutableString *cookieScript = [[NSMutableString alloc] init];
    [cookieScript appendFormat:@"document.cookie='%@=%@;", name, value];
    if (domain || domain.length > 0) {
        [cookieScript appendFormat:@"domain=%@;", domain];
    }
    if (path || path.length > 0) {
        [cookieScript appendFormat:@"path=%@;", path];
    }
    
    if (!self.cookieDic) {
        self.cookieDic = @{}.mutableCopy;
    }
    
    [[self cookieDic] setValue:cookieScript.copy forKey:name];
    
    if (expiresDate && [expiresDate timeIntervalSince1970] != 0) {
        [cookieScript appendFormat:@"expires='+(new Date(%@).toUTCString());", @(([expiresDate timeIntervalSince1970]) * 1000)];
    }else{
        [cookieScript appendFormat:@"'"];
    }
    [cookieScript appendFormat:@"\n"];
    
    [self safeAsyncEvaluateJavaScriptString:cookieScript.copy completionBlock:completionBlock];
}

- (void) deleteCookiesWithName:(NSString *)name completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)completionBlock {
    if (!name || name.length <= 0) {
        return;
    }
    
    if (![[[self cookieDic] allKeys] containsObject:name]) {
        return;
    }
    
    NSMutableString *cookieScript = [[NSMutableString alloc] init];
    
    [cookieScript appendString:[[self cookieDic] objectForKey:name]];
    [cookieScript appendFormat:@"expires='+(new Date(%@).toUTCString());\n", @(0)];
    
    [[self cookieDic] removeObjectForKey:name];
    [self safeAsyncEvaluateJavaScriptString:cookieScript.copy completionBlock:completionBlock];
}

- (NSSet<NSString *> *) getAllCustomCookiesName {
    return [[self cookieDic] allKeys].copy;
}

- (void) deleteAllCustomCookies {
    for (NSString *cookieName in [[self cookieDic] allKeys]) {
        [self deleteCookiesWithName:cookieName completionBlock:nil];
    }
}

@end

// 插件这一部分使用的是 https://lvwenhan.com/ios/462.html 这里的方法实现的
@implementation MMWebView (Plugin)

///加载默认的插件
- (void) addDefaultPlugins{
    [self addPlugins:@[@"Base",@"Console",@"Accelerometer",@"Share"]];
}

- (void) addPlugins:(NSArray<NSString *> *)plugins{
    [plugins enumerateObjectsUsingBlock:^(NSString * _Nonnull plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:plugin ofType:@"js"];
        NSError * error = nil;
        NSString * js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (nil != error || nil != js) {
            [self safeAsyncEvaluateJavaScriptString:js];
        } else {
            NSLog(@"[webView] add plugin error:%@",error.localizedDescription);
        }
    }];
    [self.userContentController addScriptMessageHandler:kWebMsgHandlerNameMMWebViewPlugin];
}
@end

@interface MMInternalUserContentController ()
@property (nonatomic ,weak ,readwrite) id<WKScriptMessageHandler> handler;
@property (nonatomic ,strong) NSMutableSet<NSString *> * scriptMessageHandlers;
@end

@implementation MMInternalUserContentController

- (void)dealloc{
    NSLog(@"[webView] MMInternalUserContentController dealloc");
    [self removeAllScriptMessageHandlers];
}

+ (instancetype)uccWithHandler:(id<WKScriptMessageHandler>)handler{
    MMInternalUserContentController * ucc = [MMInternalUserContentController new];
    
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    [javascript appendString:@"var script = document.createElement('meta');"
     "script.name = 'viewport';"
     "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];//禁止作缩放
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [ucc addUserScript:noneSelectScript];
    
    ucc.handler = handler;
    
    return ucc;
}

- (void) addScriptMessageHandler:(nonnull NSString *)messageHandler{
    
    if (nil == self.scriptMessageHandlers) {
        self.scriptMessageHandlers = [NSMutableSet set];
    }
    if (nil == messageHandler ||
        [self.scriptMessageHandlers containsObject:messageHandler]) {/// for safe
        return;
    }
    [self.scriptMessageHandlers addObject:messageHandler];
    [self addScriptMessageHandler:self.handler name:messageHandler];
}

- (void) removeScriptMessageHandler:(nonnull NSString *)messageHandler{
    
    if (nil == messageHandler) {/// for safe
        return;
    }
    if ([self.scriptMessageHandlers containsObject:messageHandler]) {
        [self.scriptMessageHandlers removeObject:messageHandler];
        [self removeScriptMessageHandlerForName:messageHandler];
    }
}

- (void) removeAllScriptMessageHandlers{
    
    [self.scriptMessageHandlers enumerateObjectsUsingBlock:^(NSString * _Nonnull messageHandler, BOOL * _Nonnull stop) {
        [self removeScriptMessageHandlerForName:messageHandler];
    }];
    [self.scriptMessageHandlers removeAllObjects];
    self.scriptMessageHandlers = nil;
}

@end
