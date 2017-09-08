//
//  TableViewDataSource.h
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataSourceProtocol.h"

@interface ProxyDataSource : NSObject<DataSource>{
    
    id<DataSource> _innerDataSource;
}

@property (nonatomic ,strong ,readonly) id<DataSource> innerDataSource;

- (instancetype) initWithDataSource:(id<DataSource>)innerDataSource;

@end

@interface TableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic ,weak) IBOutlet UITableView * tableView;

@property (nonatomic ,copy) NSString *(^reuseIdentifierForItem)(id cell,id item);

@end

@interface TableViewDataSourceWithHeaderFooterTitles : TableViewDataSource

@end
