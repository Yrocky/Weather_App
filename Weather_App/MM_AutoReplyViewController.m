//
//  MM_AutoReplyViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/9/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MM_AutoReplyViewController.h"
#import "MM_AutoReplyEditViewController.h"

static NSString * const kMMAddOneItemCellIdentifier = @"kMMAddOneItemCellIdentifier";
static NSString * const kMMNormalRecordItemCellIdentifier = @"kMMNormalRecordItemCellIdentifier";

@interface MM_AutoReplyViewController ()<UITableViewDataSource,UITableViewDelegate,MM_AutoReplyEditViewControllerDelegate>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray <id>* datasource;
@end

@implementation MM_AutoReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:0 target:self action:@selector(rightBarItemClick:)];
    
    self.title = @"自动回复";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
    
    [self updateDatasource];
    [self.tableView reloadData];
}

- (void) updateDatasource{

    self.datasource = [NSMutableArray array];
    [self.datasource addObjectsFromArray:[MM_PlistMgr mm_loadData]];
}

- (MM_AutoReplyItem *) itemAt:(NSUInteger)row{

    NSData * dataRecord = self.datasource[row];
    MM_AutoReplyItem * item = [NSKeyedUnarchiver unarchiveObjectWithData:dataRecord];
    return item;
}
- (void) onAutoreplyToggle:(UISwitch *)toggle{

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:toggle.tag inSection:0];
    MM_AutoReplyItem * item = [self itemAt:indexPath.row];
    item.valid = toggle.on;
    [MM_PlistMgr mm_updateItem:item];
    [self updateDatasource];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.datasource.count) {
        return section == 1 ? 1 : self.datasource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *(^normalRecordItemCell)() = ^ UITableViewCell *(){
        
        UITableViewCell * cell;
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:kMMNormalRecordItemCellIdentifier];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            UISwitch * toggle = [[UISwitch alloc] init];
            cell.accessoryView = toggle;
            toggle.tag = indexPath.row;
            [toggle addTarget:self action:@selector(onAutoreplyToggle:) forControlEvents:UIControlEventValueChanged];
        }
        
        MM_AutoReplyItem * item = [self itemAt:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",item.regex];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",item.reply];
        UISwitch * toggle = (UISwitch *)cell.accessoryView;
        toggle.on = item.valid;
        cell.textLabel.textColor = toggle.on ? [UIColor blackColor] : [UIColor grayColor];
        return cell;
    };
    
    UITableViewCell *(^addOneItemCell)() = ^ UITableViewCell *(){
        
        UITableViewCell * cell;
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMMAddOneItemCellIdentifier];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.textLabel.textColor = [UIColor colorWithRed:0.37 green:0.71 blue:0.33 alpha:1.00];
        cell.textLabel.text = @"添加一项";
        return cell;
    };
    
    if (self.datasource.count) {
        
        return indexPath.section == 1 ? addOneItemCell() : normalRecordItemCell();
    }
    return addOneItemCell();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.datasource.count ? 2 : 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.datasource.count) {
        return indexPath.section == 1 ? 44 : 56;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.datasource.count) {
        
        if (indexPath.section == 1) {
            [self gotoRecordDetailWith:nil];
        }else{
            [self gotoRecordDetailWith:[self itemAt:indexPath.row]];
        }
    }else{
        [self gotoRecordDetailWith:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

    if (self.datasource.count) {
        if (section == 0) {   return nil;   }
    }
    return @"为了防止误操作，自动回复仅在单聊中对方发送文字时触发，支持使用正则匹配规则。为了不影响效率，最多支持添加10项自动回复。";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.datasource.count && indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.datasource.count && indexPath.section == 0) {
        UITableViewRowAction * deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            id item = [self itemAt:indexPath.row];
            [MM_PlistMgr mm_deleteItem:item];
            [self updateDatasource];
            
            [tableView reloadData];
        }];
        deleAction.backgroundColor = [UIColor redColor];
        return @[deleAction];
    }
    return nil;
}

- (void) gotoRecordDetailWith:(id)item{

    if (item == nil && self.datasource.count == 10) {
        return;
    }
    MM_AutoReplyEditViewController * edit = [[MM_AutoReplyEditViewController alloc] initWithItem:item];
    edit.delegate = self;
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark - MM_AutoReplyEditViewControllerDelegate M

- (void) onAutoReplyAddItemDone:(id)item{

    [self updateDatasource];
    [self.tableView reloadData];
}
@end
