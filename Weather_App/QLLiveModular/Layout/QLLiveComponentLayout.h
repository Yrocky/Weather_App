//
//  QLLiveComponentLayout.h
//  BanBanLive
//
//  Created by skynet on 2020/3/31.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QLLiveComponentDistribution;
@class QLLiveComponentItemRatio;
@protocol QLLiveComponentLayoutDelegate;

@interface QLLiveComponentLayout : NSObject{
    NSMutableDictionary * _cacheItemSize;
}

/// default zero
@property (nonatomic ,assign) UIEdgeInsets insets;
/// 减去insets的left、right之后的宽度
@property (nonatomic ,assign ,readonly) CGFloat insetContainerWidth;

@property (nonatomic ,assign) CGFloat lineSpacing;// default 5
@property (nonatomic ,assign) CGFloat interitemSpacing;// default 5

@property (nonatomic ,strong) QLLiveComponentDistribution  * distribution;
@property (nonatomic ,strong) QLLiveComponentItemRatio * itemRatio;

/// 有的模块在没有数据的时候要展示一个占位视图
@property (nonatomic ,assign) CGFloat placeholdHeight;

/// 如果需要自定义cell的size，可以初始化该block
@property (nonatomic ,weak) id<QLLiveComponentLayoutDelegate> customItemSize;

- (CGSize) itemSizeAtIndex:(NSInteger)index;

- (void) clear;
@end

@protocol QLLiveComponentLayoutDelegate <NSObject>

- (CGSize) componentLayoutCustomItemSize:(QLLiveComponentLayout *)layout atIndex:(NSInteger)index;
@end

// Distribution
@interface QLLiveComponentDistribution : NSObject

+ (instancetype)distributionValue:(NSInteger)value;
// 固定数值
+ (instancetype)absoluteDimension:(CGFloat)value;
// CollectionView宽度的比例
+ (instancetype)fractionalDimension:(CGFloat)value;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat value;

@end

// 宽高比
@interface QLLiveComponentItemRatio : NSObject

+ (instancetype)itemRatioValue:(CGFloat)value;
// 设定一个固定的高度
+ (instancetype)absoluteValue:(CGFloat)value;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
