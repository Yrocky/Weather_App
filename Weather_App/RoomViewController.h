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
@interface RoomViewController : UIViewController

@property (nonatomic ,copy) void(^bRemoveRoomInfo)(RoomModel *roomInfo);
@property (nonatomic ,copy) void(^bCloseRoom)(void);

- (void) updateLiveRoom:(RoomModel *)roomInfo atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
