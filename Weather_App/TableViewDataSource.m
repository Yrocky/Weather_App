//
//  TableViewDataSource.m
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "TableViewDataSource.h"

@interface ProxyDataSource : NSObject<DataSource>{
    id<DataSource> _innerDataSource;
}

@property (nonatomic ,strong ,readonly) id<DataSource> innerDataSource;

- (instancetype) initWithDataSource:(id<DataSource>)innerDataSource;

@end

@interface TableViewDataSource ()

@property (nonatomic ,strong) ProxyDataSource * dataSource;
@end

@implementation TableViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataSource = [[ProxyDataSource alloc] init];
        
    }
    return self;
}

- (void) configCell:(UITableViewCell *)cell forRowAt:(NSIndexPath *)indexPath{

    id item = [self.dataSource itemAtIndexPath:indexPath];
    configureReceiver(cell, item);
}

- (void) configCellForRowAt:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configCell:cell forRowAt:indexPath];
}

- (void) configVisibleCells{

    NSArray * indexPaths = self.tableView.indexPathsForVisibleRows;
    if (indexPaths && indexPaths.count) {
        for (NSIndexPath * indexPath in indexPaths) {
            [self configCellForRowAt:indexPath];
        }
    }
}

#pragma mark - UITableViewDataSource M

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.dataSource numberOfSections];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSource numberOfItemsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    id item = [self.dataSource itemAtIndexPath:indexPath];
    NSString * reuseIdentifier = self.reuseIdentifierForItem(indexPath,item);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                             forIndexPath:indexPath];
    [self configCell:cell forRowAt:indexPath];
    return cell;
}

@end

@implementation ProxyDataSource

- (instancetype)initWithDataSource:(id<DataSource>)innerDataSource{
    
    self = [super init];
    if (self) {
        _innerDataSource = innerDataSource;
    }
    return self;
}

#pragma mark - DataSource M

- (NSUInteger)numberOfSections{

    return _innerDataSource.numberOfSections;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section{

    return [_innerDataSource numberOfItemsInSection:section];
}

- (id)supplementaryItemOfKind:(NSString *)kind inSection:(NSUInteger)section{

    return [_innerDataSource supplementaryItemOfKind:kind inSection:section];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{

    return [_innerDataSource itemAtIndexPath:indexPath];
}

@end

@implementation TableViewDataSourceWithHeaderFooterTitles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    id result = [self.dataSource supplementaryItemOfKind:UICollectionElementKindSectionHeader inSection:section];
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

    id result = [self.dataSource supplementaryItemOfKind:UICollectionElementKindSectionFooter inSection:section];
    
    return result;
}

@end
