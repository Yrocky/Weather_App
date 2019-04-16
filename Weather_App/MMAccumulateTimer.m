//
//  MMAccumulateTimer.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/15.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMAccumulateTimer.h"
#import "MMNoRetainTimer.h"

@interface MMAccumulateTimer ()
@property(retain, nonatomic) MMNoRetainTimer *timerForRecv;
@property(retain, nonatomic) MMNoRetainTimer *timerForShow;
@end

@implementation MMAccumulateTimer

- (instancetype)initWithMaxNums:(unsigned long long)maxNums
                       recvTime:(double)recvTime
                       showTime:(double)showTime
                       delegate:(id<MMAccumulateTimerDelegate>)delegate{
    self = [super init];
    if (self) {
        _maxNums = maxNums;
        _recvTime = recvTime;
        _showTime = showTime;
        self.delegate = delegate;
        
    }
    return self;
}

- (void)onTimer:(MMNoRetainTimer *)timer{
    if (self.timerForRecv == timer) {
        
    }
}

- (void)callBack{
    
}

- (void)accumulate:(id)arg1 force:(_Bool)arg2{
    
}

- (void)internalAccumulate:(id)arg1 force:(_Bool)arg2{
    
}

@end
