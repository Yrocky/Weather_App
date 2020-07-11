//
//  XXXHomeModuleViewController.m
//  Weather_App
//
//  Created by rocky on 2020/7/10.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXHomeModuleViewController.h"
#import <Masonry.h>
#import "QLLiveModule.h"
#import "EaseRefreshProxy.h"
#import "NSString+Exten.h"
#import "UIColor+Common.h"
#import "NSArray+Sugar.h"
#import "WSLWaterFlowLayout.h"

@interface YYYHomeModule : QLLiveModule

@end

@interface XXXHomeModuleViewController ()<
UICollectionViewDelegate>
@property (nonatomic ,strong) EaseRefreshProxy * refreshProxy;
@property (nonatomic ,strong) YYYHomeModule * module;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation XXXHomeModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.module = [[YYYHomeModule alloc] initWithName:@"Home"
                                       viewController:self];
    @weakify(self);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:({
        [[UICollectionViewFlowLayout alloc] init];
    })];
    _collectionView.delegate = self;
    _collectionView.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    }
    [self.view addSubview:self.collectionView];
    
    // 为module设置collectionView
    self.module.collectionView = self.collectionView;
    
    self.refreshProxy = [[EaseRefreshProxy alloc] initWithScrollView:self.collectionView];
    [self.refreshProxy setupPageOrigIndex:0 andSize:20];
    [self.refreshProxy addRefresh:^(NSInteger index) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.125 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.module refresh];
            [self.refreshProxy endRefresh];
        });
    }];
    if (self.module.shouldLoadMore) {
        [self.refreshProxy addLoadMore:@"没有更多内容" callback:^(NSInteger index) {
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.module loadMore];
                [self.refreshProxy endLoadMore];
            });
        }];
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"[module] selected at :%@",indexPath);
}

@end

@interface YYYBaseComponent : QLLiveComponent
@end

@interface YYYOneCCell : UICollectionViewCell
@property (nonatomic ,strong) UILabel * oneLabel;
- (void) setupWithData:(id)data;
@end

@interface YYYPlaceholdCCell : UICollectionViewCell
@end

@interface YYYOneComponent : YYYBaseComponent
@property (nonatomic ,copy) void(^bSetupCell)(__kindof UICollectionViewCell * cell, id data);
@end

@interface YYYTwoComponent : YYYBaseComponent<QLLiveComponentLayoutDelegate>
@end

@interface YYYThreeComponent : YYYBaseComponent{
    NSString *_title;
}
- (instancetype) initWithTitle:(NSString *)title;
@end

@interface YYYFourComponent : YYYThreeComponent<QLLiveComponentLayoutDelegate>
@end

static NSDictionary * demoData;
@implementation YYYHomeModule{
}

- (instancetype)initWithName:(NSString *)name viewController:(UIViewController *)viewController
{
    self = [super initWithName:name viewController:viewController];
    if (self) {
        demoData = @{
            @"languages":@[@"#swift#",@"#java#",@"#js#",@"#vue#",@"#ruby#",@"#css#",@"#go#"],
            @"weather":@[@"晴天",@"阴天",@"雨天",@"大风",@"雷电",@"冰雹",@"大雪",@"小雪"],
            @"city":@[@"上海",@"北京",@"广州",@"杭州",@"深圳",@"南京"],
            @"Cocoa":@[@"NSObject",@"UIView",@"UIImageView",@"UILabel",@"CALayer",@"NSRunloop"],
            @"word":@[@"a",@"b",@"c",@"d",@"e"],
            @"video":@[@"爱奇艺",@"腾讯视频",@"优酷",@"西瓜视频",@"哔哩哔哩"],
            @"number":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"],
            @"company":@[@"google",@"facebook",@"youtube",@"amazon",@"apple",@"Microsoft",@"Alphabet",@"IBM"],
            @"music":@[@"Love of My Life",@"Thank You",@"Yesterday Once More",@"You Are Not Alone",@"Billie Jean",@"Smooth Criminal",@"Earth Song",@"I will always love you",@"black or white"],
        };
    }
    return self;
}

- (BOOL)shouldLoadMore{
    return NO;
}

// 这里使用refresh来模拟网络加载
- (void)refresh{
    [super refresh];
    [self.dataSource clear];
    
    [self setupComponents:demoData];
    
    [self.collectionView reloadData];
}

// 真正业务中是实现如下方法
- (__kindof YTKRequest *)fetchModuleRequest{
    // 1.返回当前module的网络请求
    return nil;
}

