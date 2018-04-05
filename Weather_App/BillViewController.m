//
//  BillViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillViewController.h"
#import "CustomNavigationBar.h"

@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * tableView;
@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];

    [self addLargeTitleNavigationBar];
    [self adjustsScrollViewOffsetAndInsetForLargeTitleNavigationBar:self.tableView];
    //    [self.view addSubview:self.dynamicNavView];
    //    [self.dynamicNavView.navView.backButton setHidden:YES]; // 一级页面 隐藏返回按钮
    self.tableView.frame = (CGRect){
        0,self.largeTitleNavigationBar.navigationBarBottom,
        self.view.frame.size.width,
        300
    };
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = @"idufhsidgfskdg";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scroll:%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    [self executeNavigationBarAnimationWithScrollViewDidScroll:scrollView];
    //下面代码选择实现 需要导航折叠Animation 就要在该代理方法里面实现 不滚动就是默认大标题 【5】选择性实现
//    [self showDynamicBarAnimationWithScrollView:scrollView];
    ///
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
