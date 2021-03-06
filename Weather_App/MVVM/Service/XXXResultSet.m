//
//  XXXResultSet.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXResultSet.h"
#import <UIKit/UIKit.h>

@interface XXXResultSet ()
@property (nonatomic ,strong) NSMutableArray<XXXSection *> * sections;
@end

@implementation XXXResultSet

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray new];
    }
    return self;
}

#pragma mark - section

- (void) addSection:(XXXSection *)section{
    if (section) [_sections addObject:section];
}
- (void) addSections:(NSArray<XXXSection *> *)sections{
    if (sections.count) [_sections addObjectsFromArray:sections];
}
- (void) insertSection:(XXXSection *)section atIndex:(NSInteger)index{
    self[index] = section;
}
- (void) deleteSectionAtIndex:(NSInteger)index{
    [_sections removeObjectAtIndex:index];
}

- (void) removeAllItems{
    for (XXXSection * s in _sections) {
        [s removeAllItems];
    }
    [_sections removeAllObjects];
    _index = 0;
}

- (XXXSection *) sectionAtIndex:(NSInteger)index{
    return self[index];
}

#pragma mark - item

- (void) addItem:(XXXModel)item forSection:(NSInteger)section{
    [self[section] addItem:item];
}

- (void) addItems:(NSArray<XXXModel> *)items forSection:(NSInteger)section{
    [self[section] addItems:items];
}

- (void) insertItem:(XXXModel)item atIndexPath:(NSIndexPath *)indexPath{
    [self[indexPath.section] insertItem:item atIndex:indexPath.row];
}

- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath{
    [self[indexPath.section] deleteItemAtIndex:indexPath.row];
}

- (void) removeAllItemsForSection:(NSInteger)section{
    [self[section] removeAllItems];
}

- (XXXModel) itemAtIndexPath:(NSIndexPath *)indexPath{
    return self[indexPath.section][indexPath.row];
}

#pragma mark - Subscript

- (void)setObject:(XXXSection *)anObject atIndexedSubscript:(NSUInteger)index{
    
    if (!anObject) return;
    
    const NSUInteger length = [_sections count];
    
    if (index > length) return;
    
    if (index == length){
        [_sections addObject:anObject];
    } else {
        [_sections replaceObjectAtIndex:index withObject:anObject];
    }
}

- (XXXSection *)objectAtIndexedSubscript:(NSUInteger)idx{
    
    if (idx >= [_sections count]) return nil;
    
    return [_sections objectAtIndex:idx];
}

#pragma makr - getter

- (NSArray<XXXSection *> *)data{
    return _sections.copy;
}

@end
