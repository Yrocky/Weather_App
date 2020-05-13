//
//  MMHomeStatusComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 用于展示具备不同状态的component，比如Loading、Error、Empty等等
@interface MMHomeStatusComponent : NSObject

@property (nonatomic ,assign) NSInteger section;

@property (copy, readonly, nonatomic, nullable) NSString *currentState;
@property (readonly, nonatomic, nullable) NSObject *currentComponent;

- (NSObject *_Nullable)componentForState:(NSString *_Nullable)state;
- (void)setComponent:(NSObject *_Nullable)comp forState:(NSString *_Nullable)state;

- (void) changeState:(NSString *_Nullable)state;

@end

NS_ASSUME_NONNULL_END
