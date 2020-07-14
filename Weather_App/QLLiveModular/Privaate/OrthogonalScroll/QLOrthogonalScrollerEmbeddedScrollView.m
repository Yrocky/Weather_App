//
//  QLOrthogonalScrollerEmbeddedScrollView.m
//  BanBanLive
//
//  Created by rocky on 2020/7/7.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "QLOrthogonalScrollerEmbeddedScrollView.h"
#import "NSArray+Sugar.h"
#import <Masonry.h>

@implementation QLOrthogonalScrollerEmbeddedCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _orthogonalScrollView = [[QLOrthogonalScrollerEmbeddedScrollView alloc] initWithFrame:CGRectZero collectionViewLayout:({
            UICollectionViewFlowLayout * layout = UICollectionViewFlowLayout.new;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        })];
        self.orthogonalScrollView.backgroundColor = UIColor.clearColor;
        self.orthogonalScrollView.directionalLockEnabled = YES;
        self.orthogonalScrollView.showsHorizontalScrollIndicator = NO;
        self.orthogonalScrollView.showsVerticalScrollIndicator = NO;
        self.orthogonalScrollView.clipsToBounds = NO;
        [self.contentView addSubview:self.orthogonalScrollView];
        [self.orthogonalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        if (@available(iOS 11.0, *)) {
            self.orthogonalScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
        }
    }
    return self;
}
/*

 fixme:
 The behavior of the UICollectionViewFlowLayout is not defined because:
 the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
 The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7fd12c52fce0>, and it is attached to <QLOrthogonalScrollerEmbeddedScrollView: 0x7fd12d02aa00; baseClass = UICollectionView; frame = (0 0; 404 40); gestureRecognizers = <NSArray: 0x6000028c1950>; layer = <CALayer: 0x60000260c480>; contentOffset: {68, 0}; contentSize: {472.16666666666663, 40}; adjustedContentInset: {0, 0, 0, 0}; layout: <UICollectionViewFlowLayout: 0x7fd12c52fce0>; dataSource: <QLOrthogonalScrollerSectionController: 0x600002859290>>.
 Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.
 */
+ (NSString *) reuseIdentifier{
    return @"QLOrthogonalScrollerEmbeddedCCell";
}

#pragma mark - QLHomePreviewCellAble

- (NSArray<__kindof UICollectionViewCell *> *) fullRectVisibleCells{
    CGRect scrollViewRect = self.contentView.frame;
    NSArray * tmp = [[self.orthogonalScrollView visibleCells] mm_select:^BOOL(UICollectionViewCell * cell) {
        CGRect cellRect = [self.orthogonalScrollView convertRect:cell.frame toView:self.contentView];
        return CGRectContainsRect(scrollViewRect, cellRect);
    }];
    
    return tmp;
}

- (BOOL) compositionalCell{
    return YES;
}

- (BOOL) needPreview{
    return YES;
}

- (__kindof UIView *) previewView{
    return nil;
}

- (NSString *) previewStreamID{
    return @"";
}

@end

@implementation QLOrthogonalScrollerEmbeddedScrollView

@end

@interface QLOrthogonalScrollerSectionController ()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableSet<NSString *> *registeredCellIdentifiers;

@property (nonatomic ,weak) id<UICollectionViewDelegateFlowLayout> collectionViewDelegate;
@end

@implementation QLOrthogonalScrollerSectionController

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(QLOrthogonalScrollerEmbeddedScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.sectionIndex = sectionIndex;
        self.collectionView = collectionView;
        self.scrollView = scrollView;

        // fixme
        self.collectionViewDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        
        self.registeredCellIdentifiers = [NSMutableSet new];
        
        scrollView.dataSource = self;
        scrollView.delegate = self;
    }
    return self;
}

- (__kindof UICollectionViewCell *) dequeueReusableCell:(Class)cellClass withReuseIdentifier:(NSString *)reuseIdentifier atIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.registeredCellIdentifiers containsObject:reuseIdentifier]) {
        [self.registeredCellIdentifiers addObject:reuseIdentifier];
        [self.scrollView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    return [self.scrollView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (NSIndexPath *) wrapIndexPath:(NSIndexPath *)indexPath{
    return [NSIndexPath indexPathForItem:indexPath.item inSection:self.sectionIndex];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionView.dataSource collectionView:collectionView
                                   numberOfItemsInSection:self.sectionIndex];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:({
        [self wrapIndexPath:indexPath];
    })];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return [self.collectionViewDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:({
        [self wrapIndexPath:indexPath];
    })];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self.collectionViewDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:self.sectionIndex];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self.collectionViewDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:self.sectionIndex];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionViewDelegate collectionView:collectionView
                       didSelectItemAtIndexPath:[self wrapIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionViewDelegate collectionView:collectionView
                       didDeselectItemAtIndexPath:[self wrapIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionViewDelegate collectionView:collectionView
                       didHighlightItemAtIndexPath:[self wrapIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionViewDelegate collectionView:collectionView
                       didUnhighlightItemAtIndexPath:[self wrapIndexPath:indexPath]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.collectionViewDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.collectionViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.collectionViewDelegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    [self.collectionViewDelegate scrollViewDidScrollToTop:scrollView];
}

- (void)removeFromSuperview {
    [self.scrollView removeFromSuperview];
}

@end
