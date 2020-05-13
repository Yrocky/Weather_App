//
//  MMHomeItemComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent.h"

NS_ASSUME_NONNULL_BEGIN

@class MMHomeSectionComponent;
@protocol MMHomeItemComponentAble;

@interface MMHomeItemComponent : MMHomeComponent<MMHomeItemComponentAble>

@property (assign, nonatomic) CGSize size;

@property (nonatomic ,assign) NSInteger section;
@property (nonatomic ,assign) NSInteger item;

@property (nonatomic ,weak) MMHomeSectionComponent * sectionComponent;

@end

@protocol MMHomeItemComponentAble <NSObject>

// 注册cell
- (void)prepareCollectionView:(UICollectionView *)collectionView;

// 初始化cell
- (UICollectionViewCell *)cellForItemInCollectionView:(UICollectionView *)collectionView;

// 设置cell的size
- (CGSize)sizeForItemInCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout;

@end

NS_ASSUME_NONNULL_END
