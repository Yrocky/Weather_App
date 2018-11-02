//
//  MMSearchDefaultCollectionView.m
//  memezhibo
//
//  Created by user1 on 2017/7/12.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import "MMSearchDefaultCollectionView.h"
#import "MMSearchReusableView.h"
#import "UIColor+Common.h"
#import <objc/runtime.h>
#import "NSArray+Sugar.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface NSIndexPath (Linenumber)

@property (nonatomic ,assign) NSUInteger linenumber;

@end

NSString * const kSearchHistoryDatasIdentifier = @"kSearchHistoryDatasIdentifier-1";

@interface MM_SearchDefaultCollectionView (){
    struct{
        unsigned int didCleanSearchHistory : 1;
        unsigned int didSelectItemAtIndexPath : 1;
    } _delegateFlags;
}
@property (readwrite) MM_SearchDefaultLayoutDelegate * layoutDelegate;

@end

@implementation MM_SearchDefaultCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layoutDelegate = [[MM_SearchDefaultLayoutDelegate alloc] init];
        
        self.alwaysBounceVertical = YES;
        
        __weak typeof(self) weakSelf = self;
        self.layoutDelegate.bCollectionViewDidSelectAt = ^(NSIndexPath *indexPath) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.handleDelegate && [strongSelf.handleDelegate respondsToSelector:@selector(searchDefaultCollectionView:didSelectItemAtIndexPath:)]) {
                [strongSelf.handleDelegate searchDefaultCollectionView:strongSelf didSelectItemAtIndexPath:indexPath];
            }
        };
        
        // 搜索历史
        MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = [[MM_SearchDefaultSectionLayoutAttribute alloc] init];
        sectionAttribute.regularSizeForItem = YES;
        sectionAttribute.minimumInteritemSpacing = 10;
        sectionAttribute.insetForSection = UIEdgeInsetsMake(6, 12, 12, 12);
        sectionAttribute.sizeForHeader = CGSizeMake(kScreenWidth, 42);
        sectionAttribute.sizeForFooter = CGSizeZero;
        [self.layoutDelegate addSectionAttribute:sectionAttribute];
        
        // 标签
        sectionAttribute = [[MM_SearchDefaultSectionLayoutAttribute alloc] init];
        sectionAttribute.regularSizeForItem = YES;
//        sectionAttribute.open = YES;
        sectionAttribute.normalLinenumber = 1;
        sectionAttribute.minimumInteritemSpacing = 10;
        sectionAttribute.insetForSection = UIEdgeInsetsMake(6, 12, 12, 12);
        sectionAttribute.sizeForHeader = CGSizeMake(kScreenWidth, 42);
        sectionAttribute.sizeForFooter = CGSizeZero;
        [self.layoutDelegate addSectionAttribute:sectionAttribute];
        
        // 热门推荐
        sectionAttribute = [[MM_SearchDefaultSectionLayoutAttribute alloc] init];
        sectionAttribute.sizeForHeader = CGSizeMake(kScreenWidth, 30);
        sectionAttribute.sizeForFooter = CGSizeZero;
        sectionAttribute.insetForSection = UIEdgeInsetsMake(12, 12, 12, 12);
        [self.layoutDelegate addSectionAttribute:sectionAttribute];
        
        self.dataSource = self;
        self.delegate = self.layoutDelegate;
        
        [self registerClass:[MMTagCollectionViewCell class]
 forCellWithReuseIdentifier:@"tagCellIdentifier"];
        
        [self registerClass:[MM_SearchHeaderView class]
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:kSearchHeaderViewIdentifier];
        
        [self registerClass:[MM_SearchFooterView class]
 forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
        withReuseIdentifier:kSearchFooterViewIdentifier];
    }
    return self;
}

- (void)reloadData{
    
    [super reloadData];
    
    [self.layoutDelegate.layoutAttributes mm_eachWithIndex:^(MM_SearchDefaultSectionLayoutAttribute * s_att, NSInteger s) {
        
        [s_att.rowAttributes mm_eachWithIndex:^(MM_SearchDefaultRowLayoutAttribute * r_att, NSInteger r) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:r inSection:s];
            UICollectionViewLayoutAttributes * att = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            r_att.linenumber = att.indexPath.linenumber;
        }];
    }];
}

- (void)reloadSections:(NSIndexSet *)sections{
    
    [self.layoutDelegate.layoutAttributes mm_each:^(MM_SearchDefaultSectionLayoutAttribute * s_att) {
        [s_att modifySectionLayoutAttributesBeforeReloadData];
    }];
    [super reloadSections:sections];
}

