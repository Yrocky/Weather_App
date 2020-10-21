//
//  XXXLayoutCalculatorViewController.m
//  Weather_App
//
//  Created by rocky on 2020/8/9.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXLayoutCalculatorViewController.h"
#import "QLLiveLayoutCalculator.h"
#import "UIColor+Common.h"
#import <Masonry.h>

@interface XXXSomeView : UIView

- (void) setup:(id)data;

@property (nonatomic ,copy) void(^bSomeBlock)(XXXSomeView *someView);
@end

@implementation XXXSomeView{
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];

        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:10];
        _label.textColor = [UIColor blackColor];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}
- (void) setup:(id)data{
    _label.text = [NSString stringWithFormat:@"%@",data];
    if (self.bSomeBlock) {
        self.bSomeBlock(self);
    }
}

@end
@interface XXXLayoutCalculatorViewController ()

@property (nonatomic ,strong) QLLiveLayoutCalculator * calculator;
@property (nonatomic ,assign) CGFloat ScreenWith;
@end

@implementation XXXLayoutCalculatorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
    
    @weakify(self);
    XXXSomeView * someView = [XXXSomeView new];
    [someView setBSomeBlock:^(XXXSomeView *someView) {
        @strongify(self);
        NSLog(@"__slef:%@",self);
        NSLog(@"__someView:%@",someView);
    }];
    [someView setup:@"aaa"];
    
    return;
