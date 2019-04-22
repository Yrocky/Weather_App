//
//  RoomDataSourceHandler.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/3.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomModel;
@protocol RoomDataSourceHandler <NSObject>

@property (nonatomic ,assign ,readonly) BOOL canSlipCard;///<是否可以滑动卡片，多余一个的时候可以滑动

- (void) setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index;

///<删除指定的房间
- (void) removeRoom:(RoomModel *)room;///<由于还有主播已经关播，所以要移除这个数据
- (void) removeRooms:(NSArray <RoomModel *>*)rooms;///<移除已经关播的主播

///<在当前主播后面插入一条数据，并滚动到该数据处
- (void) insertNewRoom:(RoomModel *)newRoom;

///<替换当前直播间数据为新的直播间
- (void) updateWithNewRoom:(RoomModel *)newRoom;

///<是否允许滑动
- (void) allowScroll:(BOOL)allow;
@end

NS_ASSUME_NONNULL_END
