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
#import "HLLAlert.h"

@interface YYYYMoveContainerView : UIView
@property (nonatomic ,strong) UIView * aView;
@end

@interface YYYHomeModule : QLLiveModule

@end

@interface XXXHomeModuleViewController ()<
UICollectionViewDelegate>
@property (nonatomic ,strong) EaseRefreshProxy * refreshProxy;
@property (nonatomic ,strong) YYYHomeModule * module;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) YYYYMoveContainerView * moveContainerView;
@end

@implementation XXXHomeModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.module = [[YYYHomeModule alloc] initWithName:@"Home"];
    @weakify(self);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:({
        [[UICollectionViewFlowLayout alloc] init];
    })];
    _collectionView.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    }
    [self.view addSubview:self.collectionView];
    
    // 为module设置collectionView
    [self.module setupViewController:self
                      collectionView:self.collectionView];
    self.module.dataSource.scrollViewDelegate = self;
    self.module.dataSource.collectionViewDelegate = self;
    
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
//        make.left.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.width.mas_equalTo(200);
//        make.bottom.equalTo(self.view);
    }];
    
//    self.moveContainerView = [YYYYMoveContainerView new];
//    [self.view addSubview:self.moveContainerView];
//    [self.moveContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(300);
//    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"[module] selected at :%@",indexPath);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"did scroll...");
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

@interface YYYFiveComponent : YYYThreeComponent<QLLiveComponentLayoutDelegate>
@end
@interface YYYSixComponent : YYYThreeComponent<QLLiveComponentLayoutDelegate>
@end
static NSDictionary * demoData;

@interface QLLiveModuleGrid : NSObject

// 垂直
+ (instancetype) gridAbsoluteHeight:(CGFloat)height
                    fractionalWidth:(CGFloat)width;
// 水平
+ (instancetype) gridAbsoluteWidth:(CGFloat)width
                  fractionalHeight:(CGFloat)height;

@property (nonatomic ,assign ,readonly) CGFloat width;
@property (nonatomic ,assign ,readonly) CGFloat height;

@property (nonatomic ,assign ,readonly) BOOL isVerticel;

@end

@implementation QLLiveModuleGrid
// 垂直
+ (instancetype) gridAbsoluteHeight:(CGFloat)height
                    fractionalWidth:(CGFloat)width{
    return [[self alloc] initWithWidth:width height:height isVertical:YES];
}
// 水平
+ (instancetype) gridAbsoluteWidth:(CGFloat)width
                  fractionalHeight:(CGFloat)height{
    return [[self alloc] initWithWidth:width height:height isVertical:NO];
}

- (instancetype) initWithWidth:(CGFloat)width height:(CGFloat)height isVertical:(BOOL)isVertical{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _isVerticel = isVertical;
    }
    return self;
}

@end

@implementation YYYHomeModule{
}

- (instancetype)initWithName:(NSString *)name{
    self = [super initWithName:name];
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
            @"music":@[@"0 Love of My Life",@"1 Thank You",@"2 Yesterday Once More",@"3 You Are Not Alone",@"4 Billie Jean",@"5 Smooth Criminal",@"6 Earth Song",@"7 I will always love you",@"8 black or white"],
            @"waterFlow":@[
                    @(170),@(80),@(190),@(100),
                    @(110),@(200),@(130),
                    @(40),@(150),@(60),
            ],
            @"grid":@[[QLLiveModuleGrid gridAbsoluteHeight:50 fractionalWidth:0.25*3],
                      [QLLiveModuleGrid gridAbsoluteHeight:100 fractionalWidth:0.25*1],
                      [QLLiveModuleGrid gridAbsoluteHeight:100 fractionalWidth:0.25*2],
                      [QLLiveModuleGrid gridAbsoluteHeight:100 fractionalWidth:0.25*1],
                      [QLLiveModuleGrid gridAbsoluteHeight:150 fractionalWidth:0.25*1],
                      [QLLiveModuleGrid gridAbsoluteHeight:50 fractionalWidth:0.25*3],
            ],
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
        YYYSixComponent * comp = [[YYYSixComponent alloc] initWithTitle:@"grid"];
        [comp addDatas:[data[@"grid"] mm_randomObjects]];
        comp;
    })];
    return;
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
//
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.needPlacehold = YES;
        comp.layout.placeholdHeight = 100;
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:4];
        comp;
    })];
