//
//  MMHomeItemComponent.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeItemComponent.h"

@implementation MMHomeItemComponent

// 注册cell
- (void)prepareCollectionView:(UICollectionView *)collectionView{
//    self.collectionView = collectionView;
    // 在这里注册cell
}

// 初始化cell
- (UICollectionViewCell *)cellForItemInCollectionView:(UICollectionView *)collectionView{
    return nil;
}

// 设置cell的size
- (CGSize)sizeForItemInCollectionView:(UICollectionView *)collectionView
                               layout:(UICollectionViewLayout *)collectionViewLayout{
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGSize size = self.size;
//    BOOL autoWidth = size.width == MMComponentAutomaticDimension;
//    BOOL autoHeight = size.height == MMComponentAutomaticDimension;
//    UIEdgeInsets inset = UIEdgeInsetsZero;
//    if (autoWidth || autoHeight) {
////        inset = [self.rootComponent collectionView:collectionView
////                                            layout:collectionViewLayout
////                            insetForSectionAtIndex:indexPath.section];
//    }
//    if (autoWidth) {
//        size.width = MAX(collectionView.frame.size.width - inset.left - inset.right, 0);
//    }
//    if (autoHeight) {
//        size.height = MAX(collectionView.frame.size.height - inset.top - inset.bottom, 0);
//    }
//    return size;
//}

@end
