//
//  MMHomeComponentDelegate.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponentProxy.h"
#import "MMHomeComponent.h"

/**
Define messages that you want the IGListAdapter object to intercept. Pattern copied from
https://github.com/facebook/AsyncDisplayKit/blob/7b112a2dcd0391ddf3671f9dcb63521f554b78bd/AsyncDisplayKit/ASCollectionView.mm#L34-L53
*/
static BOOL MM_isInterceptedSelector(SEL sel) {
    return (
            // UIScrollViewDelegate
            sel == @selector(scrollViewDidScroll:) ||
            sel == @selector(scrollViewWillBeginDragging:) ||
            sel == @selector(scrollViewDidEndDragging:willDecelerate:) ||
            sel == @selector(scrollViewDidEndDecelerating:) ||
            // UICollectionViewDelegate
            sel == @selector(collectionView:willDisplayCell:forItemAtIndexPath:) ||
            sel == @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:) ||
            sel == @selector(collectionView:didSelectItemAtIndexPath:) ||
            sel == @selector(collectionView:didDeselectItemAtIndexPath:) ||
            sel == @selector(collectionView:didHighlightItemAtIndexPath:) ||
            sel == @selector(collectionView:didUnhighlightItemAtIndexPath:) ||
            // UICollectionViewDelegateFlowLayout
            sel == @selector(collectionView:layout:sizeForItemAtIndexPath:) ||
            sel == @selector(collectionView:layout:insetForSectionAtIndex:) ||
            sel == @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) ||
            sel == @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:) ||
            sel == @selector(collectionView:layout:referenceSizeForFooterInSection:) ||
            sel == @selector(collectionView:layout:referenceSizeForHeaderInSection:)
            
            // IGListCollectionViewDelegateLayout
//            sel == @selector(collectionView:layout:customizedInitialLayoutAttributes:atIndexPath:) ||
//            sel == @selector(collectionView:layout:customizedFinalLayoutAttributes:atIndexPath:)
            );
}

@implementation MMHomeComponentProxy{
    __weak id _collectionViewTarget;
    __weak id _scrollViewTarget;
    __weak MMHomeComponent *_currentComponent;
}

//- (instancetype) initWithComponent:(MMHomeComponent *)comp{
//    if (self) {
//        _currentComponent = comp;
//        if (_currentComponent.collectionView.dataSource) {
//            _currentComponent.collectionView.dataSource = nil;
//            _currentComponent.collectionView.dataSource = self;
//        }
//        if (_currentComponent.collectionView.delegate) {
//            _currentComponent.collectionView.delegate = nil;
//            _currentComponent.collectionView.delegate = self;
//        }
//        return self;
//    }
//    return self;
//}
//- (instancetype)initWithCollectionViewTarget:(nullable id<UICollectionViewDelegate>)collectionViewTarget
//                            scrollViewTarget:(nullable id<UIScrollViewDelegate>)scrollViewTarget
//                                   component:(MMHomeComponent *)comp{
////    self = [super init];
//    if (self) {
//        _currentComponent = comp;
//        if (_currentComponent.collectionView.dataSource) {
//            _currentComponent.collectionView.dataSource = nil;
//            _currentComponent.collectionView.dataSource = self;
//        }
//        if (_currentComponent.collectionView.delegate) {
//            _currentComponent.collectionView.delegate = nil;
//            _currentComponent.collectionView.delegate = self;
//        }
//        _collectionViewTarget = collectionViewTarget;
//        _scrollViewTarget = scrollViewTarget;
//        return self;
//    }
//    return self;
//}


//- (instancetype)initWithCollectionViewTarget:(nullable id<UICollectionViewDelegate>)collectionViewTarget
//                            scrollViewTarget:(nullable id<UIScrollViewDelegate>)scrollViewTarget
//                                 interceptor:(IGListAdapter *)interceptor {
////    IGParameterAssert(interceptor != nil);
//    // -[NSProxy init] is undefined
//
//}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return MM_isInterceptedSelector(aSelector)
    || [_currentComponent respondsToSelector:aSelector]
    || [_currentComponent respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (MM_isInterceptedSelector(aSelector)) {
        return _currentComponent;
    }

    // since UICollectionViewDelegate is a superset of UIScrollViewDelegate, first check if the method exists in
    // _scrollViewTarget, otherwise use the _collectionViewTarget
    return [_scrollViewTarget respondsToSelector:aSelector] ? _scrollViewTarget : _collectionViewTarget;
}

// handling unimplemented methods and nil target/interceptor
// https://github.com/Flipboard/FLAnimatedImage/blob/76a31aefc645cc09463a62d42c02954a30434d7d/FLAnimatedImage/FLAnimatedImage.m#L786-L807
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

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
