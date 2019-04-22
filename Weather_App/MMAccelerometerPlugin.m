//
//  MMAccelerometerPlugin.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "MMAccelerometerPlugin.h"
#import <CoreMotion/CoreMotion.h>

@interface MMAccelerometerPlugin ()
@property (nonatomic ,assign) BOOL isRunning;
@property (nonatomic ,strong) CMMotionManager * motionManager;
@property (nonatomic ,assign) NSTimeInterval kAccelerometerInterval;
@property (nonatomic ,assign) double kGravitationalConstant;
@end

@implementation MMAccelerometerPlugin

- (instancetype)init{
    self = [super init];
    if (self) {
        self.kAccelerometerInterval = 10;
        self.kGravitationalConstant = -9.81;
    }
    return self;
}
- (void) getCurrentAcceleration{
    if (nil == self.motionManager) {
        self.motionManager = [CMMotionManager new];
    }
    
    if (self.motionManager.isAccelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = self.kAccelerometerInterval / 1000.0f;
        [self.motionManager startAccelerometerUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            NSDictionary * data = @{@"x" : @(accelerometerData.acceleration.x * self.kGravitationalConstant),
                                    @"y" : @(accelerometerData.acceleration.y * self.kGravitationalConstant),
                                    @"z" : @(accelerometerData.acceleration.z * self.kGravitationalConstant),
                                    @"timestamp" : @([NSDate date].timeIntervalSince1970),
                                    };
            if ([self callback:data]) {
                [self.motionManager stopAccelerometerUpdates];
            }
        }];
        if (!self.isRunning) {
            self.isRunning = YES;
        }
    } else {
        [self errorCallback:@"accelerometer not available!"];
    }
}
@end
