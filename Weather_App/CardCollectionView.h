//
//  CardCollectionView.h
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomDataSourceHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class RoomModel;
@class CardCollectionView;
@protocol CardCollectionViewDelegate <NSObject>

///<通知控制器添加直播间试图
- (__kindof UIView *)cardCollectionViewShouldAddLiveView:(CardCollectionView *)view;

@optional

///<在carView滚动前进行询问外部，是否可以滚动，主要使用场景为直播间连麦中，需要提示用户连麦会关闭
- (BOOL) cardCollectionViewShouldScroll:(CardCollectionView *)view;

///<将要切换直播间
- (void) cardCollectionView:(CardCollectionView *)view
        willStartToggleRoom:(RoomModel *)room;
///<切换直播间
- (void) cardCollectionView:(CardCollectionView *)view
              didToggleRoom:(RoomModel *)room atIndex:(NSUInteger)index;
///<完成切换直播间
- (void) cardCollectionView:(CardCollectionView *)view
        didFinishToggleRoom:(RoomModel *)room;
@end

@interface CardCollectionView : UIView<RoomDataSourceHandler>

@property (nonatomic ,weak) id<CardCollectionViewDelegate> delegate;
@property (nonatomic ,assign ,readonly) BOOL canSlipCard;///<是否可以滑动卡片，多余一个的时候可以滑动

@end


NS_ASSUME_NONNULL_END
