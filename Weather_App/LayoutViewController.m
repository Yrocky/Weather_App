//
//  LayoutViewController.m
//  Weather_App
//
//  Created by user1 on 2017/11/10.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "LayoutViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "BottomFollowView.h"
#import "SomeCustomView.h"
#import "MMLabel.h"
#import "MMAObject.h"
//#import "MMBObject.h"


@interface UIView (Color)

+ (instancetype) redView;
+ (instancetype) greenView;
@end

@implementation UIView (Color)

+ (instancetype) redView{
    
    UIView * v = [UIView new];
    v.restorationIdentifier = @"redView";
    v.translatesAutoresizingMaskIntoConstraints = false;
    v.backgroundColor = [UIColor redColor];
    return v;
}
+ (instancetype) greenView{
    
    UIView * v = [UIView new];
    v.restorationIdentifier = @"greenView";
    v.translatesAutoresizingMaskIntoConstraints = false;
    v.backgroundColor = [UIColor greenColor];
    return v;
}
@end

@interface LayoutViewController ()

@end

@implementation LayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    id bObject = [MMBObject new];
//    [bObject doSomthing:100];
    
    id aObject = [[MMOtherObject new] getBObject];
    [aObject doSomthing:100];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * orangeView = [UIView redView];
    orangeView.backgroundColor = [UIColor colorWithHexString:@"#2A3142"];
    [self.view addSubview:orangeView];
    
    {
        
        if (@available(iOS 11.0, *)) {
            [orangeView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = YES;
            [orangeView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
            [orangeView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = YES;
            [orangeView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        } else {
            [orangeView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
            [orangeView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
            [orangeView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
            [orangeView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
        }
    }
    
    UIView * redView = [UIView redView];
    [self.view addSubview:redView];
    
    UIView * greenView = [UIView greenView];
    [self.view addSubview:greenView];
    
    CGFloat width = 50;
    
    // Frame
    redView.frame = CGRectMake(20, 10, width, width);
    greenView.frame = CGRectMake(self.view.frame.size.width - width - 20, 10, width, width);
    
    // NSLayoutAnchor
    UIView * redView_layoutAnchor = [UIView redView];
    [self.view addSubview:redView_layoutAnchor];
    UIView * greenView_layoutAnchor = [UIView greenView];
    [self.view addSubview:greenView_layoutAnchor];
    
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    
    [redView_layoutAnchor.leftAnchor constraintEqualToAnchor:margin.leftAnchor constant:0].active = YES;
    [redView_layoutAnchor.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:100].active = YES;
    [redView_layoutAnchor.widthAnchor constraintEqualToConstant:width].active = YES;
    [redView_layoutAnchor.heightAnchor constraintGreaterThanOrEqualToAnchor:redView_layoutAnchor.widthAnchor].active = YES;
    
    [greenView_layoutAnchor.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
    [greenView_layoutAnchor.widthAnchor constraintEqualToAnchor:redView_layoutAnchor.widthAnchor].active = YES;
    [greenView_layoutAnchor.heightAnchor constraintEqualToAnchor:redView_layoutAnchor.heightAnchor].active = YES;
    [greenView_layoutAnchor.centerYAnchor constraintEqualToAnchor:redView_layoutAnchor.centerYAnchor].active = YES;
    
    // Masonry
    UIView * redView_masonry = [UIView redView];
    [self.view addSubview:redView_masonry];
    UIView * greenView_masonry = [UIView greenView];
    [self.view addSubview:greenView_masonry];
    
    [redView_masonry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(redView_layoutAnchor.mas_bottom).mas_offset(20);
    }];
    [greenView_masonry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(redView_masonry);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.centerY.mas_equalTo(redView_masonry);
    }];
    
    // UIStackView
    
    UIView * superView = [[UIView alloc] init];
    [self.view addSubview:superView];
    superView.backgroundColor = [UIColor whiteColor];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(redView_masonry.mas_bottom).mas_offset(40);
    }];
    
    UIView * sureView = [UIView redView];
    [superView addSubview:sureView];
    
    UIView * cancelView = [UIView redView];
    [superView addSubview:cancelView];
    
    UIView * clearView = [UIView redView];
    [superView addSubview:clearView];
    
    UILayoutGuide * g1 = [[UILayoutGuide alloc] init];
    UILayoutGuide * g2 = [[UILayoutGuide alloc] init];
    UILayoutGuide * g3 = [[UILayoutGuide alloc] init];
    UILayoutGuide * g4 = [[UILayoutGuide alloc] init];
    [superView addLayoutGuide:g1];
    [superView addLayoutGuide:g2];
    [superView addLayoutGuide:g3];
    [superView addLayoutGuide:g4];
    
    [g1.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [g1.widthAnchor constraintEqualToAnchor:g2.widthAnchor].active = YES;
    [g2.widthAnchor constraintEqualToAnchor:g3.widthAnchor].active = YES;
    [g2.leadingAnchor constraintEqualToAnchor:sureView.trailingAnchor].active = YES;
    [g3.widthAnchor constraintEqualToAnchor:g4.widthAnchor].active = YES;
    [g3.leadingAnchor constraintEqualToAnchor:cancelView.trailingAnchor].active = YES;
    [g4.widthAnchor constraintEqualToAnchor:sureView.widthAnchor].active = YES;
    [g4.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [g4.leadingAnchor constraintEqualToAnchor:clearView.trailingAnchor].active = YES;
    
    //
    [sureView.centerYAnchor constraintEqualToAnchor:superView.centerYAnchor].active = YES;
    [sureView.widthAnchor constraintEqualToConstant:90].active = YES;
    [sureView.heightAnchor constraintEqualToConstant:60].active = YES;
    [sureView.leadingAnchor constraintEqualToAnchor:g1.trailingAnchor].active = YES;
    
    //
    [cancelView.widthAnchor constraintEqualToAnchor:sureView.widthAnchor].active = YES;
    [cancelView.heightAnchor constraintEqualToAnchor:sureView.heightAnchor].active = YES;
    [cancelView.topAnchor constraintEqualToAnchor:sureView.topAnchor].active = YES;
    [cancelView.leadingAnchor constraintEqualToAnchor:g2.trailingAnchor].active = YES;
    
    //
    [clearView.widthAnchor constraintEqualToAnchor:cancelView.widthAnchor].active = YES;
    [clearView.heightAnchor constraintEqualToAnchor:sureView.heightAnchor].active = YES;
    [clearView.topAnchor constraintEqualToAnchor:sureView.topAnchor].active = YES;
    [clearView.leadingAnchor constraintEqualToAnchor:g3.trailingAnchor].active = YES;
    
    
//    BottomFollowView * followView = [BottomFollowView commitView];
//    [self.view addSubview:followView];
//    [followView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
    
    MMLabel * label = [[MMLabel alloc] init];
    label.edgeInsets          = UIEdgeInsetsMake(8, 8 + 10, 8, 8 + 10); // 设置内边距
    label.font                = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.f];
    label.text                = @"No Zuo No Die";
    label.backgroundColor     = [UIColor blackColor];
    label.textColor           = [UIColor redColor];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.top.mas_equalTo(superView.mas_bottom).mas_offset(20);
    }];
    
    
    MMLabel * label2 = [[MMLabel alloc] init];
    label2.font                = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.f];
    label2.text                = @"No Zuo No Die";
    label2.backgroundColor     = [UIColor blackColor];
    label2.textColor           = [UIColor redColor];
    [self.view addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(label.mas_bottom).mas_offset(10);
    }];
    
    [self addDependentView];
}

- (void) addDependentView{
    
    UIView * baseView = [UIView new];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 100));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
        } else {
            // Fallback on earlier versions
        }
        make.centerX.equalTo(self.view);
    }];
    {// 右边居中
        UIView * redView = [UIView redView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            //
            make.centerY.mas_equalTo(baseView);
            make.centerX.mas_equalTo(baseView.mas_trailing);
        }];
    }
    {// 左上角
        UIView * redView = [UIView greenView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(baseView.mas_top);
            make.centerX.mas_equalTo(baseView.mas_leading);
        }];
    }
    {// 左下角
        UIView * redView = [UIView greenView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(baseView.mas_bottom);
            make.centerX.mas_equalTo(baseView.mas_leading);
        }];
    }
    {// 右上角
        UIView * redView = [UIView greenView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(baseView.mas_top);
            make.centerX.mas_equalTo(baseView.mas_trailing);
        }];
    }
    {// 右下角
        UIView * redView = [UIView greenView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(baseView.mas_bottom);
            make.centerX.mas_equalTo(baseView.mas_trailing);
        }];
    }
    {// 下面居中
        UIView * redView = [UIView greenView];
        [self.view addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(baseView.mas_bottom);
            make.centerX.mas_equalTo(baseView);
            //            make.centerX.mas_equalTo(baseView.mas_top);
        }];
    }
}

@end
