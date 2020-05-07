//
//  XXXElevator.h
//  Weather_App
//
//  Created by skynet on 2019/12/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 电梯具备四种动作
@protocol XXXElevatorBehavior <NSObject>

// 操作
- (void) open;
- (void) close;
- (void) run;
- (void) stop;

@end

@interface XXXElevator : NSObject<XXXElevatorBehavior>

@end

NS_ASSUME_NONNULL_END
