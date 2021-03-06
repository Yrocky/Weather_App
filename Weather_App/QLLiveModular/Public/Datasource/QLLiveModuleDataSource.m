//
//  QLHomeDataSource.m
//  BanBanLive
//
//  Created by rocky on 2020/6/28.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "QLLiveModuleDataSource.h"
#import "QLLiveModuleDataSource_Private.h"
#import "QLOrthogonalScrollerEmbeddedScrollView.h"
#import "QLLiveComponent_Private.h"
#import "QLLiveModuleAdapterProxy.h"
#import "QLLiveModuleFlowLayout.h"

#import "NSArray+Sugar.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface QLLiveModuleDataSource ()<
CHTCollectionViewDelegateWaterfallLayout>{
    __weak UICollectionView *_collectionView;
}

@property (nonatomic, strong) QLLiveModuleAdapterProxy *delegateProxy;

@property (nonatomic, strong) NSMutableSet<NSString *> *registeredCellIdentifiers;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredPlaceholdCellIdentifiers;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredSupplementaryViewIdentifiers;

@property (nonatomic ,strong) NSMutableDictionary<NSNumber *, QLOrthogonalScrollerSectionController *> *orthogonalScrollerSectionControllers;
@end

@implementation QLLiveModuleDataSource

- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _innerComponents = [NSMutableArray new];
        
        _orthogonalScrollerSectionControllers = [NSMutableDictionary new];
    }
    return self;
}

- (void)setEnvironment:(id<QLLiveModelEnvironment>)environment{
    _environment = environment;
    
    UICollectionView * collectionView = environment.collectionView;
    
    if (_collectionView != environment.collectionView ||
        collectionView.dataSource != self) {
        _collectionView = collectionView;
        
        _registeredCellIdentifiers = [NSMutableSet new];
        _registeredPlaceholdCellIdentifiers = [NSMutableSet new];
        _registeredSupplementaryViewIdentifiers = [NSMutableSet new];

        collectionView.dataSource = self;
        
        [collectionView setCollectionViewLayout:({
            QLLiveModuleFlowLayout.new;
        }) animated:YES];
//        [collectionView.collectionViewLayout invalidateLayout];
        
        [self _updateCollectionViewDelegate];
    }
}

- (void)setCollectionViewDelegate:(id<UICollectionViewDelegate>)collectionViewDelegate{
    if (_collectionViewDelegate != collectionViewDelegate) {
        _collectionViewDelegate = collectionViewDelegate;
        [self _createProxyAndUpdateCollectionViewDelegate];
    }
}

- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate{
    if (_scrollViewDelegate != scrollViewDelegate) {
        _scrollViewDelegate = scrollViewDelegate;
        [self _createProxyAndUpdateCollectionViewDelegate];
    }
}

- (void)_createProxyAndUpdateCollectionViewDelegate {
    // there is a known bug with accessibility and using an NSProxy as the delegate that will cause EXC_BAD_ACCESS
    // when voiceover is enabled. it will hold an unsafe ref to the delegate
    _collectionView.delegate = nil;

    self.delegateProxy = [[QLLiveModuleAdapterProxy alloc]
                          initWithCollectionViewTarget:_collectionViewDelegate
                          scrollViewTarget:_scrollViewDelegate
                          dataSource:self];
    [self _updateCollectionViewDelegate];
}

- (void)_updateCollectionViewDelegate {
    _collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateProxy ?: self;
}

- (UICollectionView *)collectionView {
    return _collectionView;
}

#pragma mark - dequeue

- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forComponent:(__kindof QLLiveComponent *)component atIndex:(NSInteger)index{

    if (!cellClass) {
        return nil;
    }
    NSInteger sectionIndex = [self usageHidenWhenMeptyIndexWithComponent:component];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:sectionIndex];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Normal-%@",NSStringFromClass(cellClass)];

    // 水平内嵌的
    if (component.isOrthogonallyScrolls) {
        
        QLOrthogonalScrollerSectionController * sectionController =
        _orthogonalScrollerSectionControllers[@(sectionIndex)];
        
        return [sectionController dequeueReusableCell:cellClass
                                  withReuseIdentifier:reuseIdentifier
                                          atIndexPath:indexPath];
    }
    
    return [self collectionView:self.collectionView
            dequeueReusableCell:self.registeredCellIdentifiers
            withReuseIdentifier:reuseIdentifier
                      cellClass:cellClass
                    atIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *)dequeueReusablePlaceholdCellOfClass:(Class)cellClass forComponent:(__kindof QLLiveComponent *)component{
    
    if (!cellClass) {
        return nil;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:({
        [self usageHidenWhenMeptyIndexWithComponent:component];
    })];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Placehold-%@",NSStringFromClass(cellClass)];
    
    return [self collectionView:self.collectionView
            dequeueReusableCell:self.registeredPlaceholdCellIdentifiers
            withReuseIdentifier:reuseIdentifier
                      cellClass:cellClass
                    atIndexPath:indexPath];
}

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                                 forComponent:(__kindof QLLiveComponent *)component
                                                                        clazz:(Class)viewClass
                                                                      atIndex:(NSInteger)index{
    if (!elementKind) {
        return nil;
    }
    UICollectionView *collectionView = self.collectionView;
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:({
        [self usageHidenWhenMeptyIndexWithComponent:component];
    })];
    NSString * reuseIdentifier = [NSString stringWithFormat:@"Supplementary-%@-%@",NSStringFromClass(viewClass),elementKind];
    if (![self.registeredSupplementaryViewIdentifiers containsObject:reuseIdentifier]) {
        [self.registeredSupplementaryViewIdentifiers addObject:reuseIdentifier];
        [collectionView registerClass:viewClass
           forSupplementaryViewOfKind:elementKind
                  withReuseIdentifier:reuseIdentifier];
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                              withReuseIdentifier:reuseIdentifier
                                                     forIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *) collectionView:(__kindof UICollectionView *)collectionView dequeueReusableCell:(NSMutableSet *)registeredCellIdentifiers withReuseIdentifier:(NSString *)reuseIdentifier cellClass:(Class)cellClass atIndexPath:(NSIndexPath *)indexPath{
    
    if (![registeredCellIdentifiers containsObject:reuseIdentifier]) {
        [registeredCellIdentifiers addObject:reuseIdentifier];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (NSArray<__kindof QLLiveComponent *> *) usageHidenWhenMeptyComponents{
    NSArray * tmp;
    @synchronized (_innerComponents) {
        tmp = [_innerComponents mm_select:^BOOL(QLLiveComponent * component) {
            if (component.needPlacehold || component.independentDatas) {
                return YES;
            }
            return !component.hiddenWhenEmpty || component.datas.count != 0;
        }];
    }
    return tmp;
}

- (__kindof QLLiveComponent *) usageHidenWhenMeptyComponentAtIndex:(NSInteger)index{
    NSArray * tmp = [self usageHidenWhenMeptyComponents];
    QLLiveComponent * component;
    if (index < tmp.count) {
        component = [self usageHidenWhenMeptyComponents][index];
    }
    return component;
}

- (NSInteger) usageHidenWhenMeptyIndexWithComponent:(__kindof QLLiveComponent *)component{
    NSArray * tmp = [self usageHidenWhenMeptyComponents];
    return [tmp indexOfObject:component];
}

- (BOOL) canForwardMethodToCollectionViewDelegate:(SEL)sel{
    return [self.collectionViewDelegate respondsToSelector:sel];
}

@end

@implementation QLLiveModuleDataSource (ComponentsHandle)

- (void)clear{
    
    @synchronized (_innerComponents) {
        [_innerComponents mm_each:^(__kindof QLLiveComponent * component) {
            [component clear];
        }];
        [_innerComponents removeAllObjects];
    }
}

- (void) addComponent:(__kindof QLLiveComponent *)component{
    if (!component) {
        return;
    }
    @synchronized (_innerComponents) {
        component.dataSource = self;
        component.environment = self.environment;
        [_innerComponents addObject:component];
    }
}

- (void) addComponents:(NSArray<__kindof QLLiveComponent *> *)components{
    [components enumerateObjectsUsingBlock:^(__kindof QLLiveComponent * component, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addComponent:component];
    }];
}

- (void) insertComponent:(__kindof QLLiveComponent *)component atIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count && index >= 0) {
            component.dataSource = self;
            component.environment = self.environment;
            [_innerComponents insertObject:component atIndex:index];
        }
    }
}

