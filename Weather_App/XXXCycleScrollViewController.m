//
//  XXXCycleScrollViewController.m
//  Weather_App
//
//  Created by rocky on 2020/7/27.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXCycleScrollViewController.h"
#import "EaseCycleScrollView.h"
#import <Masonry.h>

@interface XXXBannerView : UIView

- (void) setup:(NSString *)data;
@end

@protocol XXXCycleScrollLivingViewControllerDelegate <NSObject>

- (void) livingVCDidChange:(NSString *)newData;
- (void) livingVCDidUpdate:(NSString *)newData;
- (void) livingVCDidInsert:(NSString *)newData;
- (void) livingVCDidAdd:(NSArray<NSString *> *)newDatas;
- (void) livingVCDidGoto:(NSString *)newData;
@end

@interface XXXCycleScrollLivingViewController : UIViewController

@property (nonatomic ,weak) id<XXXCycleScrollLivingViewControllerDelegate> delegate;

- (void) updateContent:(NSString *)text;

@end

@interface XXXCycleScrollViewController ()<
EaseCycleScrollViewDelegate,
XXXCycleScrollLivingViewControllerDelegate>

@property (nonatomic ,strong) EaseCycleScrollView * cycleScrollView;
@property (nonatomic ,strong) XXXCycleScrollLivingViewController * liveVC;
@end

@implementation XXXCycleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.liveVC = [XXXCycleScrollLivingViewController new];
    self.liveVC.delegate = self;

    self.cycleScrollView = [[EaseCycleScrollView alloc] initWithConfig:({
        EaseCycleScrollConfig * config = [EaseCycleScrollConfig new];
        config.axis = EaseCycleScrollAxisHorizontal;
        config;
    })];
    [self.cycleScrollView registScrollItemView:XXXBannerView.class];
    self.cycleScrollView.delegate = self;
    [self.cycleScrollView setupDataSource:@[@"one",@"two",@"three",@"four"]
                                  atIndex:2];
    [self.view addSubview:self.cycleScrollView];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - EaseCycleScrollViewDelegate

//- (__kindof UIView *)cycleScrollViewShouldAddContentView:(EaseCycleScrollView *)view{
//    return self.liveVC.view;
//}

- (BOOL) cycleScrollViewShouldScroll:(EaseCycleScrollView *)view{
    return 1;
}

- (void)cycleScrollViewUpdateItemView:(XXXBannerView *)bannerView withData:(id)data{
    [bannerView setup:data];
}

///<将要切换直播间
- (void) cycleScrollView:(EaseCycleScrollView *)view
     willBeginToggleData:(id)data{
    NSLog(@"[cycle] will begin:%@",data);
}
///<切换直播间
- (void) cycleScrollView:(EaseCycleScrollView *)view
           didToggleData:(id)data atIndex:(NSUInteger)index{
    NSLog(@"[cycle] toggle:%@",data);
    [self.liveVC updateContent:data];
}
///<完成切换直播间
- (void) cycleScrollView:(EaseCycleScrollView *)view
     didFinishToggleData:(id)data{
    NSLog(@"[cycle] did finish:%@",data);
}

#pragma mark - XXXCycleScrollLivingViewControllerDelegate

- (void)livingVCDidInsert:(NSString *)newData{
    [self.cycleScrollView insertNewData:newData];
}
- (void) livingVCDidUpdate:(NSString *)newData{
    [self.cycleScrollView updateWithNewData:newData];
}
- (void)livingVCDidChange:(NSString *)newData{
//    [self.cycleScrollView ]
}

- (void)livingVCDidAdd:(NSArray<NSString *> *)newDatas{
    
}

- (void)livingVCDidGoto:(NSString *)newData{
    [self.cycleScrollView insertNewData:newData];
}
@end

@implementation XXXCycleScrollLivingViewController{
    UILabel *_centerLabel;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView * topView = [UIView new];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    _centerLabel = [UILabel new];
    _centerLabel.backgroundColor = [UIColor orangeColor];
    _centerLabel.textColor = [UIColor whiteColor];
    _centerLabel.textAlignment = NSTextAlignmentCenter;
    _centerLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_centerLabel];
    
    UIStackView * bottomView = [UIStackView new];
    bottomView.axis = UILayoutConstraintAxisHorizontal;
    bottomView.spacing = 10;
    bottomView.distribution = UIStackViewDistributionFillEqually;
    bottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(180);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    {
        UIButton * button = [UIButton new];
        button.backgroundColor = [UIColor purpleColor];
        [button setTitle:@"Insert" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onInsert)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomView addArrangedSubview:button];
    }
    {
        UIButton * button = [UIButton new];
        button.backgroundColor = [UIColor purpleColor];
        [button setTitle:@"Update" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onUpdate)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomView addArrangedSubview:button];
    }
    {
        UIButton * button = [UIButton new];
        button.backgroundColor = [UIColor purpleColor];
        [button setTitle:@"Replace" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onReplace)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomView addArrangedSubview:button];
    }
    {
        UIButton * button = [UIButton new];
        button.backgroundColor = [UIColor purpleColor];
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onAdd)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomView addArrangedSubview:button];
    }
    {
        UIButton * button = [UIButton new];
        button.backgroundColor = [UIColor purpleColor];
        [button setTitle:@"Goto" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onGoto)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomView addArrangedSubview:button];
    }
}

- (void) updateContent:(NSString *)text{
    _centerLabel.text = text;
}

- (void) onInsert{
    [self.delegate livingVCDidInsert:@"6666"];
}
- (void) onUpdate{
    [self.delegate livingVCDidUpdate:@"00000"];
}
- (void) onReplace{
    [self.delegate livingVCDidChange:@"4567"];
}
- (void) onAdd{
    [self.delegate livingVCDidAdd:@[@"aaaa",@"bbbb",@"cc"]];
}
- (void) onGoto{
    [self.delegate livingVCDidGoto:@"3"];
}
@end

@implementation XXXBannerView{
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (void) setup:(NSString *)data{
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",data]];
}

@end
