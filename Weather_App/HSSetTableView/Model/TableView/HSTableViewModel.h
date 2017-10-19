//
//  HSTableViewModel.h
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSSectionModel.h"

// 内联函数在编译期间对使用的地方进行代码替换，作用上类似于宏
// 当函数逻辑比较简单的时候推荐使用，其他情况不推荐使用
// 但是不适合内部有很多的逻辑的函数，不适合有循环和复杂的控制结构，也就是说不可以有for-in、while、switch等
// 内联函数不允许递归调用自己
static inline NSIndexPath* NSIndexPathWith(NSInteger s ,NSInteger r){
    
    return [NSIndexPath indexPathForRow:r inSection:s];
}

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
