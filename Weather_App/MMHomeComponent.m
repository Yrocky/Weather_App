//
//  MMHomeComponent.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeComponent.h"
#import "MMHomeComponent+CollectionView.h"
#import "MMHomeComponent+Private.h"

const CGFloat MMComponentAutomaticDimension = CGFLOAT_MAX;

@implementation MMHomeComponent

- (MMHomeComponent *)currentComponent{
    return self;
}

#pragma mark - api

- (NSInteger)item {
    return 0;//[self.superComponent firstItemOfSubComponent:self];
}

- (NSInteger)section {
    return 0;//[self.superComponent firstSectionOfSubComponent:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

@end
