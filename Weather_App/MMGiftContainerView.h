//
//  MMGiftContainerView.h
//  Weather_App
//
//  Created by user1 on 2017/9/8.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGiftEffectOperationMgr.h"

@protocol MMGiftViewDelegate <NSObject>
- (void) trackCallback;
@end
@interface MMGiftContainerView : UIView{
    
    __block NSMutableArray * _giftViews;
}

@property (nonatomic ,weak) id proxy;
@property (nonatomic ,strong ,readonly) NSArray * giftViews;

- (void)startTrack;
- (void)stopTrack;

- (void) receiveGift:(id)gift;
@end

@interface MMGiftView : UIView

@property (nonatomic ,weak) id<MMGiftViewDelegate> delegate;
@end

