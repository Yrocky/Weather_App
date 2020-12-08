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

// 一维集合的操作
@protocol XXXOperationSetItemAble <NSObject>

- (void) addItem:(XXXModel)item;
- (void) addItems:(NSArray<XXXModel> *)items;
- (void) insertItem:(XXXModel)item atIndex:(NSInteger)index;
- (void) deleteItem:(XXXModel)item;
- (void) deleteItemAtIndex:(NSInteger)index;
- (void) removeAllItems;
- (XXXModel) itemAtIndex:(NSInteger)index;

@end

// 二维集合的操作
@class XXXSection;
@protocol XXXOperationIndexPathItemAble <NSObject>

- (void) addSection:(XXXSection *)section;
- (void) addSections:(NSArray<XXXSection *> *)sections;
- (void) insertSection:(XXXSection *)section atIndex:(NSInteger)index;
- (void) deleteSectionAtIndex:(NSInteger)index;
- (void) removeAllItems;
- (XXXSection *) sectionAtIndex:(NSInteger)index;

- (void) addItem:(XXXModel)item forSection:(NSInteger)section;
- (void) addItems:(NSArray<XXXModel> *)items forSection:(NSInteger)section;
- (void) insertItem:(XXXModel)item atIndexPath:(NSIndexPath *)indexPath;
- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (void) removeAllItemsForSection:(NSInteger)section;
- (XXXModel) itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
