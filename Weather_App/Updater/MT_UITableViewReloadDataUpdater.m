//
//  MT_UITableViewReloadDataUpdater.m
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_UITableViewReloadDataUpdater.h"
#import <UIKit/UITableView.h>
#import "MT_UITableViewAdapter.h"

@implementation MT_UITableViewReloadDataUpdater

- (void)prepare:(UITableView *)target adapter:(id<MT_Adapter>)adapter{
    if ([adapter isKindOfClass:MT_UITableViewAdapter.class]) {
        MT_UITableViewAdapter * _adapter_ =
        (MT_UITableViewAdapter *)adapter;
        target.delegate = _adapter_;
        target.dataSource = _adapter_;
    }
    [target reloadData];
}

- (void)performUpdates:(UITableView *)target adapter:(id<MT_Adapter>)adapter data:(NSArray<MT_Section *> *)data{
    
    adapter.data = data;
    [target reloadData];
}

@end
