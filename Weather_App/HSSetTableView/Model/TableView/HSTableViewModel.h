//
//  HSTableViewModel.h
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSSectionModel.h"

@interface HSTableViewModel : NSObject{

    NSMutableArray * _sectionModels;
}

@property (nonatomic ,strong ,readonly) NSArray <HSSectionModel *>* sectionModels;
@property (nonatomic, weak) UITableView * tableView;  ///<tableView

- (void) reloadData;

- (void) addSection:(HSSectionModel *)sectionModel;

- (BOOL) insertSectionModel:(HSSectionModel *)sectionModel atIndex:(NSInteger)index;

- (BOOL) deleteSectionAtIndex:(NSInteger)index;

- (BOOL) replaceSectionModelAtIndex:(NSInteger)index withSectionModel:(HSSectionModel *)sectionModel;

- (NSInteger) numberOfSections;
- (HSSectionModel *) sectionModelAtIndex:(NSUInteger)index;
- (__kindof HSBaseCellModel *) cellModelAtIndexPath:(NSIndexPath *)indexPath;
@end
