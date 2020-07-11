//
//  MMHomeComponent+Private.h
//  Weather_App
//
//  Created by skynet on 2020/5/13.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMHomeComponent (Private)

@property (weak, nonatomic, nullable) UICollectionView *collectionView;

@property (nonatomic ,weak ,readonly) MMHomeComponent * currentComponent;

@end

NS_ASSUME_NONNULL_END
