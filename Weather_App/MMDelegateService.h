//
//  MMDelegateService.h
//  Weather_App
//
//  Created by user1 on 2018/8/13.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

///<模拟多代理
@interface MMDelegateService : NSProxy

@property (nonatomic ,strong ,readonly) NSArray * delegates;

- (instancetype) initWithDelegates:(NSArray *)delegates;

- (void) addDelegate:(id)delegate;
- (void) removeDelegate:(id)delegate;
@end
