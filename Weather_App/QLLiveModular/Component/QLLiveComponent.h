//
//  QLLiveComponent.h
//  BanBanLive
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLiveComponentLayout.h"
#import "QLLiveModuleDataSourceAble.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QLLiveComponentArrange) {
    /// 垂直
    QLLiveComponentArrangeVertical,
    /// 水平
    QLLiveComponentArrangeHorizontal,
};

@interface QLLiveComponent<__covariant Data> : NSObject{
    NSMutableArray<Data> *_innerDatas;
    QLLiveComponentLayout * _layout;
}

@property (nonatomic, weak, readonly) id<QLLiveModuleDataSourceAble> dataSource;
@property (nonatomic, weak, readonly) UIViewController *viewController;

/// 是否需要独立请求数据，有的comp需要自己请求数据，
/// 有的comp是在一个统一的接口中返回数据，default NO
@property (nonatomic ,assign) BOOL independentDatas;

/// 是否需要使用占位视图，在empty的时候回返回一个数据用来展示占位,default NO
@property (nonatomic ,assign) BOOL needPlacehold;

/// 当没有数据的时候，不在UI中展示，default NO
@property (nonatomic ,assign) BOOL hiddenWhenEmpty;

/// arrange == QLLiveComponentArrangeHorizontal
@property (nonatomic ,assign ,readonly) BOOL isOrthogonallyScrolls;

@property (nonatomic ,assign) QLLiveComponentArrange arrange;

/// layout
@property (nonatomic ,strong ,readonly) QLLiveComponentLayout * layout;

- (void) addData:(Data)data;
- (void) addDatas:(NSArray<Data> *)datas;

- (Data) dataAtIndex:(NSInteger)index;

- (NSInteger)numberOfItems;

@property (nonatomic ,copy ,readonly) NSArray<Data> * datas;

- (BOOL) empty;

- (void) clear;

@end

@interface QLLiveComponent (SubclassOverride)

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;
- (__kindof UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index;

#pragma mark - event

- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didDeselectItemAtIndex:(NSInteger)index;
- (void)didHighlightItemAtIndex:(NSInteger)index;
- (void)didUnhighlightItemAtIndex:(NSInteger)index;

@end

@interface QLLiveComponent (Supplementary)

- (NSArray<NSString *> *)supportedElementKinds;
- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind
                                                                 atIndex:(NSInteger)index;
- (CGSize)sizeForSupplementaryViewOfKind:(NSString *)elementKind
                                 atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
