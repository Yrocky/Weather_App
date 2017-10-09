//
//  NSUserDefaults+MM_Common.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MM_UserDefaults [NSUserDefaults standardUserDefaults]

@interface NSUserDefaults (MM_Common)

- (NSUserDefaults *(^)(NSString *key,BOOL value))mm_addBool;
- (BOOL(^)(NSString *))mm_boolValue;

- (NSUserDefaults *(^)(NSString *key,NSInteger value))mm_addInt;
- (NSInteger(^)(NSString *))mm_intValue;

- (NSUserDefaults *(^)(NSString *key,NSString *value))mm_addString;
- (NSString *(^)(NSString *))mm_stringValue;

- (NSUserDefaults *(^)(NSString *key,id value))mm_addObject;
- (id(^)(NSString *))mm_objectValue;

@end
