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

@interface NSObject (MMRuntime)
+ (NSArray<NSString *> *) mm_getAllProperties;
- (NSArray<NSString *> *) mm_getAllProperties;

+ (NSArray<NSString *> *) mm_getAllMethods;
- (NSArray<NSString *> *) mm_getAllMethods;

+ (BOOL) mm_implementationMethod:(SEL)method;
- (BOOL) mm_implementationMethod:(SEL)method;

+ (BOOL) mm_implementationMethodWith:(NSString *)methodName;
- (BOOL) mm_implementationMethodWith:(NSString *)methodName;
@end