//    {
//        UIView * waterflowView = [UIView new];
//        [self.view addSubview:waterflowView];
//        [waterflowView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.top.mas_equalTo(10);
//            make.height.mas_equalTo(310);
//        }];
//        self.calculator = [QLLiveLayoutCalculator new];
//        self.calculator.column = 4;
//        self.calculator.renderDirection = QLLiveWaterfallLayoutRenderShortestFirst;
//        self.calculator.containerWidth = self.ScreenWith;
//        [[self.calculator calculatorWaterfallLayoutWith:[self waterfallLayout]]
//         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            XXXSomeView * someView = [XXXSomeView new];
//            [someView setup:({
//                @(idx);
////                [NSString stringWithFormat:@"%d\n%.0f",idx,obj.CGRectValue.size.height];
//            })];
//            someView.frame = obj.CGRectValue;
//            [waterflowView addSubview:someView];
//        }];
//    }
//    return;
//    UIView * listView = [UIView new];
//    {
//
//        [self.view addSubview:listView];
//        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(310);
//        }];
//        self.calculator = [QLLiveLayoutCalculator new];
//        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
//        self.calculator.lineSpacing = 1.0f;
//        self.calculator.distribution = [QLLiveLayoutDistribution distributionValue:1];
////        self.calculator.itemRatio = [QLLiveLayoutItemRatio itemRatioValue:12.0];
//        self.calculator.itemRatio = [QLLiveLayoutItemRatio absoluteValue:50];
//        self.calculator.containerWidth = self.ScreenWith;
//        [[self.calculator calculatorListLayoutWith:[self listLayout]]
//         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            XXXSomeView * someView = [XXXSomeView new];
//            [someView setup:@(idx)];
//            someView.frame = obj.CGRectValue;
//            [listView addSubview:someView];
//        }];
//    }
//
//    {
//        UIView * startView = [UIView new];
//
//        [self.view addSubview:startView];
//        [startView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.top.mas_equalTo(listView.mas_bottom);
//            make.height.mas_equalTo(320);
//        }];
//        self.calculator = [QLLiveLayoutCalculator new];
//        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
//        self.calculator.distribution = [QLLiveLayoutDistribution distributionValue:3];
//        self.calculator.itemRatio = [QLLiveLayoutItemRatio itemRatioValue:0.8];
//        self.calculator.containerWidth = self.ScreenWith;
//        [[self.calculator calculatorListLayoutWith:[self listLayout]]
//         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            XXXSomeView * someView = [XXXSomeView new];
//            [someView setup:@(idx)];
//            someView.frame = obj.CGRectValue;
//            [startView addSubview:someView];
//        }];
//    }
//    return;
    UIView * startView = [UIView new];
    {
        
        [self.view addSubview:startView];
        [startView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(120);
        }];
        self.calculator = [QLLiveLayoutCalculator new];
        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
        self.calculator.containerWidth = self.ScreenWith;
        self.calculator.justifyContent = QLLiveFlexLayoutFlexStart;
        [[self.calculator calculatorFlexLayoutWith:[self flexLayout]]
         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXXSomeView * someView = [XXXSomeView new];
            [someView setup:@(idx)];
            someView.frame = obj.CGRectValue;
            [startView addSubview:someView];
        }];
    }
    UIView * endView = [UIView new];
    {
        [self.view addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(startView.mas_bottom);
            make.height.mas_equalTo(startView);
        }];
        self.calculator = [QLLiveLayoutCalculator new];
        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
        self.calculator.containerWidth = self.ScreenWith;
        self.calculator.justifyContent = QLLiveFlexLayoutFlexEnd;
        [[self.calculator calculatorFlexLayoutWith:[self flexLayout]]
         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXXSomeView * someView = [XXXSomeView new];
            [someView setup:@(idx)];
            someView.frame = obj.CGRectValue;
            [endView addSubview:someView];
        }];
    }
    UIView * centerView = [UIView new];
    {
        [self.view addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(endView.mas_bottom);
            make.height.mas_equalTo(endView);
        }];
        self.calculator = [QLLiveLayoutCalculator new];
        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
        self.calculator.containerWidth = self.ScreenWith;
        self.calculator.justifyContent = QLLiveFlexLayoutCenter;
        [[self.calculator calculatorFlexLayoutWith:[self flexLayout]]
         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXXSomeView * someView = [XXXSomeView new];
            [someView setup:@(idx)];
            someView.frame = obj.CGRectValue;
            [centerView addSubview:someView];
        }];
    }
    UIView * betweenView = [UIView new];
    {
        [self.view addSubview:betweenView];
        [betweenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(centerView.mas_bottom);
            make.height.mas_equalTo(centerView);
        }];
        self.calculator = [QLLiveLayoutCalculator new];
        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
        self.calculator.containerWidth = self.ScreenWith;
        self.calculator.justifyContent = QLLiveFlexLayoutSpaceBetween;
        [[self.calculator calculatorFlexLayoutWith:[self flexLayout]]
         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXXSomeView * someView = [XXXSomeView new];
            [someView setup:@(idx)];
            someView.frame = obj.CGRectValue;
            [betweenView addSubview:someView];
        }];
    }
    UIView * aroundView = [UIView new];
    {
        [self.view addSubview:aroundView];
        [aroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(betweenView.mas_bottom);
            make.height.mas_equalTo(betweenView);
        }];
        self.calculator = [QLLiveLayoutCalculator new];
        self.ScreenWith = [UIScreen mainScreen].bounds.size.width;
        self.calculator.containerWidth = self.ScreenWith;
        self.calculator.justifyContent = QLLiveFlexLayoutSpaceAround;
        [[self.calculator calculatorFlexLayoutWith:[self flexLayout]]
         enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XXXSomeView * someView = [XXXSomeView new];
            [someView setup:@(idx)];
            someView.frame = obj.CGRectValue;
            [aroundView addSubview:someView];
        }];
    }
}

- (NSArray<NSValue *> *) listLayout{
    return @[@"12",@"23",@"3",@"4",@"55",@"666"];
}

- (void) gridLayout{
    
}

- (NSArray<NSNumber *> *) waterfallLayout{
    return @[
        @(100),@(150),@(50),
        @(100),@(80),@(30),
        @(200),@(45),@(110),
        @(67),@(20),@(50),@(33),
        @(28),@(62),@(77)
    ];

}

- (NSArray<NSNumber *> *) flexLayout{
    
    CGFloat width = 50;
    return @[@(width),@(width*2),@(width*3),@(width),
             @(width*1.8),@(width*0.3),@(width*0.6),
             @(width*3),@(width*0.7),@(width*0.3),
             @(width*2),@(width)
    ];
}

@end
