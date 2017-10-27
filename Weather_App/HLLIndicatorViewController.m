//
//  HLLIndicatorViewController.m
//  Weather_App
//
//  Created by user1 on 2017/10/26.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLIndicatorViewController.h"
#import "HLLStickIndicator.h"
#import "HSTitleCellModel.h"

@interface HLLIndicatorViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic ,strong) HLLStickIndicatorView * topIndicatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * leftIndicatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * rightIndicatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * bottomIndicatorView;
@end

@implementation HLLIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Indicator";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:(CGRect){
        CGPointZero,
        self.view.bounds.size.width,20
    }];
    [self.view addSubview:label];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){
        0,0,
        self.view.bounds.size.width,
        self.view.bounds.size.height
    }];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.00];
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.delegate = self;
    
    //
    self.topIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorTop frame:(CGRect){
        0,0,
        {self.view.frame.size.width,60}
    }];
    [self.scrollView addSubview:self.topIndicatorView];
    
    //
    self.leftIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorLeft frame:(CGRect){
        0,0,
        60,200
    }];
    [self.leftIndicatorView configIndicatorInfo:@"加载\n前一篇"];
    self.leftIndicatorView.center = self.view.center;
    CGRect frame = self.leftIndicatorView.frame;
    frame.origin.x = -60 + 60;
    self.leftIndicatorView.frame = frame;
    [self.scrollView addSubview:self.leftIndicatorView];
    
    //
    self.rightIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight frame:(CGRect){
        0,0,
        60,200
    }];
    [self.rightIndicatorView configIndicatorInfo:@"加载\n下一篇"];
    self.rightIndicatorView.center = self.view.center;
    frame = self.rightIndicatorView.frame;
    frame.origin.x = self.view.frame.size.width-60;
    self.rightIndicatorView.frame = frame;
    [self.scrollView addSubview:self.rightIndicatorView];
    
    //
    self.bottomIndicatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorBottom frame:(CGRect){
        0,self.scrollView.frame.size.height - 60,
        {self.view.frame.size.width,60}
    }];
    [self.scrollView addSubview:self.bottomIndicatorView];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = (CGSize){
        self.view.bounds.size.width,
        self.view.bounds.size.height - 64
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.y : %f",scrollView.contentOffset.y);
    CGFloat percent = fabs(-scrollView.contentOffset.y) / 120;
//    [self.topIndicatorView update:percent];
//
//    percent = fabs(-scrollView.contentOffset.x) / 40;
//    [self.leftIndicatorView update:percent];
////
//    percent = fabs(scrollView.contentOffset.x) / 40;
//    [self.rightIndicatorView update:percent];
    
    percent = fabs(-scrollView.contentOffset.y) / 60;
    [self.bottomIndicatorView update:percent];
}

@end
