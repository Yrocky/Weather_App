//
//  XXXHTTPProtocol.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/25.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXHTTPProtocol.h"

@interface XXXHTTPProtocol ()

@property (nonatomic ,strong) NSURLSessionDataTask * task;
@end

@implementation XXXHTTPProtocol

+ (void) start{
    ///只有注册了这个protocol，才会开启网络的拦截
    [NSURLProtocol registerClass:self];
}
// 1.只要注册了这个protocol，系统都会在每一个request中来决定是否交给这个protocol处理
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    
    // 如果是已经拦截过的就放行，避免出现死循环
    if ([NSURLProtocol propertyForKey:@"kProtocolHandledKey" inRequest:request] ) {
        return NO;
    }
    
    BOOL        shouldAccept;
    NSURL *     url;
    NSString *  scheme;
    
    shouldAccept = (request != nil);
    if (shouldAccept) {
        url = [request URL];
        shouldAccept = (url != nil);
    }
    
    // Get the scheme.
    if (shouldAccept) {
        scheme = [[url scheme] lowercaseString];
        shouldAccept = (scheme != nil);
    }
    
    // Look for "http" or "https".
    //
    // Flip either or both of the following to YESes to control which schemes go through this custom
    // NSURLProtocol subclass.
    if (shouldAccept) {
        shouldAccept = NO && [scheme isEqual:@"http"];
        if ( ! shouldAccept ) {
            shouldAccept = YES && [scheme isEqual:@"https"];
        }
    }
    NSLog(@"[custom protocol] shouldAccept:%d %@",shouldAccept,request);
    return shouldAccept;
}

// 2.在经过过滤之后，我们得到了所有要处理的请求，接下来需要对请求进行一定的操作，比如统一添加header、设置cookie
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];

    // 设置已处理标志
    [NSURLProtocol setProperty:@(YES)
                        forKey:@"kProtocolHandledKey"
                     inRequest:mutableReqeust];
    return mutableReqeust.copy;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

- (void)startLoading {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:self.request];
    [task resume];
    self.task = task;
}

- (void)stopLoading{
    [self.task cancel];
}
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
//
//    completionHandler(NSURLSessionResponseAllow);
//}
//
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    [[self client] URLProtocol:self didLoadData:data];
//}
@end
