//
//  QLLiveModuleAdapterProxy.m
//  Weather_App
//
//  Created by rocky on 2020/8/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveModuleAdapterProxy.h"
#import "CHTCollectionViewWaterfallLayout.h"

/**
 Define messages that you want the IGListAdapter object to intercept. Pattern copied from
 https://github.com/facebook/AsyncDisplayKit/blob/7b112a2dcd0391ddf3671f9dcb63521f554b78bd/AsyncDisplayKit/ASCollectionView.mm#L34-L53
 */
static BOOL QLLiveProxy_isInterceptedSelector(SEL sel) {
    return (
            // UIScrollViewDelegate
//            sel == @selector(scrollViewDidScroll:) ||
//            sel == @selector(scrollViewWillBeginDragging:) ||
//            sel == @selector(scrollViewDidEndDragging:willDecelerate:) ||
//            sel == @selector(scrollViewDidEndDecelerating:) ||
            // UICollectionViewDelegate
//            sel == @selector(collectionView:willDisplayCell:forItemAtIndexPath:) ||
//            sel == @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:) ||
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
            // CHTCollectionViewDelegateWaterfallLayout
//            sel == @selector(collectionView:layout:columnCountForSection:) ||
//            sel == @selector(collectionView:layout:heightForHeaderInSection:) ||
//            sel == @selector(collectionView:layout:heightForFooterInSection:) ||
//            sel == @selector(collectionView:layout:insetForSectionAtIndex:) ||
//            sel == @selector(collectionView:layout:insetForHeaderInSection:) ||
//            sel == @selector(collectionView:layout:insetForFooterInSection:) ||
//            sel == @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) ||
//            sel == @selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)
            );
}

@interface QLLiveModuleAdapterProxy () {
    __weak id _collectionViewTarget;
    __weak id _scrollViewTarget;
    __weak id<QLLiveModuleDataSourceAble> _dataSource;
}

@end

@implementation QLLiveModuleAdapterProxy

- (instancetype)initWithCollectionViewTarget:(nullable id<UICollectionViewDelegate>)collectionViewTarget
                            scrollViewTarget:(nullable id<UIScrollViewDelegate>)scrollViewTarget
                                 dataSource:(id<QLLiveModuleDataSourceAble>)dataSource {
    // -[NSProxy init] is undefined
    if (self) {
        _collectionViewTarget = collectionViewTarget;
        _scrollViewTarget = scrollViewTarget;
        _dataSource = dataSource;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return QLLiveProxy_isInterceptedSelector(aSelector)
    || [_collectionViewTarget respondsToSelector:aSelector]
    || [_scrollViewTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // _dataSource有方法的优先实现权
    if (QLLiveProxy_isInterceptedSelector(aSelector)) {
        return _dataSource;
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

@end
