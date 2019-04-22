//
//  MMPlugin.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMPlugin.h"

@implementation MMPlugin

- (BOOL) callback:(NSDictionary *)values{
    if (nil == values) {
        return NO;
    }
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:values options:0 error:&error];
    if (nil != error) {
        return NO;
    }
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * js = [NSString stringWithFormat:@"fireTask(%lu,'%@');",(unsigned long)self.taskId,jsonString];
    [self.wk safeAsyncEvaluateJavaScriptString:js];
    
    return YES;
}
- (void) errorCallback:(NSString *)errorMessage{
    NSString * js = [NSString stringWithFormat:@"onError(%lu,'%@');",(unsigned long)self.taskId,errorMessage];
    [self.wk safeAsyncEvaluateJavaScriptString:js];
}

- (NSString *)stringByEscapingQueryString:(NSString *)string {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#else
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef) @":/?#[]@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
#endif
}
@end