- (void)setHandleDelegate:(id<MMSearchDefaultCollectionViewDelegate>)handleDelegate{

    _handleDelegate = handleDelegate;
    _delegateFlags.didCleanSearchHistory = [handleDelegate respondsToSelector:@selector(searchDefaultCollectionViewDidCleanSearchHistory:)];
    _delegateFlags.didSelectItemAtIndexPath = [handleDelegate respondsToSelector:@selector(searchDefaultCollectionView:didSelectItemAtIndexPath:)];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.layoutDelegate.layoutAttributes.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = self.layoutDelegate.layoutAttributes[section];
    return sectionAttribute.rowAttributes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = self.layoutDelegate.layoutAttributes[indexPath.section];
    
    MM_SearchDefaultRowLayoutAttribute * rowAttribute = sectionAttribute.rowAttributes[indexPath.row];
    
    if (indexPath.section == 0) {
        MMTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentifier" forIndexPath:indexPath];
        cell.contentView.layer.borderColor = [UIColor colorWithHexString:@"#F3F4F6"].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#ABB3CA"];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F6"];
        cell.titleLabel.text = rowAttribute.rowData;
        return cell;
    }
    if (indexPath.section == 1) {
        MMTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentifier" forIndexPath:indexPath];
        cell.contentView.layer.borderColor = [UIColor colorWithHexString:@"#5432EB"].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#5432EB"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = rowAttribute.rowData;
        return cell;
    }
    if (indexPath.section == 2) {
        
        MMTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCellIdentifier" forIndexPath:indexPath];
        cell.contentView.layer.borderColor = [UIColor colorWithHexString:@"#5432EB"].CGColor;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#5432EB"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = rowAttribute.rowData;
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview;
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section==0) {
            MM_SearchHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSearchHeaderViewIdentifier forIndexPath:indexPath];
            headerView.titleLabel.text = @"搜索历史";
            headerView.handleButton.hidden = NO;
            [headerView setHandleText:@"清空"];
            [headerView.handleButton addTarget:self action:@selector(cleanHistorySearchHandle:) forControlEvents:UIControlEventTouchUpInside];
            return headerView;
        }else if(indexPath.section == 1){

            MM_SearchDefaultSectionLayoutAttribute * labelSectionAtt = self.layoutDelegate.layoutAttributes[1];

            MM_SearchHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSearchHeaderViewIdentifier forIndexPath:indexPath];
            headerView.titleLabel.text = @"热门标签";
            headerView.handleButton.hidden = NO;
            if (!labelSectionAtt.open) {
                [headerView setHandleText:@"收起"];
            }else{
                [headerView setHandleText:@"展开"];
            }
            [headerView.handleButton addTarget:self action:@selector(foldLabelSectionHandle) forControlEvents:UIControlEventTouchUpInside];
            return headerView;
        }else if(indexPath.section == 2){
            MM_SearchHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSearchHeaderViewIdentifier forIndexPath:indexPath];
            headerView.titleLabel.text = @"你可能感兴趣的主播";
            headerView.handleButton.hidden = YES;
            return headerView;
        }
    }
    else if (kind == UICollectionElementKindSectionFooter){
    
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:kSearchFooterViewIdentifier
                                                                 forIndexPath:indexPath];
    }
    return reusableview;
}

#pragma mark - Action M

- (void) cleanHistorySearchHandle:(UIButton *)button{
    if (_delegateFlags.didCleanSearchHistory) {
        [self.handleDelegate searchDefaultCollectionViewDidCleanSearchHistory:self];
    }
}

- (void) foldLabelSectionHandle{

    MM_SearchDefaultSectionLayoutAttribute * labelSectionAtt = self.layoutDelegate.layoutAttributes[1];
    labelSectionAtt.open = !labelSectionAtt.open;
    
    [self reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

#pragma mark - Setter M

- (void)setHistoryArray:(NSArray *)historyArray{
    
    _historyArray = historyArray;
    MM_SearchDefaultSectionLayoutAttribute * historyAttribute = self.layoutDelegate.layoutAttributes[0];
    [historyAttribute configSectionLayoutWith:historyArray];
}

- (void)setLabelArray:(NSArray *)labelArray{

    _labelArray = labelArray;
    MM_SearchDefaultSectionLayoutAttribute * labelAttribute = self.layoutDelegate.layoutAttributes[1];
    [labelAttribute configSectionLayoutWith:labelArray];
}

- (void) setRecommandArray:(NSArray *)recommandArray{
    
    _recommandArray = recommandArray;
    MM_SearchDefaultSectionLayoutAttribute * hotAttribute = self.layoutDelegate.layoutAttributes[2];
    [hotAttribute configSectionLayoutWith:recommandArray];
}

@end

@implementation MM_SearchDefaultRowLayoutAttribute

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.regularSizeForItem = NO;
        CGFloat width = (kScreenWidth - 2 * 12 - 10)/2;
        self.sizeForItem = CGSizeMake(width, width+28);
    }
    return self;
}

