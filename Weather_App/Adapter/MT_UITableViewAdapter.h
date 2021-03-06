//
//  MT_UITableViewAdapter.h
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MT_Adapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MT_TableViewSelectionContext : NSObject

@property (nonatomic ,strong ,readonly) UITableView * tableView;
@property (nonatomic ,strong ,readonly) NSIndexPath * indexPath;
@property (nonatomic ,strong ,readonly) MT_CellNode * cellNode;

@end

@interface MT_UITableViewAdapter : NSObject<
MT_Adapter,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic ,copy) NSArray<MT_Section *> * data;

@property (nonatomic ,copy) void(^bDidSelect)(MT_TableViewSelectionContext * context);

@end
NS_ASSUME_NONNULL_END
