//
//  MMGiftContainerView.h
//  Weather_App
//
//  Created by user1 on 2017/9/8.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMGiftModel : NSObject

@property (nonatomic ,assign) NSUInteger giftId;
@property (nonatomic ,copy) NSString * giftName;
@end

@interface MMGiftContainerView : UIView{
    
    __block NSMutableArray * _giftViews;
}

@property (nonatomic ,strong ,readonly) NSArray * giftViews;

- (void) receiveGift:(id)gift;
@end

@interface MMGiftView : UIView


@end