//
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
//
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
//return;
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
    [self.dataSource addComponent:({
        YYYFiveComponent * comp = [[YYYFiveComponent alloc] initWithTitle:@"waterFlow"];
        [comp addDatas:[data[@"waterFlow"] mm_randomObjects]];
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
    [[[HLLAlertUtil title:[self dataAtIndex:index]]
      buttons:@[@"sure"]] show];
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
        self.bSetupCell(ccell, ({
            [NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]];
        }));
    } else {
        [ccell setupWithData:({
            [NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]];
        })];
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
    self.oneLabel.text = [NSString stringWithFormat:@"%@",data];
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
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 0, 5));
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
    [ccell setupWithData:({
        [NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]];
    })];
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
        self.layout.distribution = [QLLiveComponentDistribution distributionValue:2];
        self.layout.itemRatio = [QLLiveComponentItemRatio itemRatioValue:2.0];
    }
    return self;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YYYOneCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YYYOneCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:({
        [NSString stringWithFormat:@"%d %@",index,[self dataAtIndex:index]];
    })];
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
        self.layout.distribution = [QLLiveComponentDistribution distributionValue:3];
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

@implementation YYYFiveComponent

- (instancetype) initWithTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        self.layout.customItemSize = self;
        self.layout.distribution = [QLLiveComponentDistribution distributionValue:2];
    }
    return self;
}

#pragma mark - QLLiveComponentLayoutDelegate

- (CGSize)componentLayoutCustomItemSize:(QLLiveComponentLayout *)layout atIndex:(NSInteger)index{
    
    CGFloat width = 0;
    CGFloat height = 0;
    // 这里的distribution不推荐使用absolute、fractional
    if (layout.distribution.isAbsolute) {
        width = layout.distribution.value;
    } else if (layout.distribution.isFractional) {
        width = layout.insetContainerWidth * layout.distribution.value;
    } else {
        width = (layout.insetContainerWidth - layout.interitemSpacing * (layout.distribution.value - 1)) / layout.distribution.value;
    }
    height = [[self dataAtIndex:index] integerValue];
    
    return CGSizeMake(width, height);
}

@end

@implementation YYYSixComponent

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
    // 这里的distribution不推荐使用absolute、fractional
    QLLiveModuleGrid * grid = [self dataAtIndex:index];
    CGFloat itemWidth = (layout.insetContainerWidth - 3 * layout.interitemSpacing) / 4.0;
    if (grid.isVerticel) {
        NSInteger count = grid.width / 0.25;
        width = (count - 1) * layout.interitemSpacing + count * itemWidth;
        height = grid.height;
    } else {
        
    }
    
    return CGSizeMake(width, height);
}
@end

@implementation YYYYMoveContainerView{
    MASConstraint *_centerXConstraint;
    MASConstraint *_centerYConstraint;
    
    CGPoint _translation;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMove:)];

        self.aView = [UIView new];
        self.aView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        self.aView.hidden = YES;
        [self addSubview:self.aView];
        [self.aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.left.greaterThanOrEqualTo(self);
            make.right.lessThanOrEqualTo(self);
            make.top.greaterThanOrEqualTo(self);
            make.bottom.lessThanOrEqualTo(self);
            self->_centerXConstraint = make.centerX.equalTo(self).priorityHigh();
            self->_centerYConstraint = make.centerY.equalTo(self).priorityHigh();
        }];
        [self.aView addGestureRecognizer:pan];
    }
    return self;
}

- (void) onMove:(UIPanGestureRecognizer *)gesture{
    
    CGPoint translation = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
//        _translation = CGPointZero;
        _translation = translation;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"pan translation:%@",NSStringFromCGPoint(_translation));
        
        _centerXConstraint.offset = _translation.x;
        _centerYConstraint.offset = _translation.y;
        
    } else if (gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateEnded) {
//        _translation = CGPointZero;
//        _translation = CGPointMake(<#CGFloat x#>, <#CGFloat y#>);
    }
}
@end
