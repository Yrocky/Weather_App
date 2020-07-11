//
//  MMPlugin.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMEvaluateJaveScriptAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPlugin : NSObject

@property (nonatomic ,weak) id<MMEvaluateJaveScriptAble> wk;
@property (nonatomic ,assign) NSUInteger taskId;
@property (nonatomic ,strong) NSString * data;

- (BOOL) callback:(NSDictionary *)values;
- (void) errorCallback:(NSString *)errorMessage;
@end

NS_ASSUME_NONNULL_END
