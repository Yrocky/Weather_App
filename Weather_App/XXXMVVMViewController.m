//
//  XXXMVVMViewController.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXMVVMViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "EaseRefreshProxy.h"
#import "NSArray+Sugar.h"
#import <Masonry.h>

@interface XXXMVVMViewController ()<
UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) DemoListViewModel * viewModel;
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) EaseRefreshProxy * refreshProxy;
@end

@implementation XXXMVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    
    // View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // viewModel
    self.viewModel = [DemoListViewModel new];
    
    // refresh
    self.refreshProxy = [[EaseRefreshProxy alloc] initWithScrollView:self.tableView];
    [self.refreshProxy addRefresh:^(NSInteger index) {
        [weakSelf.viewModel reloadDataWithCompletion:^(NSArray<XXXCellLayoutData *> * _Nonnull layoutDatas, NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (error) {
                NSLog(@"load data error:%@",error);
            } else {
                [strongSelf.tableView reloadData];
            }
            [strongSelf.refreshProxy endRefresh];
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.layoutDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXXCellLayoutData * layoutData = [self.viewModel.layoutDatas objectAtIndex:indexPath.row];
    NSString * reuseIdentifier = NSStringFromClass(layoutData.cellClass);
    UITableViewCell<XXXCellAble> *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[layoutData.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell conformsToProtocol:@protocol(XXXCellAble)]) {
        [cell setupWithLayoutData:layoutData];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XXXCellLayoutData * layoutData = [self.viewModel.layoutDatas objectAtIndex:indexPath.row];
    return layoutData.cellheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemoListLayoutData * layoutData = [self.viewModel.layoutDatas objectAtIndex:indexPath.row];
    DemoListModel * model = layoutData.metaData;
    model.name = @"xxxxx";
    
//    [self.viewModel replaceItemAtIndex:indexPath.row withItem:model];
//    [self.viewModel refreshModelWithResultSet:self.viewModel.service.resultSet];
    [self.tableView reloadData];
}
@end

@implementation DemoListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _service = [DemoListService new];
    }
    return self;
}

- (DemoListLayoutData *)refreshCellDataWithMetaData:(DemoListModel *)metaData{
    return [self tableView:metaData];
    return [self collectionView:metaData];
}

- (DemoListLayoutData *)tableView:(DemoListModel *)metaData{
    DemoListLayoutData * layoutData = [DemoListLayoutData new];
    layoutData.cellWidth = [UIScreen mainScreen].bounds.size.width - 20;
    layoutData.cellheight = 80;
    
    // 计算各个控件的位置
    CGFloat x = 10;
    CGFloat y = 5;
    layoutData.picFrame = (CGRect){
        x,y,
        100,layoutData.cellheight - 2 * y
    };
    
    x = CGRectGetMaxX(layoutData.picFrame) + 10;
    layoutData.nameFrame = (CGRect){
        x,y,
        layoutData.cellWidth - x,
        CGRectGetHeight(layoutData.picFrame)
    };
    
    return layoutData;
}

- (DemoListLayoutData *)collectionView:(DemoListModel *)metaData{
    CGFloat spacing = 10;
    NSInteger col = 2;
    
    DemoListLayoutData * layoutData = [DemoListLayoutData new];
    layoutData.cellWidth = ([UIScreen mainScreen].bounds.size.width - col * spacing) / col;
    layoutData.cellheight = 80;
    
    // 计算各个控件的位置
    CGFloat x = 0;
    CGFloat y = 0;
    layoutData.picFrame = (CGRect){
        x,y,
        layoutData.cellWidth,layoutData.cellWidth
    };
    
    x = 10;
    y = CGRectGetMaxY(layoutData.picFrame) + 10;
    layoutData.nameFrame = (CGRect){
        x,y,
        layoutData.cellWidth - x,
        CGRectGetHeight(layoutData.picFrame)
    };
    
    return layoutData;
}

@end

@implementation DemoListService{
    NSArray *_targetKeys;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _targetKeys = @[@(100),@(11873),@(103),@(106),@(140),@(11741),@(6723)];
    }
    return self;
}

- (void)reloadDataWithCompletion:(XXXServiceCompletionBlock)completion{
    if (_state == XXXServiceStateLoading) {
        return;
    }
    _state = XXXServiceStateLoading;
    
    // 发起网络请求
    DemoListRequest * request = [[DemoListRequest alloc] initWithKey:[[_targetKeys mm_sample] integerValue]];
    [request startWithCompletionBlockWithSuccess:^(DemoListRequest * _Nonnull request) {
        self->_state = XXXServiceStateLoaded;
        [self.resultSet removeAllItems];
        [self.resultSet addItems:request.list];
        if (completion) {
            completion(self.resultSet,nil);
        }
    } failure:^(DemoListRequest * _Nonnull request) {
        self->_state = XXXServiceStateLoaded;
        if (completion) {
            completion(self.resultSet,request.error);
        }
    }];
}
- (void)loadMoreDataWithCompletion:(XXXServiceCompletionBlock)completion{
    
}

@end

@implementation DemoListLayoutData

- (Class)cellClass{
    return DemoTableViewCell.class;
}

@end

@implementation DemoListModel
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    DemoListModel *model = [[DemoListModel alloc] init];
    NSString * title = dict[@"title"];
    NSString * cover = dict[@"bigCover"];
    if (dict[@"replaced"] && !title && !cover) {
        title = dict[@"replaced"][@"title"];
        cover = dict[@"replaced"][@"bigCover"];
    }
    model.name = [NSString stringWithFormat:@"%@",title];
    model.pic = [NSString stringWithFormat:@"https:%@",cover];
    return model;
}
@end

@interface DemoTableViewCell ()
@property (nonatomic ,strong ,readwrite) DemoListLayoutData * layoutData;
@property (nonatomic ,strong) UIImageView * picImageView;
@property (nonatomic ,strong) UILabel * nameLabel;
@end

@implementation DemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picImageView = [UIImageView new];
        [self.contentView addSubview:self.picImageView];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setupWithLayoutData:(DemoListLayoutData *)layoutData{
    DemoListModel * model = (DemoListModel *)layoutData.metaData;
    
    // data
    [self.picImageView setImageWithURL:[NSURL URLWithString:model.pic]];
    self.nameLabel.text = model.name;
    
    // layout
    self.picImageView.frame = layoutData.picFrame;
    self.nameLabel.frame = layoutData.nameFrame;
}

@end

@implementation DemoListRequest{
    NSInteger _key;
}

- (instancetype) initWithKey:(NSInteger)key{
    self = [super init];
    if (self) {
        _key = key;
    }
    return self;
}
- (NSString *)requestUrl{
    
    return [NSString stringWithFormat:@"https://v2.sohu.com/integration-api/mix/region/%ld?mpId=421252230&channel=10",_key];
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSMutableArray * tmp = [NSMutableArray new];
    for (NSDictionary * dict in self.responseObject[@"data"]) {
        [tmp addObject:[DemoListModel modelWithDictionary:dict]];
    }
    _list = tmp.copy;
}

@end
