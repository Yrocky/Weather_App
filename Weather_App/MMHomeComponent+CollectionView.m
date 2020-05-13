//
//  MMHomeComponent+CollectionView.m
//  Weather_App
//
//  Created by skynet on 2020/5/13.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent+CollectionView.h"
#import "MMHomeComponent+Private.h"

@implementation MMHomeComponent (CollectionView)

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.currentComponent numberOfSectionsInCollectionView:collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.currentComponent collectionView:collectionView numberOfItemsInSection:section];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.currentComponent collectionView:collectionView cellForItemAtIndexPath:indexPath];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.currentComponent collectionView:collectionView
               viewForSupplementaryElementOfKind:kind
                                     atIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                      shouldHighlightItemAtIndexPath:indexPath];
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                  didHighlightItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                didUnhighlightItemAtIndexPath:indexPath];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                         shouldSelectItemAtIndexPath:indexPath];
    }
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                       shouldDeselectItemAtIndexPath:indexPath];
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                     didSelectItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                              willDisplayCell:cell
                           forItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                         didEndDisplayingCell:cell
                           forItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
                 willDisplaySupplementaryView:view
                               forElementKind:elementKind atIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        [self.currentComponent collectionView:collectionView
            didEndDisplayingSupplementaryView:view
                             forElementOfKind:elementKind atIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
                              sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
                     referenceSizeForFooterInSection:section];
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
                     referenceSizeForHeaderInSection:section];
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
                              insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
                 minimumLineSpacingForSectionAtIndex:section];
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.currentComponent respondsToSelector:_cmd]) {
        return [self.currentComponent collectionView:collectionView
                                              layout:collectionViewLayout
            minimumInteritemSpacingForSectionAtIndex:section];
    }
    return 0;
}

@end