- (void)parseModuleDataWithRequest:(__kindof YTKRequest *)request{
    // 2.根据request中的数据来进行component的组装
    [self setupComponents:demoData];
}

- (void) setupComponents:(NSDictionary *)data{
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.arrange = QLLiveComponentArrangeHorizontal;
        comp.layout.itemRatio = [QLLiveComponentItemRatio absoluteValue:40];
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:6];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#CB2EFF"];
            [cell setupWithData:data];
        }];
        [comp addDatas:[data[@"languages"] mm_randomObjects]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.needPlacehold = YES;
        comp.layout.placeholdHeight = 100;
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:4];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:4];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            [cell setupWithData:data];
            // 由于复用，所以这段代码下载setupWithData下面
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#B2E7F9"];
        }];
        [comp addDatas:[data[@"weather"] mm_randomObjects]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 0, 5);
        comp.arrange = QLLiveComponentArrangeHorizontal;
        comp.layout.distribution = [QLLiveComponentDistribution fractionalDimension:0.3];
        [comp addDatas:[data[@"city"] mm_randomObjects]];
        comp;
    })];

    [self.dataSource addComponent:({
        // 这个component是用来做标签效果的，
        // 如果要定制居左需要在初始化UICollectionView的时候设置对应的layout
        // 将上面的 [[UICollectionViewFlowLayout alloc] init] 进行替换
        YYYTwoComponent * comp = [YYYTwoComponent new];
        [comp addDatas:[data[@"Cocoa"] mm_randomObjects]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYThreeComponent * comp = [[YYYThreeComponent alloc] initWithTitle:@"Word"];
        [comp addDatas:[data[@"word"] mm_randomObjects]];
        comp;
    })];
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.arrange = QLLiveComponentArrangeHorizontal;
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.layout.itemRatio = [QLLiveComponentItemRatio absoluteValue:50];
        comp.layout.distribution = [QLLiveComponentDistribution absoluteDimension:90];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            [cell setupWithData:data];
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#CB2EFF"];
        }];
        [comp addDatas:[data[@"video"] mm_randomObjects]];
        comp;
    })];
    [self.dataSource addComponent:({
        YYYThreeComponent * comp = [[YYYThreeComponent alloc] initWithTitle:@"Number"];
        comp.layout.itemRatio = [QLLiveComponentItemRatio itemRatioValue:0.6];
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:4];
        [comp addDatas:[data[@"number"] mm_randomObjects]];
        comp;
    })];
    [self.dataSource addComponent:({
        YYYFourComponent * comp = [[YYYFourComponent alloc] initWithTitle:@"Music"];
        [comp addDatas:[data[@"music"] mm_randomObjects]];
        comp;
    })];
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.arrange = QLLiveComponentArrangeHorizontal;
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.layout.itemRatio = [QLLiveComponentItemRatio absoluteValue:50];
        comp.layout.distribution = [QLLiveComponentDistribution fractionalDimension:0.3];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            [cell setupWithData:data];
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#CB2EFF"];
        }];
        [comp addDatas:[data[@"company"] mm_randomObjects]];
        comp;
    })];
}
@end

@implementation YYYBaseComponent
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hiddenWhenEmpty = YES;
    }
    return self;
}
- (void)didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"[component] did selected:%@ at:%ld",[self dataAtIndex:index],(long)index);
}
@end

@implementation YYYOneComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layout.insets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.layout.lineSpacing = 5;
        self.layout.interitemSpacing = 5;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YYYOneCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YYYOneCCell.class forComponent:self atIndex:index];
    if (self.bSetupCell) {
        self.bSetupCell(ccell, [self dataAtIndex:index]);
    } else {
        [ccell setupWithData:[self dataAtIndex:index]];
    }
    return ccell;
}

- (UICollectionViewCell *)placeholdCellForItemAtIndex:(NSInteger)index{
    YYYPlaceholdCCell * ccell = [self.dataSource dequeueReusablePlaceholdCellOfClass:YYYPlaceholdCCell.class forComponent:self];
    return ccell;
}

@end

