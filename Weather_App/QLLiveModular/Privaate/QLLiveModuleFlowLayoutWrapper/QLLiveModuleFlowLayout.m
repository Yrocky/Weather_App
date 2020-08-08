//
//  QLLiveModuleFlowLayout.m
//  Weather_App
//
//  Created by rocky on 2020/8/8.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveModuleFlowLayout.h"

@interface QLLiveModuleFlowLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *itemHeights;

/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> * allItemAttributes;
/// Array of arrays. Each array stores item attributes for each section
@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *sectionItemAttributes;
/// Dictionary to store section headers' attribute
@property (nonatomic, strong) NSMutableDictionary *headersAttribute;
/// Dictionary to store section footers' attribute
@property (nonatomic, strong) NSMutableDictionary *footersAttribute;
/// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *unionRects;
@end

@implementation QLLiveModuleFlowLayout

/// How many items to be union into a single rectangle
static const NSInteger unionSize = 20;

static CGFloat QLLiveFloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}


#pragma mark - override

- (void)prepareLayout {
    [super prepareLayout];

    // clear datas
    [self.unionRects removeAllObjects];
    [self.columnHeights removeAllObjects];
    [self.itemHeights removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.headersAttribute removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.footersAttribute removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        // for safe
        return;
    }
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        // 水平
    } else {
        // 垂直
        NSInteger idx = 0;
        CGFloat top = 0;
        UICollectionViewLayoutAttributes *attributes;
        
        for (NSInteger section = 0; section < numberOfSections; ++section) {
    
            CGFloat minimumInteritemSpacing = [self fetchMinimumInteritemSpacingAt:section];
            CGFloat minimumLineSpacing = [self fetchMinimumLineSpacingAt:section];
            
            UIEdgeInsets sectionInset = [self fetchSectionInsetAt:section];
            CGFloat sectionContainerMaxX = collectionViewWidth - sectionInset.right;
            
            if (section == 1) {
                
            }
            
            // 1.header
            CGFloat headerHeight = [self fetchSectionHeaderAt:section];
            
            if (headerHeight > 0) {
                UIEdgeInsets headerInset = [self fetchSectionHeaderInsetAt:section];
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = (CGRect){
                    headerInset.left,
                    headerInset.top + top,
                    collectionViewWidth - (headerInset.left + headerInset.right),
                    headerHeight
                };
                
                self.headersAttribute[@(section)] = attributes;
                [self.allItemAttributes addObject:attributes];
                
                // 更新top，如果有设置sectionHeader的高度
                top = CGRectGetMaxY(attributes.frame) + headerInset.bottom;
            }
            
            top += sectionInset.top;
            
            // 2.items
            
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            NSMutableArray<UICollectionViewLayoutAttributes *> *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
            NSMutableArray<NSMutableArray<NSValue *> *> * lines = [NSMutableArray new];

            NSMutableArray<NSValue *> * line = [NSMutableArray array];
            [lines addObject:line];

            BOOL needShift = NO;
            for (idx = 0; idx < itemCount; idx++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
                CGSize itemSize = [self fetchItemSizeAt:indexPath];
                
                CGFloat xOffset = 0;
                CGFloat yOffset = 0;
                if (idx == 0) {
                    xOffset = sectionInset.left;
                    yOffset = top;
                } else {
                    // 上一个att的
                    UICollectionViewLayoutAttributes * preAtt = itemAttributes[idx - 1];
                    
                    xOffset = CGRectGetMaxX(preAtt.frame) + minimumInteritemSpacing;
                    needShift = (xOffset + itemSize.width) > sectionContainerMaxX;
                    
                    if (needShift) {
                    
                        NSArray<NSValue *> * preLine = lines.lastObject;

                        line = [NSMutableArray array];
                        [lines addObject:line];
                        
                        // 需要换行，放入下一行，更新xOffset
                        
                        // 在高度不相等的时候，需要在preLine中找最大x值
                        __block BOOL allItemHeightWasEqual = YES;
                        __block CGFloat longestX = 0;
                        __block CGFloat longestHeight = 0;
                        CGFloat firstItemHeight = CGRectGetHeight(preLine.firstObject.CGRectValue);
                        
                        // 找出来高度最大的那个index下的cell的最大x
                        [preLine enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            CGFloat height = CGRectGetHeight(obj.CGRectValue);
                            if (height > longestHeight) {
                                longestHeight = height;
                                longestX = CGRectGetMaxX(obj.CGRectValue);
                            }
                            if (firstItemHeight != CGRectGetHeight(obj.CGRectValue)) {
                                allItemHeightWasEqual = NO;
                            }
                        }];
                        if (allItemHeightWasEqual) {
                            xOffset = sectionInset.left;
                        } else {
                            xOffset = longestX + minimumInteritemSpacing;
                        }
                        
                        if (1) {
                            // 需要确定上一行中最短的
                            yOffset = [self shortestHeightItemAtLine:preLine] + minimumLineSpacing;
                        } else {
                            // 找上一行第一个的最大y
                            yOffset = CGRectGetMaxY(preLine.firstObject.CGRectValue) + minimumLineSpacing;
                        }
                    } else {
                        // 不需要换行
                        if (lines.count == 1) {
                            // 是第一行
                            yOffset = CGRectGetMinY(preAtt.frame);
                        } else {
                            // 不是第一行
                            NSArray<NSValue *> *
                            preLine = lines[lines.count - 2];
                            
                            if (1) {
                                // 需要确定上一行中最短的
                                yOffset = [self shortestHeightItemAtLine:preLine] + minimumLineSpacing;
                            } else {
                                // 找上一行第一个的最大y
                                yOffset = CGRectGetMaxY(preLine.firstObject.CGRectValue) + minimumLineSpacing;
                            }
                        }
                    }
                }

                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = (CGRect){
                    xOffset, yOffset,
                    (CGSize)itemSize
                };
                NSLog(@"%d itemSize:%@",idx,NSStringFromCGRect(attributes.frame));
                
                [line addObject:[NSValue valueWithCGRect:attributes.frame]];
                [itemAttributes addObject:attributes];
                [self.allItemAttributes addObject:attributes];
            }// end for-on cells
            
            // 更新top，取出来最后一行最长的cell
            top = [self longestHeightItemAtLine:lines.lastObject];
            
            [self.sectionItemAttributes addObject:itemAttributes];
            
            // 3.footer
            CGFloat footerHeight = [self fetchSectionFooterAt:section];
            if (footerHeight > 0) {
                UIEdgeInsets footerInset = [self fetchSectionFooterInsetAt:section];
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                attributes.frame = (CGRect){
                    footerInset.left,
                    footerInset.top + top,
                    collectionViewWidth - (footerInset.left + footerInset.right),
                    footerHeight
                };
                self.footersAttribute[@(section)] = attributes;
                [self.allItemAttributes addObject:attributes];
                
                top = CGRectGetMaxY(attributes.frame) + footerInset.bottom;
            }
            
            top += sectionInset.bottom;
            
            NSLog(@"[%d] header :%f maxY is:%f footer :%f",headerHeight,section,top,footerHeight);
        }
    }
    
    // Build union rects
    NSInteger idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);

        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }

        idx = rectEndIndex;

        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentSize.height = CGRectGetMaxY(self.allItemAttributes.lastObject.frame);
    } else {
        contentSize.width = CGRectGetMaxX(self.allItemAttributes.lastObject.frame);
    }
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = self.headersAttribute[@(indexPath.section)];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        attribute = self.footersAttribute[@(indexPath.section)];
    }
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplHeaderAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *supplFooterAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            switch (attr.representedElementCategory) {
                case UICollectionElementCategorySupplementaryView:
                    if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                        supplHeaderAttrDict[attr.indexPath] = attr;
                    } else if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                        supplFooterAttrDict[attr.indexPath] = attr;
                    }
                    break;
                case UICollectionElementCategoryDecorationView:
                    decorAttrDict[attr.indexPath] = attr;
                    break;
                case UICollectionElementCategoryCell:
                    cellAttrDict[attr.indexPath] = attr;
                    break;
            }
        }
    }
    
    NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:supplHeaderAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:supplFooterAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (CGFloat) fetchMinimumInteritemSpacingAt:(NSInteger)sectionIdx{
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIdx];
    }
    return minimumInteritemSpacing;
}

