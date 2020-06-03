//
//  MMHomeComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListSectionController.h>

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


@end


NS_ASSUME_NONNULL_END
