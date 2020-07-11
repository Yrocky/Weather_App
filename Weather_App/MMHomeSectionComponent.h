//
//  MMHomeSectionComponent.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent.h"
#import <IGListKit/IGListSectionController.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeSectionComponent : IGListSectionController


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