- (CGFloat) fetchMinimumLineSpacingAt:(NSInteger)sectionIdx{
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:sectionIdx];
    }
    return minimumLineSpacing;
}

- (UIEdgeInsets) fetchSectionInsetAt:(NSInteger)sectionIdx{
    UIEdgeInsets sectionInset = self.sectionInset;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:sectionIdx];
    }
    return sectionInset;
}

- (CGFloat) fetchSectionHeaderAt:(NSInteger)sectionIdx{
    CGFloat headerHeight = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
        headerHeight = [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:sectionIdx];
    }
    return headerHeight;
}

- (UIEdgeInsets) fetchSectionHeaderInsetAt:(NSInteger)sectionIdx{
    UIEdgeInsets headerInset = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForHeaderInSection:)]) {
        headerInset = [self.delegate collectionView:self.collectionView layout:self insetForHeaderInSection:sectionIdx];
    }
    return headerInset;
}

- (CGSize) fetchItemSizeAt:(NSIndexPath *)indexPath{
    CGSize itemSize = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)] &&
        indexPath) {
        itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return itemSize;
}

- (CGFloat) fetchSectionFooterAt:(NSInteger)sectionIdx{
    CGFloat footerHeight = 0;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
        footerHeight = [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:sectionIdx];
    }
    return footerHeight;
}

