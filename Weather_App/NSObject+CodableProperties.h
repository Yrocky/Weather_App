//
//  NSObject+CodableProperties.h
//  Weather_App
//
//  Created by user1 on 2017/10/19.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

// Original implementation by Nick Lockwood: https://github.com/nicklockwood/AutoCoding/blob/master/AutoCoding/AutoCoding.m
@interface NSObject (CodableProperties)

- (NSDictionary *)codableProperties;
@end

@interface NSObject (DebugTagName)

@property (nonatomic ,copy) NSString * debugTagName;
@end
