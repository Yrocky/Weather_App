//
//  MMEvaluateJaveScriptAble.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/23.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MMWebViewEvaluateJSCompletionBlock)(NSObject *result);

@protocol MMEvaluateJaveScriptAble <NSObject>

- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script;
- (void) safeAsyncEvaluateJavaScriptString:(NSString *)script
                           completionBlock:(nullable MMWebViewEvaluateJSCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
