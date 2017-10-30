//
//  FDViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "HLLStickIndicator.h"
#import "FDContentView.h"

@interface FDViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic ,strong) UICollectionView * contentView;
//@property (nonatomic ,strong) UITableView * contentView;
@property (nonatomic ,strong) FDContentView * contentView;

@property (nonatomic ,strong) UIView * bgView;
@property (nonatomic ,strong) MASConstraint * bgViewHeightConstraint;

@property (nonatomic ,strong) UIView * headerView;
@property (nonatomic ,strong) UITableView * tableView;

@property (nonatomic ,strong) HLLStickIndicatorView * topIndicatorView;

@property (nonatomic ,strong) HLLStickIndicatorView * leftIndicatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * rightIndicatorView;

@property (nonatomic ,strong) UIPanGestureRecognizer * ges;
@property (nonatomic ,strong) UILongPressGestureRecognizer * swipChangeGesture;
@end

@implementation FDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F5F5"];
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.bgView = view;
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.view.mas_topMargin);
//        make.bottom.mas_equalTo(self.view.mas_bottomMargin);
//    }];
    
//    UICollectionViewLayout * layout = [[UICollectionViewLayout alloc] init];
//    self.contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.contentView = [[FDContentView alloc] init];
    self.contentView.delegate = self;
//    self.contentView = [[UITableView alloc] init];
//    self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor orangeColor];
    self.contentView.showsVerticalScrollIndicator = YES;
    self.contentView.showsHorizontalScrollIndicator = YES;
    self.contentView.alwaysBounceVertical = YES;
//    self.contentView.alwaysBounceHorizontal = YES;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_topMargin);
        make.bottom.mas_equalTo(self.view.mas_bottomMargin);
    }];
    
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView);
        self.bgViewHeightConstraint = make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(self.view.mas_bottomMargin).mas_offset(-20);
        make.centerX.mas_equalTo(self.view);
    }];
//    if (@available(iOS 11.0, *)) {
//        CGSize contentSize = (CGSize){
//            self.view.bounds.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right,
//            self.view.bounds.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom - 20
//        };
//        self.contentView.contentSize = contentSize;
//    } else {
//        CGSize contentSize = (CGSize){
//            self.view.bounds.size.width,
//            self.view.bounds.size.height
//        };
//        self.contentView.contentSize = contentSize;
//    }
    
    self.headerView = [UIView new];
    self.headerView.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.top.and.right.and.left.mas_equalTo(self.bgView);
    }];
    
    self.tableView = [[UITableView alloc] init];
//    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
    }];
    
    // 1.topIndicatorView
    self.topIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorTop frame:CGRectZero];
    [self.contentView addSubview:self.topIndicatorView];
    [self.topIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_top);
    }];
    
    // 2.leftIndicatorView
    self.leftIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorLeft frame:(CGRect){
        0,0,
        60,200
    }];
    [self.leftIndicatorView configIndicatorInfo:@"加载\n前一篇"];
    [self.tableView addSubview:self.leftIndicatorView];
    [self.leftIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 200));
        make.centerY.mas_equalTo(self.tableView);
        make.right.mas_equalTo(self.tableView.mas_left).mas_offset(0);
    }];
    
    
    // 3.rightIndicatorView
    self.rightIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight frame:(CGRect){
        0,0,
        60,200
    }];
    [self.rightIndicatorView configIndicatorInfo:@"加载\n下一篇"];
    [self.tableView addSubview:self.rightIndicatorView];
    [self.rightIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.leftIndicatorView);
        make.centerY.mas_equalTo(self.leftIndicatorView);
        make.left.mas_equalTo(self.headerView.mas_right).mas_offset(0);
    }];
    
    self.swipChangeGesture = [[UILongPressGestureRecognizer alloc] init];
    self.swipChangeGesture.delegate = self;
    [self.tableView addGestureRecognizer:self.swipChangeGesture];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    CGFloat height = 0;
        if (@available(iOS 11.0, *)) {
//            CGSize contentSize = (CGSize){
//                self.view.bounds.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right,
            height = self.view.bounds.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom;
//            };
//            self.contentView.contentSize = contentSize;
        } else {
//            CGSize contentSize = (CGSize){
//                self.view.bounds.size.width,
            height = self.view.bounds.size.height - 20;
//            };
//            self.contentView.contentSize = contentSize;
        }
    self.bgViewHeightConstraint.mas_equalTo(height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row:%ld",(long)indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // iOS 10 iPhone 6 -20
    // iOS 11 iPhone X 0
    // iOS 11 iPhone 7 Plus 0
//    NSLog(@"contentOffset.y:%f",scrollView.contentOffset.y );
    
    float scrollViewBottomContentOffsetY = scrollView.contentOffset.y + scrollView.frame.size.height;
    float scrollViewContentSizeHeight = scrollView.contentSize.height;
    
    bool contentViewCanBounceVertical = NO;
    if (@available(iOS 11.0, *)) {
        contentViewCanBounceVertical = scrollView.contentOffset.y <= 0;
    } else {
        contentViewCanBounceVertical = scrollView.contentOffset.y <= -20;
    }
//    NSLog(@"contentViewCanBounceVertical : %d",contentViewCanBounceVertical);
    
    /**
     Printing description of scrollView->_pan:
    <UIScrollViewPanGestureRecognizer: 0x7fd8a3500f00;
     state = Began;
     delaysTouchesEnded = NO;
     view = <UIScrollView 0x7fd8a482fa00>;
     target= <(action=handlePan:,target=<UIScrollView 0x7fd8a482fa00>)>
     >
     
     UIScrollViewPanGestureRecognizer : UIPanGestureRecognizer
     */
    
//    self.contentView.alwaysBounceVertical = contentViewCanBounceVertical;

    //    UITableViewCell * lastCell = [self.tableView.visibleCells lastObject];
//    NSLog(@"lastCell.frame:%@",NSStringFromCGRect(lastCell.frame));
//
//    NSLog(@"lastCell.bottom:%f",CGRectGetMaxY(lastCell.frame));
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    
    return YES;
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
