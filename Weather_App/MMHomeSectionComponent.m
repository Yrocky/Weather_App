//
//  MMHomeSectionComponent.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeSectionComponent.h"
#import "MMHomeComponent+Private.h"

#define MMHomeValueWasAutomaticDimension(__value__)\
(__value__ == MMComponentAutomaticDimension || isnan(__value__))

@interface MMHomeSectionComponent ()

@end
@implementation MMHomeSectionComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        _minimumLineSpacing = MMComponentAutomaticDimension;
        _minimumInteritemSpacing = MMComponentAutomaticDimension;
        _inset = UIEdgeInsetsMake(MMComponentAutomaticDimension,
                                 MMComponentAutomaticDimension,
                                 MMComponentAutomaticDimension,
                                 MMComponentAutomaticDimension);
    }
    return self;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    [super setCollectionView:collectionView];
    self.headerComponent.collectionView = collectionView;
    self.footerComponent.collectionView = collectionView;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    if (self.collectionView) {
        [self.headerComponent prepareCollectionView];
        [self.footerComponent prepareCollectionView];
    }
}

- (NSInteger)numberOfItems{
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index{
    return CGSizeZero;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return MMHomeValueWasAutomaticDimension(_minimumLineSpacing) ?
    ((UICollectionViewFlowLayout *)collectionViewLayout).minimumLineSpacing : _minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return MMHomeValueWasAutomaticDimension(_minimumInteritemSpacing) ?
    ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing : _minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset;
    if (!MMHomeValueWasAutomaticDimension(self.inset.top)) {
        inset.top = self.inset.top;
    }
    if (!MMHomeValueWasAutomaticDimension(self.inset.left)) {
        inset.left = self.inset.left;
    }
    if (!MMHomeValueWasAutomaticDimension(self.inset.right)) {
        inset.right = self.inset.right;
    }
    if (!MMHomeValueWasAutomaticDimension(self.inset.bottom)) {
        inset.bottom = self.inset.bottom;
    }
    return inset;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MMHomeHeaderFooterComponent * comp = self.headerComponent;
        if ([comp respondsToSelector:_cmd]) {
            return [comp collectionView:collectionView
      viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        MMHomeHeaderFooterComponent * comp = self.footerComponent;
        if ([comp respondsToSelector:_cmd]) {
            return [comp collectionView:collectionView
      viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        }
    }
    NSAssert(false, @"%@ is nil!", kind);
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    MMHomeHeaderFooterComponent *comp = self.headerComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForHeaderInSection:section];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    MMHomeHeaderFooterComponent *comp = self.footerComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForFooterInSection:section];
    }
    return CGSizeZero;
}

@end

@implementation MMHomeHeaderFooterComponent

- (void)prepareCollectionView {
    [super prepareCollectionView];
    // 注册对应的 UICollectionReusableView
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        DDCollectionViewBaseComponent *comp = _headerComponent ?: _headerFooterComponent;
//        if ([comp respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
//            return [comp collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
//        }
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        DDCollectionViewBaseComponent *comp = _footerComponent ?: _headerFooterComponent;
//        if ([comp respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
//            return [comp collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
//        }
//    }
//    NSAssert(false, @"%@ is nil!", kind);
//    return nil;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    DDCollectionViewBaseComponent *comp = _headerComponent ?: _headerFooterComponent;
//    if ([comp respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
//        return [comp collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
//    }
//    return CGSizeZero;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    DDCollectionViewBaseComponent *comp = _footerComponent ?: _headerFooterComponent;
//    if ([comp respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
//        return [comp collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
//    }
//    return CGSizeZero;
//}

@end
