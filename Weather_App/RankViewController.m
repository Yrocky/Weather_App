//
//  RankViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/2.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "RankViewController.h"
#import "RoomModel.h"
#import "Masonry.h"

@interface RankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy) NSArray<RoomModel *> * datas;
@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"排行榜";
    UITableView * listView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
    listView.dataSource = self;
    listView.delegate = self;
    [self.view addSubview:listView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.datas = @[///<这些数据用来做插入
                   [RoomModel room:200],
                   [RoomModel room:201],
                   [RoomModel room:202],
                   [RoomModel room:203],
                   [RoomModel room:204],
                   ///<这些数据用来做更新滚动
                   [RoomModel room:100],
                   [RoomModel room:101],
                   [RoomModel room:102],
                   [RoomModel room:103],
                   [RoomModel room:104]];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rank-cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"rank-cell"];
    }
    cell.textLabel.text = self.datas[indexPath.row].roomName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(rankViewController:didSelectedRoom:)]) {
        [self.delegate rankViewController:self didSelectedRoom:self.datas[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
