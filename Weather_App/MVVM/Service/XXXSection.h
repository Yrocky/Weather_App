//
//  XXXSection.h
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXOperationItemAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXSection : NSObject<XXXOperationSetItemAble>

@property (nonatomic ,copy ,readonly) NSArray<XXXModel> * list;

@end

// 为Section提供的下标访问功能，外部不允许直接调用
@interface XXXSection (Subscript)

- (void) setObject:(XXXModel)anObject atIndexedSubscript:(NSUInteger)index;
- (XXXModel) objectAtIndexedSubscript:(NSUInteger)idx;
@end
NS_ASSUME_NONNULL_END
