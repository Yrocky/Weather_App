//
//  MMHomeComponentAble.h
//  Weather_App
//
//  Created by skynet on 2020/5/13.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#ifndef MMHomeComponentAble_h
#define MMHomeComponentAble_h
#import <UIKit/UIKit.h>

@protocol MMHomeComponentAble2 <NSObject,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@optional

- (void) prepareCollectionView:(UICollectionView *)collectionView;

/// 当前comp是否为空
- (BOOL) empty;

/// 清空当前comp
- (void) clear;
@end

@protocol MMHomeSectionComponentAble <MMHomeComponentAble >

- (NSInteger)numberOfItems;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;
@end

#endif /* MMHomeComponentAble_h */
