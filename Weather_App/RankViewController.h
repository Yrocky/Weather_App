//
//  RankViewController.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/2.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomModel;
@class RankViewController;
@protocol RankViewControllerDelegate <NSObject>

- (void) rankViewController:(RankViewController *)rank didSelectedRoom:(RoomModel *)room;

@end
@interface RankViewController : UIViewController

@property (nonatomic ,weak) id<RankViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
