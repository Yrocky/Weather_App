//
//  MMStack.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/28.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMStack<T> : NSObject
- (void)push:(T)value;
- (T)pop;
- (T)peekStack:(NSUInteger)index;
- (void)shrinkStack:(NSUInteger)shrinkSize;
- (NSUInteger)size;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
