//
//  MMCardViewController.m
//  Weather_App
//
//  Created by user1 on 2018/1/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMCardViewController.h"
#import "Masonry.h"
#import "HLLAttributedBuilder.h"

@interface MMCardViewController ()

@property (nonatomic ,strong) UIView * contentView;
@property (nonatomic ,strong) UIView * redView;
@property (nonatomic ,strong) UIView * orangeView;
@end

@implementation MMCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel * label = [UILabel new];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentRight;
    label.attributedText = AttBuilderWith(@"3454").attributedString;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(20);
        } else {
            // Fallback on earlier versions
        }
        make.height.mas_equalTo(30);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.contentView];
    
    self.redView = [UIView new];
    self.redView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.redView];
    
    self.orangeView = [UIView new];
    self.orangeView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.orangeView];
    NSLog(@"have orange :%d",[self.orangeView isDescendantOfView:self.view]);
}


- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//    }];
//
//    NSArray * views = @[self.redView,self.orangeView];
//
//
//    CGFloat padding2 = (375 - 2 * 50) / 3;
//    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:padding2 tailSpacing:padding2];
//    [views mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.bottom.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).mas_offset(-20);
//        } else {
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-20);
//        }
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(20);
//    }];
}
@end
