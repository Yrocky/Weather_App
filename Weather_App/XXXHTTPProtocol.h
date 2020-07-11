//
//  XXXHTTPProtocol.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/25.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 自定义protocol可以用来在底层拦截所有的网络请求，仅限于NSURLSession、UIWebView、NSURLConnection这三个，为WKWebView重的网络请求就不行，
 
 既然是拦截请求，那么就会有以下几个问题需要了解：
 * 如何决定哪些请求需要当前协议对象处理？
 * 对当前的请求对象需要进行哪些处理？
 * NSURLProtocol 如何实例化？
 * 如何将发出 HTTP 请求并且将响应传递给调用者
 
 由于是子类化NSURLProtocol的，可以重写父类的方法来解决上面的疑问
 */
@interface XXXHTTPProtocol : NSURLProtocol<NSURLSessionDelegate>

+ (void) start;
@end

NS_ASSUME_NONNULL_END
