//
//  MMHomeComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

@interface MMHomeComponent : NSObject<MMHomeComponentAble>

@property (readonly, weak, nonatomic, nullable) UICollectionView *collectionView;

@property (nonatomic ,assign) BOOL cacheEnable;

- (void)prepareCollectionView NS_REQUIRES_SUPER;

/// comp在collectionView中的位置
@property (nonatomic ,assign) NSInteger section;
@property (nonatomic ,assign) NSInteger item;

- (NSInteger)firstItemOfSubComponent:(id<MMHomeComponentAble>)subComp;
- (NSInteger)firstSectionOfSubComponent:(id<MMHomeComponentAble>)subComp;

@end


NS_ASSUME_NONNULL_END
