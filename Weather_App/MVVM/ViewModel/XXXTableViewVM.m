//
//  XXXTableViewVM.m
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "XXXTableViewVM.h"

@implementation XXXTableViewVM

- (instancetype) initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

- (void) reloadItemAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView reloadRowsAtIndexPaths:@[
        indexPath
    ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath{
    [super deleteItemAtIndexPath:indexPath];
    
    [_tableView deleteRowsAtIndexPaths:@[
        indexPath
    ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.layoutDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutDatas[section].layoutDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXXCellLayoutData * layoutData =
    [self.layoutDatas[indexPath.section].layoutDatas objectAtIndex:indexPath.row];
    NSString * reuseIdentifier = NSStringFromClass(layoutData.cellClass);
    UITableViewCell<XXXCellAble> *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[layoutData.cellClass alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell conformsToProtocol:@protocol(XXXCellAble)]) {
        [cell setupWithLayoutData:layoutData];
    }
    return cell;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXXCellLayoutData * layoutData =
    [self.layoutDatas[indexPath.section].layoutDatas objectAtIndex:indexPath.row];
    return layoutData.cellheight;
}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [self heightForRowInTableView:tableView indexPath:indexPath defaultHieght:tableView.estimatedRowHeight];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [self dequeueComponentHeaderFooterViewIn:tableView section:section node:[self headerNodeInSection:section]];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return [self heightForHeaderInTableView:tableView section:section defaultHieght:tableView.sectionHeaderHeight];
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    return [self heightForHeaderInTableView:tableView section:section defaultHieght:tableView.estimatedRowHeight];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [self dequeueComponentHeaderFooterViewIn:tableView section:section node:[self footerNodeInSection:section]];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return [self heightForFooterInTableView:tableView section:section defaultHieght:tableView.sectionHeaderHeight];
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return [self heightForFooterInTableView:tableView section:section defaultHieght:tableView.estimatedRowHeight];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (self.bDidSelect) {
//        self.bDidSelect(({
//            MT_TableViewSelectionContext * context =
//            [MT_TableViewSelectionContext new];
//            context.tableView = tableView;
//            context.indexPath = indexPath;
//            context.cellNode = [self cellNodeAtIndexPath:indexPath];
//            context;
//        }));
//    }
//    MT_UITableViewComponentCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell contentDidSelected];
//}
@end
