//
//  MMPlugin.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMPlugin.h"

@implementation MMPlugin

- (void)dealloc{
    NSLog(@"[webView] %@ dealloc",self);
}

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
@end
