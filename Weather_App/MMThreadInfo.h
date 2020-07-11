//
//  MMThreadInfo.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/26.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 一个用来记录线程的类，不是NSThread的wrap也不是其子类，用在log的打印中
@interface MMThreadInfo : NSObject

- (instancetype)initWithThreadID:(uint64_t)tid number:(NSUInteger)number name:(NSString *)name;

@property (nonatomic, assign, readonly ) uint64_t      tid;            ///< The globally unique thread ID.
@property (nonatomic, assign, readonly ) NSUInteger    number;         ///< The thread number inside this app.
@property (nonatomic, copy,   readonly ) NSString *    name;           ///< The name of the thread; will not be nil.

@end

NS_ASSUME_NONNULL_END
