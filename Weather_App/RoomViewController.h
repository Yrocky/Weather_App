//
//  RoomViewController.h
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RoomModel;
@class RoomViewController;
@protocol RoomViewControllerDelegate <NSObject>

///<是否允许外部容器视图进行滚动
- (void) roomViewController:(RoomViewController *)liveRoom allowScroll:(BOOL)allow;

///<主播已经下线，通知代理进行移除相关数据源
- (void) roomViewController:(RoomViewController *)liveRoom
            offlineWithRoom:(RoomModel *)room;

///<内部点击推荐主播，通知外部数据源更新
- (void) roomViewController:(RoomViewController *)liveRoom
              didChangeRoom:(RoomModel *)room;

///<需要外部数据源插入一条新的数据
- (void) roomViewController:(RoomViewController *)liveRoom
              didInsertRoom:(RoomModel *)room;
@end

@interface RoomViewController : UIViewController

@property (nonatomic ,weak) id<RoomViewControllerDelegate> delegate;

- (BOOL) roomIsLinkMic;
- (void) updateLiveRoom:(RoomModel *)room atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
