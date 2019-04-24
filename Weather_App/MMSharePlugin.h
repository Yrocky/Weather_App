//
//  MMSharePlugin.h
//  Weather_App
//
//  Created by Rocky Young on 2019/4/22.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class MMSharePlugin;
@protocol MMSharePluginDelegate <NSObject>

- (void) sharePlugin:(MMSharePlugin *)plugin didShareSuccess:(id)info;
- (void) sharePlugin:(MMSharePlugin *)plugin didShareFailed:(NSError *)error;
@end

@interface MMSharePlugin : MMPlugin
///<供native获取插件的反馈数据
@property (nonatomic ,weak) id<MMSharePluginDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
