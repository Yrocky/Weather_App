//
//  MT_UITableViewAdapter.m
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_UITableViewAdapter.h"
#import <UIKit/UIKit.h>
#import "UIView+MT_ComponentRenderable.h"

@interface MT_UITableViewComponentCell : UITableViewCell<
MT_ComponentRenderable>
@end

@interface MT_UITableViewComponentHeaderFooterView : UITableViewHeaderFooterView<
MT_ComponentRenderable>
@end

@interface MT_TableViewSelectionContext ()

@property (nonatomic ,strong ,readwrite) UITableView * tableView;
@property (nonatomic ,strong ,readwrite) NSIndexPath * indexPath;
@property (nonatomic ,strong ,readwrite) MT_CellNode * cellNode;

@end

@interface MT_UITableViewAdapter ()

@end

@implementation MT_UITableViewAdapter

- (NSArray<MT_CellNode *> *) cellNodesInSection:(NSInteger)section{
    return self.data[section].cells;
}
- (MT_CellNode *) cellNodeAtIndexPath:(NSIndexPath *)indexPath{
    return self.data[indexPath.section].cells[indexPath.row];
}

- (MT_ViewNode *) headerNodeInSection:(NSInteger)section{
    return self.data[section].header;
}
- (MT_ViewNode *) footerNodeInSection:(NSInteger)section{
    return self.data[section].footer;
}

#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self cellNodesInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MT_CellNode * cellNode = [self cellNodeAtIndexPath:indexPath];
    NSString * reuseIdentifier = cellNode.component.reuseIdentifier;
    UITableViewCell<MT_Content> * componentCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!componentCell) {
        [tableView registerClass:MT_UITableViewComponentCell.class
          forCellReuseIdentifier:reuseIdentifier];
        return [self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    [componentCell renderWithComponent:cellNode.component];
    return componentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForRowInTableView:tableView indexPath:indexPath defaultHieght:tableView.rowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForRowInTableView:tableView indexPath:indexPath defaultHieght:tableView.estimatedRowHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self dequeueComponentHeaderFooterViewIn:tableView section:section node:[self headerNodeInSection:section]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self heightForHeaderInTableView:tableView section:section defaultHieght:tableView.sectionHeaderHeight];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return [self heightForHeaderInTableView:tableView section:section defaultHieght:tableView.estimatedRowHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [self dequeueComponentHeaderFooterViewIn:tableView section:section node:[self footerNodeInSection:section]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [self heightForFooterInTableView:tableView section:section defaultHieght:tableView.sectionHeaderHeight];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return [self heightForFooterInTableView:tableView section:section defaultHieght:tableView.estimatedRowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bDidSelect) {
        self.bDidSelect(({
            MT_TableViewSelectionContext * context =
            [MT_TableViewSelectionContext new];
            context.tableView = tableView;
            context.indexPath = indexPath;
            context.cellNode = [self cellNodeAtIndexPath:indexPath];
            context;
        }));
    }
    MT_UITableViewComponentCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell contentDidSelected];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell contentWillDisplay];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell contentDidEndDisplay];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [view contentWillDisplay];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    [view contentDidEndDisplay];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    [view contentWillDisplay];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    [view contentDidEndDisplay];
}

#pragma mark - Private

- (UITableViewHeaderFooterView *) dequeueComponentHeaderFooterViewIn:(UITableView *)tableView section:(NSInteger)section node:(MT_ViewNode *)node{
    
    NSString * reuseIdentifier = node.component.reuseIdentifier;
    MT_UITableViewComponentHeaderFooterView * componetView =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (!componetView) {
        [tableView registerClass:MT_UITableViewComponentHeaderFooterView.class
     forHeaderFooterViewReuseIdentifier:reuseIdentifier];
        return [self dequeueComponentHeaderFooterViewIn:tableView section:section node:node];
    }
    [componetView renderWithComponent:node.component];
    return componetView;
}

- (CGFloat) heightForRowInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath defaultHieght:(CGFloat)defaultHeight{
    MT_CellNode * cellNode = [self cellNodeAtIndexPath:indexPath];
    CGFloat height = [cellNode.component referenceSizeInBounds:tableView.bounds].height;
    return height == 0 ? defaultHeight : height;
}

- (CGFloat) heightForHeaderInTableView:(UITableView *)tableView section:(NSInteger)section defaultHieght:(CGFloat)defaultHeight{
    MT_ViewNode * viewNode = [self headerNodeInSection:section];
    CGFloat height = [viewNode.component referenceSizeInBounds:tableView.bounds].height;
    return height == 0 ? defaultHeight : height;
}

- (CGFloat) heightForFooterInTableView:(UITableView *)tableView section:(NSInteger)section defaultHieght:(CGFloat)defaultHeight{
    MT_ViewNode * viewNode = [self footerNodeInSection:section];
    CGFloat height = [viewNode.component referenceSizeInBounds:tableView.bounds].height;
    return height == 0 ? defaultHeight : height;
}

@end

@implementation MT_UITableViewComponentCell
@end

@implementation MT_UITableViewComponentHeaderFooterView
@end

@implementation MT_TableViewSelectionContext
@end
