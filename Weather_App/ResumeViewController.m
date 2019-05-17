//
//  ResumeViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/17.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "ResumeViewController.h"
#import "Masonry.h"

@interface ResumeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) UIButton * contactMeButton;
@end

@implementation ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.contactMeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.contactMeButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.contactMeButton.mas_top);
    }];
    [self.contactMeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - dataSource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
