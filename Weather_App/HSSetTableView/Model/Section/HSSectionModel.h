//
//  HSSectionModel.h
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HSBaseCellModel.h"

@interface HSSectionModel : NSObject{

    NSMutableArray * _cellModels;
}

@property (nonatomic ,strong ,readonly) NSArray <HSBaseCellModel *>* cellModels;

@property (nonatomic ,assign) BOOL displaySeparateLine;///<是否显示分割线

//
@property (nonatomic ,assign) CGFloat heightForHeader;
@property (nonatomic ,strong) UIView * viewForHeader;

//
@property (nonatomic ,assign) CGFloat heightForFooter;
@property (nonatomic ,strong) UIView * viewForFooter;

- (void) addCellModel:(HSBaseCellModel *)cellModel;
- (void) addCellModels:(NSArray <HSBaseCellModel *>*)cellModels;

- (BOOL) insertCellModel:(HSBaseCellModel *)cellModel atIndex:(NSInteger)index;

- (BOOL) replaceCellModelAtIndex:(NSInteger)index withCellModel:(HSBaseCellModel *)cellModel;

- (BOOL) deleteCellModelAtIndex:(NSInteger)index;

- (NSInteger) numberOfRowsInSection;
- (HSBaseCellModel *) cellModelAtIndex:(NSInteger)index;
@end
