//
//  UICollectionViewLayout+InteractiveLayout.m
//  Weather_App
//
//  Created by rocky on 2020/8/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "UICollectionViewLayout+InteractiveLayout.h"
#import "QLLiveModuleDataSource_Private.h"
#import <objc/runtime.h>

static void * kQLLiveModuleDataSourceKey = &kQLLiveModuleDataSourceKey;

@implementation UICollectionViewLayout (InteractiveLayout)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        [self ql_swizzleInstanceMethod:@selector(prepareLayout)
//                               withNew:@selector(ql_prepareLayout)];
//        [self ql_swizzleInstanceMethod:@selector(layoutAttributesForElementsInRect:)
//                               withNew:@selector(ql_layoutAttributesForElementsInRect:)];
//        [self ql_swizzleInstanceMethod:@selector(layoutAttributesForItemAtIndexPath:)
//                               withNew:@selector(ql_layoutAttributesForItemAtIndexPath:)];
//        [self ql_swizzleInstanceMethod:@selector(layoutAttributesForSupplementaryViewOfKind:atIndexPath:)
//                               withNew:@selector(ql_layoutAttributesForSupplementaryViewOfKind:atIndexPath:)];
//        [self ql_swizzleInstanceMethod:@selector(collectionViewContentSize)
//                               withNew:@selector(ql_collectionViewContentSize)];
//    });
//}

+ (void)ql_swizzleInstanceMethod:(SEL)originalSel withNew:(SEL)newSel{
    Class layoutClass = [self class];
    Method originalMethod = class_getInstanceMethod(layoutClass, originalSel);
    Method newMethod = class_getInstanceMethod(layoutClass, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)ql_hijackLayoutInteractiveLayoutMethodForDataSource:(QLLiveModuleDataSource *)dataSource{
    objc_setAssociatedObject(self, kQLLiveModuleDataSourceKey, dataSource, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - hook

- (nullable QLLiveModuleDataSource *) dataSource{
    return (QLLiveModuleDataSource *)objc_getAssociatedObject(self, kQLLiveModuleDataSourceKey);
}

// 初始化 生成每个视图的布局信息
-(void)ql_prepareLayout{
    [self ql_prepareLayout];
    if (nil != self.dataSource) {
//        [self.dataSource prepareLayout];
    }
}

// 一段区域所有cell、头、尾视图
-(NSArray<UICollectionViewLayoutAttributes *> *)ql_layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> * attes =
    [self ql_layoutAttributesForElementsInRect:rect];
    if (nil != self.dataSource) {
        
    }
    return attes;
}

// cell
-(UICollectionViewLayoutAttributes *)ql_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * att = [self ql_layoutAttributesForItemAtIndexPath:indexPath];
    if (nil != self.dataSource) {
        
    }
    return att;
}

// header & footer
- (UICollectionViewLayoutAttributes *)ql_layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * att =
    [self ql_layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if (nil != self.dataSource) {
        
    }
    return att;
}

//返回内容高度
-(CGSize)ql_collectionViewContentSize{
    CGSize contentSize = [self ql_collectionViewContentSize];
    if (nil != self.dataSource) {
//        [self.dataSource collectionViewContentSize];
    }
    return contentSize;
}
@end