@implementation YYYOneCCell{
    UIImageView *_demoMaskImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
//        self.contentView.layer.cornerRadius = 4.0f;
//        self.contentView.layer.masksToBounds = YES;
        self.oneLabel = [UILabel new];
        self.oneLabel.textAlignment = NSTextAlignmentCenter;
        self.oneLabel.numberOfLines = 2;
        self.oneLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:self.oneLabel];
        
        _demoMaskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_image_none_space_white"]];
        _demoMaskImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_demoMaskImageView];
        
        [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(5);
            make.right.equalTo(self.contentView).mas_offset(-5);
        }];
        
        [_demoMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void) setupWithData:(NSString *)data{
    self.oneLabel.text = data;
    self.oneLabel.textColor = [UIColor colorWithHexString:@"#FF6A66"];
}
@end

@implementation YYYPlaceholdCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        UIImageView *demoMaskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_image_none_space_white"]];
        demoMaskImageView.contentMode = UIViewContentModeScaleToFill;
        demoMaskImageView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        [self.contentView addSubview:demoMaskImageView];

        UILabel * oneLabel = [UILabel new];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.text = @"今日门票已经售罄";
        oneLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        oneLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:oneLabel];
        
        [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.left.equalTo(demoMaskImageView).mas_offset(5);
            make.right.equalTo(demoMaskImageView).mas_offset(-5);
        }];
        
        [demoMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
    }
    return self;
}
@end

@interface YYYTwoCCell : UICollectionViewCell
- (void) setupWithData:(id)data;
@end

@implementation YYYTwoComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layout.insets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.layout.lineSpacing = 5;
        self.layout.interitemSpacing = 5;
        self.layout.customItemSize = self;
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YYYTwoCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YYYTwoCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

#pragma mark - QLLiveComponentLayoutDelegate

- (CGSize)componentLayoutCustomItemSize:(QLLiveComponentLayout *)layout atIndex:(NSInteger)index{
    
    NSString * record = [self dataAtIndex:index];
    CGSize size = [record YYY_sizeWithFont:[UIFont systemFontOfSize:12]
                                   maxSize:CGSizeMake(CGFLOAT_MAX, 30)];
    size.width = size.width + 30;///30 是字体的左右间距
    size.height = 30;
    return size;
}
@end

@implementation YYYTwoCCell{
    UILabel * twoLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        twoLabel = [UILabel new];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        twoLabel.font = [UIFont systemFontOfSize:12];
        twoLabel.textColor = [UIColor colorWithHexString:@"#FF8D00"];
        [self.contentView addSubview:twoLabel];
        
        [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setupWithData:(NSString *)data{
    twoLabel.text = data;
}

@end

@interface YYYThreeHeaderView : UICollectionReusableView

- (void) setupHeaderTitle:(NSString *)title;
@end
@implementation YYYThreeComponent

- (instancetype) initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _title = title;
        self.layout.insets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.layout.lineSpacing = 5;
        self.layout.interitemSpacing = 5;
        self.layout.itemRatio = [QLLiveComponentItemRatio itemRatioValue:2.0];
        self.layout.distribution = [QLLiveComponentDistribution distributionValue:2];
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YYYOneCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YYYOneCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}

- (NSArray<NSString *> *)supportedElementKinds{
    return @[UICollectionElementKindSectionHeader];
}

- (__kindof UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index{
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        YYYThreeHeaderView *view = [self.dataSource dequeueReusableSupplementaryViewOfKind:elementKind forComponent:self clazz:YYYThreeHeaderView.class atIndex:index];
        [view setupHeaderTitle:[NSString stringWithFormat:@"%@(%lu)",_title,(unsigned long)[self.datas count]]];
        return view;
    }
    return nil;
}

- (CGSize) sizeForSupplementaryViewOfKind:(NSString *)elementKind atIndex:(NSInteger)index{
    if (elementKind == UICollectionElementKindSectionHeader) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 48);
    }
    return CGSizeZero;
}

@end

@implementation YYYThreeHeaderView{
    UILabel * titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(16);
            make.height.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
- (void) setupHeaderTitle:(NSString *)title{
    titleLabel.text = title;
}
@end

@implementation YYYFourComponent


- (instancetype) initWithTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        self.layout.customItemSize = self;
    }
    return self;
}

#pragma mark - QLLiveComponentLayoutDelegate

- (CGSize)componentLayoutCustomItemSize:(QLLiveComponentLayout *)layout atIndex:(NSInteger)index{
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat halfContainerWidth = (layout.insetContainerWidth - layout.interitemSpacing) * 0.5;
    if (index == 0) {
        width = halfContainerWidth;
    } else {
        width = (halfContainerWidth - layout.interitemSpacing) * 0.5;
    }
    height = width;

    return CGSizeMake(width, height);
}
@end
