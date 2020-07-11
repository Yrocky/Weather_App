//
//  MMHomeComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListSectionController.h>
#import "MMHomeSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat MMComponentAutomaticDimension;

@protocol MMHomeComponentAble <NSObject,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@optional

- (void) prepareCollectionView:(UICollectionView *)collectionView;

/// 当前comp是否为空
- (BOOL) empty;
//11654
/// 清空当前comp
- (void) clear;
@end

@interface MMHomeComponent : IGListSectionController<MMHomeComponentAble>

@property (strong ,nonatomic) __kindof MMHomeSectionModel * sectionModel;

@end

@interface MMHomeComponent(EmptyDataPlaceholder)

/// 是否使用占位视图
- (BOOL) useEmptyDataPlaceholder;

// 设置placeHold
- (CGSize) sizeForEmptyDataPlaceholder;

- (__kindof UICollectionViewCell *) cellForEmptyDataPlaceholder;

@end

NS_ASSUME_NONNULL_END
