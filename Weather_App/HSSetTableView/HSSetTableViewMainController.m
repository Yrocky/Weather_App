//
//  HSSetTableCtroller.m
//  HSSetTableView
//
//  Created by hushaohui on 2017/4/18.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSSetTableViewMainController.h"
#import "HSBaseTableViewCell.h"
#import "HSBaseCellModel.h"
#import "HSSetTableViewControllerConst.h"
#import "HSTextCellModel.h"
#import "UIView+MHCommon.h"

@interface HSSetTableViewMainController ()

@property (readwrite)UITableView *hs_tableView;  ///<tableView
@property (nonatomic ,strong ,readwrite) HSTableViewModel * tableViewModel;

@end

@implementation HSSetTableViewMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.00];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.showsVerticalScrollIndicator = NO;
    
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_x_Max){
         tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:tableView];
    self.hs_tableView = tableView;
    
    [self setupTableViewConstrint];
    
    self.tableViewModel = [[HSTableViewModel alloc] init];
    self.tableViewModel.tableView = self.hs_tableView;
}

//设置tableView约束
- (void)setupTableViewConstrint
{
    
    NSLayoutConstraint *tableViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.hs_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewTopConstraint];
    
    NSLayoutConstraint *tableViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.hs_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewLeftConstraint];
   
    NSLayoutConstraint *tableViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.hs_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewWidthConstraint];
    
    NSLayoutConstraint *tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.hs_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.view addConstraint:tableViewHeightConstraint];
}

#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:section];
    return [sectionModel numberOfRowsInSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:indexPath.section];
    HSBaseCellModel * cellModel = [sectionModel cellModelAtIndex:indexPath.row];
    
    Class class = NSClassFromString(cellModel.cellClass);
    NSAssert([class isSubclassOfClass:[HSBaseTableViewCell class]], @"此cellclass类别必须存在,并且继承HSBaseTableViewCell");
    HSBaseTableViewCell *cell = [class cellWithIdentifier:cellModel.cellClass tableView:tableView];
    [cell setupDataModel:cellModel];
    
    //处理分割线
    cell.topLine.hidden = sectionModel.displaySeparateLine ? indexPath.row != 0 : YES;
    cell.isLastLine = indexPath.row == [sectionModel numberOfRowsInSection] - 1;
    
    if (cell.isLastLine) {// section中的最后一行
        cell.bottomLine.hidden = !sectionModel.displaySeparateLine;
        cell.bottomLine.hs_x = 0;
    }else{
        cell.bottomLine.hidden = NO;
        cell.bottomLine.hs_x = cellModel.separatorInset.left;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:indexPath.section];
    HSBaseCellModel *cellModel = [sectionModel cellModelAtIndex:indexPath.row];

    Class class =  NSClassFromString(cellModel.cellClass);
    return [class getCellHeight:cellModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:indexPath.section];
    HSBaseCellModel *cellModel = [sectionModel cellModelAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:cellModel.actionBlock == nil];
    if(cellModel.actionBlock){
        cellModel.actionBlock(cellModel);
    }
}

#pragma mark tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:section];
    return sectionModel.heightForFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:section];
    return sectionModel.viewForFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:section];
    return sectionModel.viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    HSSectionModel * sectionModel = [self.tableViewModel sectionModelAtIndex:section];
    return sectionModel.heightForHeader;
}

- (void)updateCellModel:(HSBaseCellModel *)cellModel
{
    [self updateCellModel:cellModel animation:UITableViewRowAnimationFade];
}

- (void)updateCellModel:(HSBaseCellModel *)cellModel animation:(UITableViewRowAnimation)animation
{
    [self.tableViewModel.sectionModels enumerateObjectsUsingBlock:^(HSSectionModel * _Nonnull sectionObj, NSUInteger section, BOOL * _Nonnull stop) {
       
        [sectionObj.cellModels enumerateObjectsUsingBlock:^(HSBaseCellModel * _Nonnull cellObj, NSUInteger row, BOOL * _Nonnull stop) {
            
            if([cellObj.identifier isEqualToString:cellModel.identifier]){

                [sectionObj replaceCellModelAtIndex:row withCellModel:cellModel];
                //更新cell
                [self.hs_tableView beginUpdates];
                [self.hs_tableView reloadRowsAtIndexPaths:@[NSIndexPathWith(section, row)]
                                         withRowAnimation:animation];
                [self.hs_tableView endUpdates];
                *stop = YES;
                return;
            }

        }];
    }];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"控制器方法");
     __weak __typeof(&*self)weakSelf = self;
    [self.tableViewModel.sectionModels enumerateObjectsUsingBlock:^(HSSectionModel * _Nonnull sectionObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sectionObj.cellModels enumerateObjectsUsingBlock:^(HSBaseCellModel * _Nonnull cellObj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([cellObj isKindOfClass:[HSTextCellModel class]]) {
                HSTextCellModel *model = (HSTextCellModel *)cellObj;
                [model setDetailText:model.detailText];
                [weakSelf updateCellModel:model];
            }
        }];
    }];
}

- (void)dealloc
{
    if(self.hs_tableView){
        self.hs_tableView.delegate = nil;
        self.hs_tableView.dataSource = nil;
        [self.hs_tableView removeFromSuperview];
        self.hs_tableView = nil;
    }
}
@end
