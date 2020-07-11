//
//  QLLiveComponent.m
//  BanBanLive
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "QLLiveComponent.h"
#import "QLLiveComponent+Private.h"

@implementation QLLiveComponent

- (instancetype)init{
    self = [super init];
    if (self) {
        _innerDatas = [NSMutableArray new];
        
        // default layout
        QLLiveComponentLayout * layout = [QLLiveComponentLayout new];
        layout.insets = UIEdgeInsetsMake(0, 6, 0, 6);
        layout.distribution = [QLLiveComponentDistribution distributionValue:2];
        layout.lineSpacing = 5;
        layout.interitemSpacing = 5;
        _layout = layout;
    }
    return self;
}

- (void) addData:(id)data{
    @synchronized (_innerDatas) {
        if (![_innerDatas containsObject:data]) {
            [_innerDatas addObject:data];
        }
    }
}

- (void) addDatas:(NSArray<id> *)datas{
    @synchronized (_innerDatas) {
        [datas enumerateObjectsUsingBlock:^(id data, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![_innerDatas containsObject:data]) {
                [_innerDatas addObject:data];
            }
        }];
    }
}

- (NSArray *)datas{
    NSArray * datas;
    @synchronized (_innerDatas) {
        datas = [NSArray arrayWithArray:_innerDatas];
    }
    return datas;
}

- (id) dataAtIndex:(NSInteger)index{
    id data;
    @synchronized (_innerDatas) {
        if (index < _innerDatas.count) {
            data = [_innerDatas objectAtIndex:index];
        }
    }
    return data;
}

- (NSInteger)numberOfItems{
    NSInteger count = 0;
    @synchronized (_innerDatas) {
        count = _innerDatas.count;
    }
    return count;
}

- (BOOL) empty{
    
    if (self.independentDatas) {
        return NO;
    }
    if (self.needPlacehold) {
        return YES;
    }
    
    BOOL isEmpty = NO;
    @synchronized (_innerDatas) {
        isEmpty = _innerDatas.count == 0;
    }
    return isEmpty;
}

- (void)clear{
    // 清除布局缓存
    [self.layout clear];
    @synchronized (_innerDatas) {
        [_innerDatas removeAllObjects];
    }
}

- (BOOL)isOrthogonallyScrolls{
    return self.arrange == QLLiveComponentArrangeHorizontal;
}

@end

@implementation QLLiveComponent (SubclassOverride)

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    return nil;
}

- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index{
    return nil;
}

- (void)didSelectItemAtIndex:(NSInteger)index{}
- (void)didDeselectItemAtIndex:(NSInteger)index{}
- (void)didHighlightItemAtIndex:(NSInteger)index{}
- (void)didUnhighlightItemAtIndex:(NSInteger)index{}

@end

@implementation QLLiveComponent (Supplementary)

- (NSArray<NSString *> *)supportedElementKinds{
    return nil;
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind
                                                                 atIndex:(NSInteger)index{
    return nil;
}

- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind
                                 atIndex:(NSInteger)index{
    return CGSizeZero;
}

@end

