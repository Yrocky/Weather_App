//
//  HSSectionModel.m
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSSectionModel.h"
#import "HSSetTableViewControllerConst.h"

@implementation HSSectionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.displaySeparateLine = YES;
        
        self.heightForFooter = 0.0001;
        self.heightForHeader = HS_SectionHeight;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.heightForHeader)];
        [view setBackgroundColor:[UIColor clearColor]];
        self.viewForHeader = view;
        
        _cellModels = [NSMutableArray array];
    }
    return self;
}

- (void)addCellModel:(HSBaseCellModel *)cellModel{

    [_cellModels addObject:cellModel];
}

- (void) addCellModels:(NSArray <HSBaseCellModel *>*)cellModels{

    [_cellModels addObjectsFromArray:cellModels];
}

- (BOOL) insertCellModel:(HSBaseCellModel *)cellModel atIndex:(NSInteger)index{
    
    if (index < _cellModels.count && index >= 0) {
        
        [_cellModels insertObject:cellModel atIndex:index];
        return YES;
    }
    return NO;
}

- (BOOL) replaceCellModelAtIndex:(NSInteger)index withCellModel:(HSBaseCellModel *)cellModel{

    if (index < _cellModels.count && index >= 0) {
        
        [_cellModels replaceObjectAtIndex:index withObject:cellModel];
        return YES;
    }
    return NO;
}

- (BOOL) deleteCellModelAtIndex:(NSInteger)index{

    if (index < _cellModels.count && index >= 0) {
        [_cellModels removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (NSInteger) numberOfRowsInSection{

    return _cellModels.count;
}

- (HSBaseCellModel *) cellModelAtIndex:(NSInteger)index{

    if (index < _cellModels.count) {
        return [_cellModels objectAtIndex:index];
    }
    return nil;
}

@end
