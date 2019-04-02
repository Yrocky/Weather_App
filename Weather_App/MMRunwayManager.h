//
//  MMRunwayManager.h
//  Weather_App
//
//  Created by user1 on 2018/3/28.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 发送跑道通知，内部携带一个TTSingleLineView
static NSString * const MMRunwayManagerSendNormalSingleLineViewNotification = @"com.2339.runway.send.normal.singlelineview";
static NSString * const MMRunwayManagerSendNormalProSingleLineViewNotification = @"com.2339.runway.send.pro.singlelineview";

@class MMRunwayManager;
@protocol MMRunwayManagerDelegate <NSObject>

- (void) runwayManager:(MMRunwayManager *)mgr didSendNormalSingleLineView:(__kindof UIView *)singleLineView;
- (void) runwayManager:(MMRunwayManager *)mgr didSendProSingleLineView:(__kindof UIView *)singleLineView;

@end
// 用来管理跑道视图的生成，销毁
@interface MMRunwayManager : NSObject

@property (nonatomic ,weak) id<MMRunwayManagerDelegate>delegate;

///<这里不需要将manager设置成单例，当时主要是为了在socket解析层中使用
+ (instancetype) runwayManager;

////////// 普通跑道相关业务逻辑
@property (nonatomic ,copy) UIView *(^bRunwayGenerateNormalSingleLineView)(id json);
- (void) normalRunwayReceiveSocketAction:(id)model;
- (void) normalRunwayCompletedOneSingleLineViewDisplay;
- (void) normalRunwayRemoveAllData;

////////// pro跑道相关业务逻辑
@property (nonatomic ,copy) UIView *(^bRunwayGenerateProSingleLineView)(id json);
- (void) proRunwayReceiveSocketAction:(id)model;
- (void) proRunwayCompletedOneSingleLineViewDisplay;
- (void) proRunwayRemoveAllData;

////////// 在退出直播间的时候移除相关的数据，防止再次进入的时候数据还在
- (void) removeAllRunwayData;

////////// debug
- (NSString *) queueAndCacheInfo;

@end
