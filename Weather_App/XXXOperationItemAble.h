//
//  XXXOperationItemAble.h
//  Weather_App
//
//  Created by rocky on 2020/10/26.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXModelAble.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XXXOperationItemAble <NSObject>

- (void) addItem:(id<XXXModelAble>)item;
- (void) addItems:(NSArray<id<XXXModelAble>> *)item;

- (void) insertItem:(id<XXXModelAble>)item atIndex:(NSInteger)index;

- (void) deleteItem:(id<XXXModelAble>)item;

- (void) removeAllItems;
@end

NS_ASSUME_NONNULL_END
