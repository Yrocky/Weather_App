//
//  MMAccumulateTimer.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/15.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMAccumulateTimerDelegate <NSObject>

- (void)onAccumulateTimer:(NSArray *)arg1;

@end

// 可以累积的计时器
@interface MMAccumulateTimer : NSObject{
    unsigned long long _maxNums;
    double _recvTime;
    double _showTime;
    NSMutableArray *_accumulateArray;
}

@property (nonatomic ,weak) id<MMAccumulateTimerDelegate> delegate;

@property (nonatomic ,assign ,readonly) unsigned long long maxNums;

@property(retain, nonatomic) NSMutableArray *accumulateArray; // @synthesize accumulateArray=_accumulateArray;
@property(nonatomic ,assign ,readonly) double showTime;
@property(nonatomic ,assign ,readonly) double recvTime;

- (void)internalAccumulate:(id)arg1 force:(_Bool)arg2;
- (void)accumulate:(id)arg1 force:(_Bool)arg2;
- (instancetype)initWithMaxNums:(unsigned long long)maxNums
                       recvTime:(double)recvTime
                       showTime:(double)showTime
                       delegate:(id<MMAccumulateTimerDelegate>)delegate;
- (void)callBack;

@end

NS_ASSUME_NONNULL_END
