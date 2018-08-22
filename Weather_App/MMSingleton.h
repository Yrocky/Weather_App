//
//  MMSingleton.h
//  Weather_App
//
//  Created by user1 on 2018/8/14.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSingleton : NSObject

@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,strong) NSMutableDictionary *dictMShape;
+ (instancetype)mgr;
@end


@interface MMSubSingleton : MMSingleton

@end
