//
//  CardCollectionView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomModel;
@class CardCollectionView;

@protocol CardCollectionViewDelegate <NSObject>

- (__kindof UIView *)cardCollectionViewShouldAddLiveView:(CardCollectionView *)view;///<通知控制器添加直播间试图

@optional

///<在carView滚动前进行询问外部，是否可以滚动，主要使用场景为直播间连麦中，需要提示用户连麦会关闭
- (BOOL) cardCollectionViewShouldScroll:(CardCollectionView *)view;

- (void) cardCollectionView:(CardCollectionView *)view willStartToggleRoom:(RoomModel *)roomInfo;///<将要切换直播间
- (void) cardCollectionView:(CardCollectionView *)view didToggleRoom:(RoomModel *)roomInfo;///<切换直播间
- (void) cardCollectionView:(CardCollectionView *)view didToggleRoom:(RoomModel *)roomInfo atIndex:(NSUInteger)index;
- (void) cardCollectionView:(CardCollectionView *)view didFinishToggleRoom:(RoomModel *)roomInfo;///<完成切换直播间
@end

@interface CardCollectionView : UIView

@property (nonatomic ,weak) id<CardCollectionViewDelegate> delegate;

- (void) setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index;

///<删除制定的房间
- (void) removeRoomWithRoomId:(NSUInteger)roomId;///<由于还有主播已经关播，所有要移除这个数据
- (void) removeRoomWithRoomIds:(NSArray <NSNumber *>*)roomIds;///<移除已经关播的主播

///<在当前主播后面插入一条数据，并滚动到该数据处
- (void) insertRoomWithRoomInfo:(RoomModel *)roomInfo;

///<替换当前直播间数据为新的直播间
- (void) updateCurrentRoomWithRoomInfo:(RoomModel *)roomInfo;

- (void) reloadData;

///<是否允许滑动
- (void) allowScroll:(BOOL)allow;
@end


NS_ASSUME_NONNULL_END
