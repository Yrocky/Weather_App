//
//  MMHomeSectionComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent.h"

NS_ASSUME_NONNULL_BEGIN

@class MMHomeHeaderFooterComponent;
@protocol MMHomeSectionComponentAble;
@protocol MMHomeHeaderFooterComponentAble;
@interface MMHomeSectionComponent : MMHomeComponent<MMHomeSectionComponentAble>

@property (nonatomic, strong, nullable) MMHomeHeaderFooterComponent * headerComponent;
@property (nonatomic, strong, nullable) MMHomeHeaderFooterComponent * footerComponent;

@property (assign, nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (assign, nonatomic) UIEdgeInsets inset;

@property (nonatomic ,assign) NSInteger section;

@end

@protocol MMHomeSectionComponentAble <NSObject>

- (NSInteger)numberOfItems;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;
@end
#pragma mark -

@interface MMHomeHeaderFooterComponent : MMHomeComponent

@property (assign, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
