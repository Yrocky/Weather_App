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

@implementation MMHomeComponent

- (MMHomeComponent *)currentComponent{
    return self;
}

#pragma mark - IGListSectionController override

- (NSInteger)numberOfItems{
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index{
    CGFloat width = self.collectionContext.containerSize.width;
    width -= (self.inset.left + self.inset.right);
    CGFloat height = 0;
    return CGSizeMake(width,height);
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    return nil;
}

- (void)didUpdateToObject:(id)object{
}

- (void)didSelectItemAtIndex:(NSInteger)index{
    
}

@end
