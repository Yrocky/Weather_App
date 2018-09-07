//
//  SignalViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/8/27.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "SignalViewController.h"
#import "MMViewModel.h"
#import "MMSwipeCell.h"

@interface FDTodoCell : MMSwipeCell
@property (nonatomic ,strong) UILabel * nameLabel;
@end

@implementation FDTodoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor grayColor];
        [self.swipeContentView addSubview:self.nameLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _nameLabel.frame = (CGRect){
        20,0,
        self.swipeContentView.frame.size.width - 36,
        self.swipeContentView.frame.size.height
    };
}
@end

@interface SignalViewController ()<UITableViewDataSource,UITableViewDelegate,MMSwipeCellProtocol>{
    MMSignal<NSNumber *> * bindSignal;
}
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) MMViewModel * todoViewModel;

@end

@implementation SignalViewController

- (void)dealloc{
    NSLog(@"SignalViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信号";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addOneTodoAction)];
    
    __weak typeof(self) weakSelf = self;
    self.todoViewModel = [[MMViewModel alloc] init];
    
    [self.todoViewModel.todos subscriber:^(NSArray<MMTodoItem *> *value) {
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [self.todoViewModel.finisheds subscriber:^(NSArray<MMTodoItem *> *value) {
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
//    [self.todoViewModel.finisheds unscrible:token];
    
    [self.todoViewModel.showIndicator subscriber:^(NSNumber *value) {
        weakSelf.title = value.boolValue ? @"加载数据中..." : @"信号";
    }];
    
    bindSignal = MMEmptySignal;
    [bindSignal bind:self.todoViewModel.showIndicator];
    [bindSignal subscriber:^(NSNumber *value) {
        NSLog(@"value:%@",value);
    }];
    
//    [[self.todoViewModel.todos map:^id(NSArray<MMTodoItem *> *value) {
//        return @"one";
//    }] subscriber:^(id value) {
//        NSLog(@"%@",value);
//    }];
//    [self.todoViewModel updateTodo];
//
//    [[self.todoViewModel.todos filter:^BOOL(NSArray<MMTodoItem *> *value) {
//        return value.count == 2;
//    }] subscriber:^(NSArray<MMTodoItem *> *value) {
//        NSLog(@"value count is two:%@",value);
//    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FDTodoCell class]
           forCellReuseIdentifier:[FDTodoCell cellIdentifier]];
    [self.view addSubview:self.tableView];
}
// 添加一项
- (void) addOneTodoAction{
    NSString * news = [NSString stringWithFormat:@"%@",[NSDate date]];
    [self.todoViewModel addTodo:news complete:^(BOOL finished) {
        
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.frame;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FDTodoCell * cell = [tableView dequeueReusableCellWithIdentifier:[FDTodoCell cellIdentifier]
                                                         forIndexPath:indexPath];
    [cell addLeftHandleButton:@"删除"];
    cell.swipeDelegate = self;
    MMTodoItem * item;
    if (indexPath.section == 0) {
        
        item = self.todoViewModel.todos.peek[indexPath.row];
        
        [cell addRightHandleButton:@"完成"];
    }
    if (indexPath.section == 1) {
        
        item = self.todoViewModel.finisheds.peek[indexPath.row];
        
        [cell addRightHandleButton:@"未完成"];
    }
    
    [item.name bindTo:cell.nameLabel forKeyPath:@"text"];
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.todoViewModel titleForHeaderInSection:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.todoViewModel numberOfRowsInSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(FDTodoCell * cell, NSUInteger idx, BOOL *stop) {
        [cell resetSwipeStatusIfNeeded];
    }];
}

#pragma mark - FDSwipeCellProtocol

- (void)swipeCellWillStartSwipe:(FDTodoCell *)cell{
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(FDTodoCell * _cell, NSUInteger idx, BOOL *stop) {
        if (_cell != cell) {
            [_cell resetSwipeStatusIfNeeded];
        }
    }];
}

- (void)swipeCellDidTapRightHandleButton:(FDTodoCell *)cell{

    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        [self.todoViewModel checkTodo:indexPath.row finished:YES];
    }
    if (indexPath.section == 1) {
        [self.todoViewModel checkTodo:indexPath.row finished:NO];
    }
}

- (void)swipeCellDidTapLeftHandleButton:(FDTodoCell *)cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        [self.todoViewModel deleteTodo:indexPath.row];
    }
    if (indexPath.section == 1) {
        [self.todoViewModel deleteFinished:indexPath.row];
    }
}

@end
