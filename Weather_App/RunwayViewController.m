//
//  RunwayViewController.m
//  Weather_App
//
//  Created by user1 on 2018/3/28.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "RunwayViewController.h"
#import "MMRunwayCoreView.h"
#import "MMRunwayManager.h"
#import "UIView+AsyncDrawImage.h"

@interface MMRunwayCell : UITableViewCell

@end

@implementation MMRunwayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    CGRect oFrame = frame;
    oFrame = (CGRect){
//        {10,5},
        oFrame.origin.x - 10,
        oFrame.origin.y - 5,
        oFrame.size.width - 20,
        oFrame.size.height - 10
    };
    [super setFrame:oFrame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"setFrame:%@",NSStringFromCGRect(self.frame));
//    CGRect oFrame = self.frame;
//    oFrame = (CGRect){
//        {10,5},
//        oFrame.size.width - 20,
//        oFrame.size.height - 10
//    };
//    self.contentView.frame = oFrame;
}
@end

@interface RunwayViewController ()<MMRunwayManagerDelegate,MMRunwayCoreViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSArray * socket;
}
@property (nonatomic ,weak) UILabel * l;
@property (nonatomic ,strong) MMRunwayCoreView * normalRunwayCoreView;
@property (nonatomic ,strong) MMRunwayCoreView * proRunwayCoreView;
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray * datas;
@property (nonatomic ,assign) NSInteger runwayTag;
@end

@implementation RunwayViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.datas = [NSMutableArray array];
    
    self.runwayTag = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    socket = @[@"恭喜【1234554】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条",
               @"神奇宝贝阿瓦里对薇恩的直播间进行了推荐",
               @"土豪用户通过捕鱼游戏获得了『永久土豪』昵称",
               @"主播小美玉的直播间内部有一个bug，请开发人员前往修改"];
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Normal" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onNormal) forControlEvents:UIControlEventTouchUpInside];
        [button asyncDrawBackgroundImageWithColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 10, self.view.bounds.size.width/3, 50);
        [self.view addSubview:button];
    }
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Pro" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onPro) forControlEvents:UIControlEventTouchUpInside];
        [button asyncDrawBackgroundImageWithColor:[UIColor redColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.bounds.size.width/3, 10, self.view.bounds.size.width/3, 50);
        [self.view addSubview:button];
    }
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onAddItem) forControlEvents:UIControlEventTouchUpInside];
        [button asyncDrawBackgroundImageWithColor:[UIColor greenColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(2*self.view.bounds.size.width/3, 10, self.view.bounds.size.width/3, 50);
        [self.view addSubview:button];
    }
    
    self.normalRunwayCoreView = [[MMRunwayCoreView alloc] init];
    self.normalRunwayCoreView.frame = CGRectMake(20, 150, 300, 40);
    self.normalRunwayCoreView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.normalRunwayCoreView.delegate = self;
    [self.view addSubview:self.normalRunwayCoreView];
    
    self.proRunwayCoreView = [[MMRunwayCoreView alloc] init];
    self.proRunwayCoreView.frame = CGRectMake(20, 200, 300, 40);
    self.proRunwayCoreView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    self.proRunwayCoreView.delegate = self;
    [self.view addSubview:self.proRunwayCoreView];
    
    [MMRunwayManager runwayManager].delegate = self;
    
    UILabel * l = [UILabel new];
    l.textColor = [UIColor orangeColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:22];
    l.frame = CGRectMake(0, 80, self.view.bounds.size.width, 80);
    l.numberOfLines = 2;
    [self.view addSubview:l];
    self.l = l;
    
    [MMRunwayManager runwayManager].bRunwayGenerateNormalSingleLineView = ^UIView *(id json) {
        
        MMRunwayLabel * label = [[MMRunwayLabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        CGSize size = [label configText:json];
        label.frame = (CGRect){10, 400, size};
//        label.tag = self.runwayTag;
//        self.runwayTag ++;
        return label;
    };
    [MMRunwayManager runwayManager].bRunwayGenerateProSingleLineView = ^UIView *(id json) {
        
        MMRunwayLabel * label = [[MMRunwayLabel alloc] init];
        label.backgroundColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        CGSize size = [label configText:json];
        label.frame = (CGRect){10, 400, size};
        return label;
    };
    
    
    UITableView * scrollView = [[UITableView alloc] init];
    scrollView.backgroundColor = [UIColor orangeColor];
//    scrollView.alwaysBounceVertical = YES;
//    scrollView.alwaysBounceHorizontal = YES;
    scrollView.frame = CGRectMake(0, 250, self.view.bounds.size.width, 350);
    [self.view addSubview:scrollView];
    [scrollView registerClass:[MMRunwayCell class] forCellReuseIdentifier:@"cell"];
    scrollView.dataSource = self;
    scrollView.delegate = self;
    self.tableView = scrollView;
    
}

- (void) onNormal{
    MMRunwayManager * mgr = [MMRunwayManager runwayManager];
    NSString * socketTime = [NSString stringWithFormat:@"%@",[NSDate date]];
    [mgr normalRunwayReceiveSocketAction:socketTime];
    
//    self.l.text = [NSString stringWithFormat:@"%@",mgr.queueAndCacheInfo];
}

- (void)runwayManager:(MMRunwayManager *)mgr didSendNormalSingleLineView:(id)singleLineView{
    [self.normalRunwayCoreView appendCustomView:singleLineView];
}

- (void) onPro{
    
    MMRunwayManager * mgr = [MMRunwayManager runwayManager];
    NSString * socketTime = [NSString stringWithFormat:@"%@",[NSDate date]];
    [mgr proRunwayReceiveSocketAction:socketTime];
    
//    self.l.text = [NSString stringWithFormat:@"%@",mgr.queueAndCacheInfo];
}
- (void)runwayManager:(MMRunwayManager *)mgr didSendProSingleLineView:(id)singleLineView{
    [self.proRunwayCoreView appendCustomView:singleLineView];
}

#pragma mark - MMRunwayCoreViewDelegate

- (void)runwayCoreView:(MMRunwayCoreView *)runwayCoreView didFinishDisplayItemView:(UIView *)itemView{
    
    MMRunwayManager * mgr = [MMRunwayManager runwayManager];
    if (runwayCoreView == self.normalRunwayCoreView) {
        [mgr normalRunwayCompletedOneSingleLineViewDisplay];
    }
    if (runwayCoreView == self.proRunwayCoreView) {
        [mgr proRunwayCompletedOneSingleLineViewDisplay];
    }
    
//    self.l.text = [NSString stringWithFormat:@"%@",mgr.queueAndCacheInfo];
}

- (void) onAddItem{
    
    [self.datas addObject:[NSString stringWithFormat:@"%@",[NSDate date]]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MMRunwayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [UISwipeActionsConfiguration configurationWithActions:@[[UIContextualAction contextualActionWithStyle:UISystemAnimationDelete title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"perform delete");
    }]]];
}
@end
