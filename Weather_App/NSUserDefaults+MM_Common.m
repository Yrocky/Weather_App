//
//  NSUserDefaults+MM_Common.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "NSUserDefaults+MM_Common.h"

@implementation NSUserDefaults (MM_Common)

- (NSUserDefaults *(^)(NSString *,BOOL))mm_addBool{
    
    return ^NSUserDefaults *(NSString *key,BOOL value){
        return self.mm_addObject(key,@(value));
    };
}
- (BOOL(^)(NSString *))mm_boolValue{
    
    return ^BOOL(NSString *key){
        return [self.mm_objectValue(key) boolValue];
    };
}

- (NSUserDefaults *(^)(NSString *,NSInteger))mm_addInt{
    
    return ^NSUserDefaults *(NSString *key,NSInteger value){
        return self.mm_addObject(key,@(value));
    };
}
- (NSInteger(^)(NSString *))mm_intValue{
    
    return ^NSInteger(NSString *key){
        return [self.mm_objectValue(key) integerValue];
    };
}

- (NSUserDefaults *(^)(NSString *,NSString *))mm_addString{
    
    return self.mm_addObject;
}
- (NSString *(^)(NSString *))mm_stringValue{
    
    return self.mm_objectValue;
}

- (NSUserDefaults *(^)(NSString *,id))mm_addObject{
    
    return ^NSUserDefaults *(NSString *key,id value){
        [self setValue:value forKey:key];
        [self synchronize];
        return self;
    };
}
- (id(^)(NSString *))mm_objectValue{
    return ^id(NSString *key){
        return [self valueForKey:key];
    };
}
@end
