//
//  XXXContext.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXContext.h"

@implementation XXXContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vars = [NSMutableDictionary new];
    }
    return self;
}

- (void)addVar:(NSString *)var forKey:(NSString *)key{
    NSAssert(nil != var, @"var is null");
    NSAssert(nil != key, @"key is null");
    key = [NSString stringWithFormat:@"var:%@",key];
    if (![_vars.allKeys containsObject:key]) {
        @synchronized (_vars) {
            _vars[key] = var;
        }
    }
}

- (NSString *) varWithKey:(NSString *)key{
    NSAssert(nil != key, @"key is null");
    @synchronized (_vars) {
        key = [NSString stringWithFormat:@"var:%@",key];
        return _vars[key];
    }
}

- (NSDictionary *)variables{
    return _vars.copy;
}

- (void) clear{
    @synchronized (_vars) {    
        [_vars removeAllObjects];
    }
}
@end

