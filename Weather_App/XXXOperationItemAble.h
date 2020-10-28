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

- (void) addItem:(XXXModel)item;
- (void) addItems:(NSArray<XXXModel> *)item;

- (void) insertItem:(XXXModel)item atIndex:(NSInteger)index;

- (void) deleteItem:(XXXModel)item;
- (void) deleteItemAtIndex:(NSInteger)index;

- (void) removeAllItems;

- (XXXModel) itemAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
