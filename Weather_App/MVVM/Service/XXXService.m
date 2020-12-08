//
//  XXXService.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXService.h"
#import "XXXResultSet.h"

@implementation XXXService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resultSet = [XXXResultSet new];
        _state = XXXServiceStateUnload;
    }
    return self;
}

- (void)loadMoreDataWithCompletion:(XXXServiceCompletionBlock)completion{
    // 子类重写，编写具体的网络请求
}

- (void)reloadDataWithCompletion:(XXXServiceCompletionBlock)completion{
    // 子类重写，编写具体的网络请求
}

@end