- (void)regularSizeForItem{
    
    NSString * text = self.rowData;
    CGSize maxSize = CGSizeMake(kScreenWidth - self.insetForSection.left - self.insetForSection.right, 22);
    
    CGRect frame = [text boundingRectWithSize:maxSize
                                      options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                      context:nil];
    self.sizeForItem = CGSizeMake(frame.size.width + 10, maxSize.height);
}

@end

@implementation MM_SearchDefaultSectionLayoutAttribute

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultRowAttributes = [NSMutableArray array];
        self.insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumLineSpacing = 10.0f;
        self.minimumInteritemSpacing = 10.0f;
        self.sizeForHeader = CGSizeZero;
        self.sizeForFooter = CGSizeZero;
        self.regularSizeForItem = NO;
        self.normalLinenumber = NSNotFound;
    }
    return self;
}

- (void)configSectionLayoutWith:(NSArray *)array{
    
    [_defaultRowAttributes removeAllObjects];
    
    NSMutableArray * temp = [NSMutableArray array];
    
    // init array
    [temp addObjectsFromArray:[array mm_map:^id(id data) {
        MM_SearchDefaultRowLayoutAttribute * rowAttribute = [[MM_SearchDefaultRowLayoutAttribute alloc] init];
        rowAttribute.rowData = data;
        rowAttribute.regularSizeForItem = self.regularSizeForItem;
        rowAttribute.insetForSection = self.insetForSection;
        return rowAttribute;
    }]];
    
    // config array
    [temp mm_eachWithIndex:^(MM_SearchDefaultRowLayoutAttribute * rowAttribute, NSInteger index) {
       
        BOOL isFirstItemInSection = index == 0;
        CGFloat layoutWidth = self.sizeForHeader.width - self.insetForSection.left - self.insetForSection.right;
        if (isFirstItemInSection) {
            rowAttribute.linenumber = 1;
        }else{
            NSUInteger previousIndex = index - 1;
            MM_SearchDefaultRowLayoutAttribute * previousRowAttribute = temp[previousIndex];
            
            BOOL isFirstItemInRow = YES;
            rowAttribute.linenumber = previousRowAttribute.linenumber + isFirstItemInRow;
            
            //    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
            //    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
            //    CGRect currentFrame = currentItemAttributes.frame;
            //    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
            //                                              currentFrame.origin.y,
            //                                              layoutWidth,
            //                                              currentFrame.size.height);
            //    // if the current frame, once left aligned to the left and stretched to the full collection view
            //    // widht intersects the previous frame then they are on the same line
            //    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
            
        }
    }];
    
    [_defaultRowAttributes addObjectsFromArray:temp];
    _allRowAttributes = [temp copy];
    
    
//    BOOL isFirstItemInSection = indexPath.item == 0;
//    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
//    
//    if (isFirstItemInSection) {
//        indexPath.linenumber = 1;
//        currentItemAttributes.indexPath = indexPath;
//        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
//        return currentItemAttributes;
//    }
//    
//    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
//    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
//    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
//    CGRect currentFrame = currentItemAttributes.frame;
//    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
//                                              currentFrame.origin.y,
//                                              layoutWidth,
//                                              currentFrame.size.height);
//    // if the current frame, once left aligned to the left and stretched to the full collection view
//    // widht intersects the previous frame then they are on the same line
//    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
//    
//    indexPath.linenumber = previousIndexPath.linenumber;
//    
//    if (isFirstItemInRow) {
//        indexPath.linenumber = previousIndexPath.linenumber + 1;
//        // make sure the first item on a line is left aligned
//        
////        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
////        currentItemAttributes.indexPath = indexPath;
//        return currentItemAttributes;
//    }
//    
//    CGRect frame = currentItemAttributes.frame;
////    frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
////    currentItemAttributes.frame = frame;
//    currentItemAttributes.indexPath = indexPath;
//    return currentItemAttributes;
    
}

- (NSArray<MM_SearchDefaultRowLayoutAttribute *> *)rowAttributes{
    
    return [_defaultRowAttributes copy];
}