- (UIEdgeInsets) fetchSectionFooterInsetAt:(NSInteger)sectionIdx{
    UIEdgeInsets footerInset = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForFooterInSection:)]) {
        footerInset = [self.delegate collectionView:self.collectionView layout:self insetForFooterInSection:sectionIdx];
    }
    return footerInset;
}
/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */
// 一行中最短的
- (CGFloat) shortestHeightItemAtLine:(NSArray<NSValue *> *)line{
    __block CGFloat shortest = MAXFLOAT;
    [line enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat maxY = CGRectGetMaxY(obj.CGRectValue);
        if (maxY < shortest) {
            shortest = maxY;
        }
    }];
    return shortest;
}

// 一行最长的
- (CGFloat) longestHeightItemAtLine:(NSArray<NSValue *> *)line{
    __block CGFloat longestHeight = 0;
    [line enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat maxY = CGRectGetMaxY(obj.CGRectValue);
        if (maxY > longestHeight) {
            longestHeight = maxY;
        }
    }];
    return longestHeight;
}

/**
 *  Find the index for the next column.
 *
 *  @return index for the next column
 */
- (NSUInteger)nextColumnIndexForItem:(NSInteger)item inSection:(NSInteger)section {
    NSUInteger index = 0;
//    NSInteger columnCount = [self columnCountForSection:section];
//    switch (self.itemRenderDirection) {
//        case CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst:
//            index = [self shortestColumnIndexInSection:section];
//            break;
//
//        case CHTCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight:
//            index = (item % columnCount);
//            break;
//
//        case CHTCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft:
//            index = (columnCount - 1) - (item % columnCount);
//            break;
//
//        default:
//            index = [self shortestColumnIndexInSection:section];
//            break;
//    }
    return index;
}
#pragma mark - Private Accessors

- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)itemHeights {
    if (!_itemHeights) {
        _itemHeights = [NSMutableArray array];
    }
    return _itemHeights;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (NSMutableDictionary *)headersAttribute {
    if (!_headersAttribute) {
        _headersAttribute = [NSMutableDictionary dictionary];
    }
    return _headersAttribute;
}

- (NSMutableDictionary *)footersAttribute {
    if (!_footersAttribute) {
        _footersAttribute = [NSMutableDictionary dictionary];
    }
    return _footersAttribute;
}

- (id <QLLiveModuleFlowLayout> )delegate {
    return (id <QLLiveModuleFlowLayout> )self.collectionView.delegate;
}
@end
