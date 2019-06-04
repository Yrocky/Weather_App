//
//  YTKRequest+PromiseKit.m
//  Weather_App
//
//  Created by meme-rocky on 2019/1/21.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "YTKRequest+PromiseKit.h"
#import "NSURLSession+AnyPromise.h"
#import <UIKit/UIKit.h>

#define YTKURLErrorFailureResponseStringKey @"YTKURLErrorFailureResponseStringKey"
#define YTKURLErrorFailureResponseDataKey @"YTKURLErrorFailureResponseDataKey"

@implementation YTKRequest (PromiseKit)

- (void)dealloc{
    NSLog(@"[YTK] %@ dealloc",self);
}

- (id) mapModelWithJsonData:(id)jsonData{
    return nil;
}

- (AnyPromise *)startPromise{
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSURLResponse * response = request.response;
            NSData * data = request.responseData;
            
            PMKResolver fulfiller = ^(id responseObject){
                resolve(PMKManifold(responseObject, response, data));
            };
            
            PMKResolver rejecter = ^(NSError *error){
                id userInfo = error.userInfo.mutableCopy ?: [NSMutableDictionary new];
                if (data) {
                    userInfo[YTKURLErrorFailureResponseDataKey] = data;
                }
                if (request.responseString) {
                    userInfo[YTKURLErrorFailureResponseStringKey] = request.responseString;
                }
                error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                resolve(error);
            };
            
            NSStringEncoding (^stringEncoding)(void) = ^NSStringEncoding{
                id encodingName = [response textEncodingName];
                if (encodingName) {
                    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encodingName);
                    if (encoding != kCFStringEncodingInvalidId)
                        return CFStringConvertEncodingToNSStringEncoding(encoding);
                }
                return NSUTF8StringEncoding;
            };
            
            NSError* (^commonError)(NSString*) = ^NSError*(NSString *description){
                id info = @{
                            NSLocalizedDescriptionKey: description,
                            NSURLErrorFailingURLStringErrorKey: request.currentRequest.URL.absoluteString,
                            NSURLErrorFailingURLErrorKey: request.currentRequest.URL
                            };
                id err = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorBadServerResponse
                                         userInfo:info];
                return err;
            };
            
            NSInteger responseStatusCode = request.responseStatusCode;
            if (responseStatusCode < 200 || responseStatusCode >= 300) {
                rejecter(commonError(@"[YTK] The server returned a bad HTTP response code"));
            } else if (PMKHTTPURLResponseIsJSON(request.response)) {
                
                // work around ever-so-common Rails workaround: https://github.com/rails/rails/issues/1742
                if ([response expectedContentLength] == 1 &&
                    [data isEqualToData:[NSData dataWithBytes:" " length:1]]) {
                    return fulfiller(nil);
                }
                
                NSError *err = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:PMKJSONDeserializationOptions error:&err];
                if (!err) {
                    id mappedModel = [self mapModelWithJsonData:json];
                    fulfiller(mappedModel? : json);
                } else {
                    id userInfo = err.userInfo.mutableCopy;
                    if (data) {
                        NSString *string = [[NSString alloc] initWithData:data encoding:stringEncoding()];
                        if (string){
                            userInfo[PMKURLErrorFailingStringKey] = string;
                        }
                    }
                    long long length = [response expectedContentLength];
                    id bytes = length <= 0 ? @"" : [NSString stringWithFormat:@"%lld bytes", length];
                    id fmt = @"[YTK] The server claimed a %@ JSON response, but decoding failed with: %@";
                    userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:fmt, bytes, userInfo[NSLocalizedDescriptionKey]];
                    err = [NSError errorWithDomain:err.domain code:err.code userInfo:userInfo];
                    rejecter(err);
                }
            } else if (PMKHTTPURLResponseIsImage(response)) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                image = [[UIImage alloc] initWithCGImage:[image CGImage] scale:image.scale orientation:image.imageOrientation];
                if (image)
                    fulfiller(image);
                else {
                    rejecter(commonError(@"[YTK] The server returned invalid image data"));
                }
            } else if (PMKHTTPURLResponseIsText(response)) {
                id str = [[NSString alloc] initWithData:data encoding:stringEncoding()];
                if (str)
                    fulfiller(str);
                else {
                    rejecter(commonError(@"[YTK] The server returned invalid string data"));
                }
            } else {
                fulfiller(data);
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSError * error = request.error;
            
            id userInfo = error.userInfo.mutableCopy ?: [NSMutableDictionary new];
            if (request.responseData) {
                userInfo[YTKURLErrorFailureResponseDataKey] = request.responseData;
            }
            if (request.responseString) {
                userInfo[YTKURLErrorFailureResponseStringKey] = request.responseString;
            }
            error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            
            resolve(error);
        }];
    }];
}
@end

@implementation XXXRequest


@end
