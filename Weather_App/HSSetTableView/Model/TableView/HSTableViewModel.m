//
//  HSTableViewModel.m
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSTableViewModel.h"

@implementation HSTableViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {

        _sectionModels = [NSMutableArray array];
    }
    return self;
}

- (void)reloadData{

    [self.tableView reloadData];
}

- (void) addSection:(HSSectionModel *)sectionModel{

    [_sectionModels addObject:sectionModel];
}

- (BOOL) insertSectionModel:(HSSectionModel *)sectionModel atIndex:(NSInteger)index{

    if (index < _sectionModels.count && index >= 0) {
        
        [_sectionModels insertObject:sectionModel atIndex:index];
        return YES;
    }
    return NO;
}

- (BOOL) deleteSectionAtIndex:(NSInteger)index{

    if (index < _sectionModels.count && index >= 0) {
        [_sectionModels removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (BOOL) replaceSectionModelAtIndex:(NSInteger)index withSectionModel:(HSSectionModel *)sectionModel{
    
    if (index < _sectionModels.count && index >= 0) {
        
        [_sectionModels replaceObjectAtIndex:index withObject:sectionModel];
        return YES;
    }
    return NO;
}

- (NSInteger) numberOfSections{

    return _sectionModels.count;
}

- (HSSectionModel *) sectionModelAtIndex:(NSUInteger)index{

    if (index < _sectionModels.count) {
        return _sectionModels[index];
    }
    return nil;
}

- (__kindof HSBaseCellModel *) cellModelAtIndexPath:(NSIndexPath *)indexPath{

    return [[self sectionModelAtIndex:indexPath.section] cellModelAtIndex:indexPath.row];
}
@end