- (void) removeComponent:(__kindof QLLiveComponent *)component{
    @synchronized (_innerComponents) {
        if ([_innerComponents containsObject:component]) {
            [component clear];
            [_innerComponents removeObject:component];
        }
    }
}

- (void) removeComponentAtIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count && index >= 0) {
            QLLiveComponent * component = _innerComponents[index];
            [component clear];
            [_innerComponents removeObject:component];
        }
    }
}

- (void) replaceComponent:(__kindof QLLiveComponent *)component atIndex:(NSInteger)index{
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            component.dataSource = self;
            component.environment = self.environment;
            [_innerComponents replaceObjectAtIndex:index withObject:component];
        }
    }
}

- (__kindof QLLiveComponent *) componentAtIndex:(NSInteger)index{
    __kindof QLLiveComponent * compontent;
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            compontent = _innerComponents[index];
        }
    }
    return compontent;
}

- (NSInteger) indexOfComponent:(__kindof QLLiveComponent *)comp{
    NSInteger index = NSNotFound;
    @synchronized (_innerComponents) {
        index = [_innerComponents indexOfObject:comp];
    }
    return index;
}

- (NSArray<__kindof QLLiveComponent *> *) components{
    
    NSArray * components;
    @synchronized (_innerComponents) {
        components = [_innerComponents mm_select:^BOOL(__kindof QLLiveComponent * component) {
            return YES;//!component.empty;
        }];
    }
    return components;
}

- (NSInteger) count{
    NSInteger count = 0;
    @synchronized (_innerComponents) {
        count = _innerComponents.count;
    }
    return count;
}

- (BOOL)empty{
    BOOL isEmpty = NO;
    @synchronized (_innerComponents) {
//        isEmpty = [_innerComponents mm_any:^BOOL(__kindof QLLiveComponent * comp) {
//            return !comp.empty;
//        }];
    }
    return isEmpty;
}

@end

#pragma mark - UICollectionViewDataSource

@implementation QLLiveModuleDataSource (UICollectionViewDataSource)

