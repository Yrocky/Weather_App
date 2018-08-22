//
//  MMSingleton.m
//  Weather_App
//
//  Created by user1 on 2018/8/14.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMSingleton.h"

static MMSingleton * instance = nil;

@implementation MMSingleton

- (instancetype)initInstance {
    self.name = @"MMSingleton-initInstance";
    self.dictMShape = [NSMutableDictionary dictionary];
    return [super init];
}

- (instancetype)init{
//    [NSException raise:@"SingletonPattern"
//                format:@"不允许调用init来初始化，请使用mgr方法来初始化."];
    return nil;
}

+ (instancetype)mgr{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initInstance];
    });
    return instance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(instance == nil){
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

- (id)copy{
    return self;
}

- (id)mutableCopy{
    return self;
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"self:%p , name:%@",self,self.name];
}
- (NSString *)description{
    return [self debugDescription];
}
@end

@implementation MMSubSingleton

+ (instancetype)mgr
{
    static id _instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] initInstance];
    });
    return _instance;
}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.name = @"MMSubSingleton";
//    }
//    return self;
//}
@end
