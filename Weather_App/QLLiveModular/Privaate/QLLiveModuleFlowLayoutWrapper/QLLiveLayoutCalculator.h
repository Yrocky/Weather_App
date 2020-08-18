//
//  QLLiveLayoutCalculator.h
//  Weather_App
//
//  Created by rocky on 2020/8/9.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QLLiveFlexLayoutGravity) {
    QLLiveFlexLayoutFlexStart = 0,
    QLLiveFlexLayoutFlexEnd = 1,
    QLLiveFlexLayoutCenter = 2,
    QLLiveFlexLayoutSpaceBetween = 3,
    QLLiveFlexLayoutSpaceAround = 4,
};

typedef NS_ENUM (NSUInteger, QLLiveWaterfallLayoutItemRenderDirection) {
    QLLiveWaterfallLayoutRenderShortestFirst = 0,
    QLLiveWaterfallLayoutRenderLeftToRight = 1,
    QLLiveWaterfallLayoutRenderRightToLeft = 2,
};

// Distribution
@interface QLLiveLayoutDistribution : NSObject

// column
+ (instancetype)distributionValue:(NSInteger)value;
// 固定数值
+ (instancetype)absoluteDimension:(CGFloat)value;
// CollectionView宽度的比例
+ (instancetype)fractionalDimension:(CGFloat)value;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat value;

- (BOOL)isAbsolute;
- (BOOL)isFractional;
@end

// 宽高比
@interface QLLiveLayoutItemRatio : NSObject

+ (instancetype)itemRatioValue:(CGFloat)value;
// 设定一个固定的高度
+ (instancetype)absoluteValue:(CGFloat)value;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) CGFloat value;

- (BOOL)isAbsolute;
@end

@interface QLLiveLayoutCalculator : NSObject

@property (nonatomic ,assign) CGFloat containerWidth;
@property (nonatomic ,assign) CGFloat itemSpacing;
@property (nonatomic ,assign) CGFloat lineSpacing;

#pragma mark - flexLayout
@property (nonatomic ,assign) CGFloat flexHeight;
@property (nonatomic ,assign) QLLiveFlexLayoutGravity justifyContent;

#pragma mark - list
@property (nonatomic ,strong) QLLiveLayoutDistribution * distribution;
@property (nonatomic ,strong) QLLiveLayoutItemRatio * itemRatio;

#pragma mark - Waterfall
@property (nonatomic ,assign) NSInteger column;
@property (nonatomic ,assign) QLLiveWaterfallLayoutItemRenderDirection renderDirection;
// 私有变量，暂时放这里
@property (nonatomic ,strong) NSMutableArray * columnHeights;

- (NSArray<NSValue *> *) calculatorWith:(NSArray *)items;
- (NSArray<NSValue *> *) calculatorFlexLayoutWith:(NSArray<NSNumber *> *)items;
- (NSArray<NSValue *> *) calculatorListLayoutWith:(NSArray *)items;
- (NSArray<NSValue *> *) calculatorWaterfallLayoutWith:(NSArray<NSNumber *> *)items;
@end

NS_ASSUME_NONNULL_END