- (BOOL) targetWasOrthogonalScrollView:(UICollectionView *)collectionView{
    return [collectionView isKindOfClass:[QLOrthogonalScrollerEmbeddedScrollView class]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.usageHidenWhenMeptyComponents.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    __kindof QLLiveComponent * component = [self usageHidenWhenMeptyComponentAtIndex:section];
    if (component.independentDatas ||
        (0 == component.datas.count && component.needPlacehold) ||
        (component.isOrthogonallyScrolls &&
         ![self targetWasOrthogonalScrollView:collectionView])) {
        return 1;
    }
    return component.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell * cell;
    __kindof QLLiveComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    
    if (comp.needPlacehold) {
        cell = [comp placeholdCellForItemAtIndex:indexPath.item];
    } else {
        if (comp.isOrthogonallyScrolls) {
            
            if ([self targetWasOrthogonalScrollView:collectionView]) {
                //
                cell = [comp cellForItemAtIndex:indexPath.item];
            } else {
                
                QLOrthogonalScrollerEmbeddedCCell * ccell = [self collectionView:self.collectionView dequeueReusableCell:({
                    self.registeredCellIdentifiers;
                }) withReuseIdentifier:({
                    QLOrthogonalScrollerEmbeddedCCell.reuseIdentifier;
                }) cellClass:({
                    QLOrthogonalScrollerEmbeddedCCell.class;
                }) atIndexPath:indexPath];

                QLOrthogonalScrollerSectionController * sectionController;
                sectionController = _orthogonalScrollerSectionControllers[@(indexPath.section)];
                
                QLOrthogonalScrollerEmbeddedScrollView * scrollView;
                scrollView = ccell.orthogonalScrollView;
    
                sectionController = [[QLOrthogonalScrollerSectionController alloc] initWithSectionIndex:indexPath.section collectionView:self.collectionView scrollView:scrollView];
                
                _orthogonalScrollerSectionControllers[@(indexPath.section)] = sectionController;
                
                cell = ccell;
            }
        } else {
            cell = [comp cellForItemAtIndex:indexPath.item];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    __kindof QLLiveComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if ([comp.supportedElementKinds containsObject:kind]) {
        return [comp viewForSupplementaryElementOfKind:kind
                                               atIndex:indexPath.section];
    }
    return nil;
}

@end

#pragma mark - UICollectionViewDelegateFlowLayout

@implementation QLLiveModuleDataSource (UICollectionViewDelegateFlowLayout)

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /// component & layout
    __kindof QLLiveComponent * component = [self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    CGSize itemSize = [component.layout itemSizeAtIndex:indexPath.item];
    if (component.isOrthogonallyScrolls &&
        ![self targetWasOrthogonalScrollView:collectionView]) {
        // 内嵌的效果需要将height修改一下，这样就可以完成垂直多个cell的效果了
        itemSize = (CGSize){
            component.layout.insetContainerWidth,
            itemSize.height
        };
    }
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    /// layout
    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    /// layout
    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    /// layout
    return [self usageHidenWhenMeptyComponentAtIndex:section].layout.insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    /// component
    __kindof QLLiveComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
    if ([comp.supportedElementKinds containsObject:UICollectionElementKindSectionHeader]) {
        return [comp sizeForSupplementaryViewOfKind:({
            UICollectionElementKindSectionHeader;
        }) atIndex:section];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    /// component
    __kindof QLLiveComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
    if ([comp.supportedElementKinds containsObject:UICollectionElementKindSectionFooter]) {
        return [comp sizeForSupplementaryViewOfKind:({
            UICollectionElementKindSectionFooter;
        }) atIndex:section];
    }
    return CGSizeZero;
}

@end

@implementation QLLiveModuleDataSource (CHTCollectionViewDelegateWaterfallLayout)

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
    __kindof QLLiveComponent * comp = [self usageHidenWhenMeptyComponentAtIndex:section];
    if (comp.layout.distribution.isFractional ||
        comp.layout.distribution.isAbsolute) {
        return 1;
    }
    return comp.layout.distribution.value;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section].height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section{
    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section].height;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;;
//}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);;
}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 1;;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section{
//    return [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
//}

@end

#pragma mark - UICollectionViewDelegate

@implementation QLLiveModuleDataSource (UICollectionViewDelegate)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof QLLiveComponent * comp = (__kindof QLLiveComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    [comp didSelectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof QLLiveComponent * comp = (__kindof QLLiveComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
    [comp didDeselectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof QLLiveComponent * comp = (__kindof QLLiveComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    [comp didHighlightItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    __kindof QLLiveComponent * comp = (__kindof QLLiveComponent *)[self usageHidenWhenMeptyComponentAtIndex:indexPath.section];
    if (comp.independentDatas) {
        return;
    }
    if ([self canForwardMethodToCollectionViewDelegate:_cmd]) {
        [self.collectionViewDelegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    [comp didUnhighlightItemAtIndex:indexPath.item];
}

@end
