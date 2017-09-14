//
//  MMGiftEffectOperationMgr.h
//  Weather_App
//
//  Created by user1 on 2017/9/12.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMGiftModel : NSObject

@property (nonatomic ,assign) NSUInteger giftId;
@property (nonatomic ,copy) NSString * giftName;
@property (nonatomic ,assign) NSUInteger giftCount;

@property (nonatomic ,copy) NSString * userName;

@end

@interface MMGiftEffectOperation : NSObject

@property (nonatomic ,assign) CGFloat surviveTime;// 生存时间

@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end


@interface MMGiftEffectOperationMgr : NSObject{

    __block NSMutableArray <MMGiftEffectOperation *>* _operations;
    CADisplayLink * _link;
}

@property (nonatomic ,assign) CGFloat maxSurviveTime;

- (void) appendGiftModel:(MMGiftModel *)giftModel;

- (void) trackOperation;
@end