- (void) modifySectionLayoutAttributesBeforeReloadData{
    
    if (self.normalLinenumber == NSNotFound) {// 没有设置展开行数
        return;
    }

    [_defaultRowAttributes removeAllObjects];
    if (!self.open) {
        [_defaultRowAttributes addObjectsFromArray:_allRowAttributes];
    }else{
        
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:0];

        [temp addObjectsFromArray:[_allRowAttributes mm_mapWithskip:^id(MM_SearchDefaultRowLayoutAttribute * r_att, BOOL *skip) {
            
            *skip = r_att.linenumber > self.normalLinenumber;
            return r_att;
        }]];
        [_defaultRowAttributes addObjectsFromArray:temp];
    }
}

@end

@interface MM_SearchDefaultLayoutDelegate ()

@property (nonatomic ,strong) NSMutableArray * defalutLayoutAttributes;
@end
@implementation MM_SearchDefaultLayoutDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defalutLayoutAttributes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - API M
- (void) addSectionAttributes:(NSArray <MM_SearchDefaultSectionLayoutAttribute *>*)attributes{
    
    if (attributes) {
        [_defalutLayoutAttributes addObjectsFromArray:attributes];
    }
}

- (void)addSectionAttribute:(MM_SearchDefaultSectionLayoutAttribute *)attribute{
    
    if (attribute) {
        [_defalutLayoutAttributes addObject:attribute];
    }
}

- (void)removeSectionAttributeAt:(NSInteger)index{
    
    if (index < _defalutLayoutAttributes.count) {
        [_defalutLayoutAttributes removeObjectAtIndex:index];
    }
}

#pragma mark - Private M

- (MM_SearchDefaultSectionLayoutAttribute *) safeSectionLayoutAttributeAt:(NSInteger)section{
    
    if (section < _defalutLayoutAttributes.count) {
        return _defalutLayoutAttributes[section];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout M

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.bCollectionViewDidSelectAt) {
        self.bCollectionViewDidSelectAt(indexPath);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MM_SearchDefaultRowLayoutAttribute * rowAttribute = [self safeSectionLayoutAttributeAt:indexPath.section].rowAttributes[indexPath.row];
    if (rowAttribute.isRegularSizeForItem) {
        [rowAttribute regularSizeForItem];
    }
    return rowAttribute.sizeForItem;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = [self safeSectionLayoutAttributeAt:section];
    if (sectionAttribute.rowAttributes.count == 0) {
        return UIEdgeInsetsZero;
    }
    return sectionAttribute.insetForSection;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return [self safeSectionLayoutAttributeAt:section].minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return [self safeSectionLayoutAttributeAt:section].minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = [self safeSectionLayoutAttributeAt:section];
    if (sectionAttribute.rowAttributes.count == 0) {
        return CGSizeZero;
    }
    return sectionAttribute.sizeForHeader;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    MM_SearchDefaultSectionLayoutAttribute * sectionAttribute = [self safeSectionLayoutAttributeAt:section];
    if (sectionAttribute.rowAttributes.count == 0) {
        return CGSizeZero;
    }
    return sectionAttribute.sizeForFooter;
}

#pragma mark - Getter M
- (NSArray *)layoutAttributes{
    return [_defalutLayoutAttributes copy];
}
@end

@implementation NSIndexPath (Linenumber)

-(NSUInteger)linenumber{
    NSNumber *t = objc_getAssociatedObject(self, _cmd);
    return [t integerValue];
}

- (void)setLinenumber:(NSUInteger)linenumber{
    NSNumber *t = @(linenumber);
    objc_setAssociatedObject(self, @selector(linenumber), t, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

#pragma mark -

@implementation UICollectionViewLeftAlignedLayout

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {
        indexPath.linenumber = 1;
        currentItemAttributes.indexPath = indexPath;
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    // if the current frame, once left aligned to the left and stretched to the full collection view
    // widht intersects the previous frame then they are on the same line
    // 如果当前 att 的frame
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    indexPath.linenumber = previousIndexPath.linenumber;
    
    if (isFirstItemInRow) {
        indexPath.linenumber = previousIndexPath.linenumber + 1;
        // make sure the first item on a line is left aligned
        
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        currentItemAttributes.indexPath = indexPath;
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    currentItemAttributes.frame = frame;
    currentItemAttributes.indexPath = indexPath;
    return currentItemAttributes;
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateLeftAlignedLayout> delegate = (id<UICollectionViewDelegateLeftAlignedLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateLeftAlignedLayout> delegate = (id<UICollectionViewDelegateLeftAlignedLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}

@end
