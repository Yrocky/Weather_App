//
//  NoticeScrollViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/23.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "NoticeScrollViewController.h"
#import "XXXNoticeScrollView.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "XXXAutoScrollImageView.h"

@interface NoticeScrollViewController ()<XXXNoticeScrollViewDelegate>

@property (nonatomic ,strong) UIView * oneView;
@property (nonatomic ,strong) UIView * otherView;
@property (nonatomic ,strong) UIView * thirdView;
@end

@implementation NoticeScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oneView = [UIView new];
    self.oneView.restorationIdentifier = @"oneView";
    self.oneView.backgroundColor = [UIColor redColor];
    
    self.otherView = [UIView new];
    self.otherView.restorationIdentifier = @"otherView";
    self.otherView.backgroundColor = [UIColor orangeColor];
    
    self.thirdView = [UIView new];
    self.thirdView.restorationIdentifier = @"thridView";
    self.thirdView.backgroundColor = [UIColor purpleColor];
    
    if (0){
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2.5];
        scrollView.delegate = self;
        [scrollView addContentViews:@[self.oneView,self.otherView,self.thirdView]];
        
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(50);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(20);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(20);
            }
        }];
    }
    if(0){
        UILabel * oneView = [UILabel new];
        oneView.restorationIdentifier = @"oneView";
        oneView.text = @"oneeeeeeeeeeeView";
        oneView.backgroundColor = [UIColor redColor];
        
        UILabel * otherView = [UILabel new];
        otherView.restorationIdentifier = @"otherView";
        otherView.text = @"oooooooootherView";
        otherView.backgroundColor = [UIColor orangeColor];
        
        UILabel * thirdView = [UILabel new];
        thirdView.restorationIdentifier = @"thridView";
        thirdView.text = @"thrrrrrrrrrridView";
        thirdView.backgroundColor = [UIColor purpleColor];
        
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2];
        scrollView.delegate = self;
        scrollView.duration = 2;
        scrollView.direction = XXXNoticeScrollDirectionVertical;
        [scrollView addContentViews:@[oneView,otherView,thirdView]];
        
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(120);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(120);
            }
        }];
    }
    if (0){
        UIView * oneView = [UIView new];
        oneView.restorationIdentifier = @"oneView";
        oneView.backgroundColor = [UIColor redColor];
        
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2];
        scrollView.delegate = self;
        scrollView.duration = 4;
        scrollView.direction = XXXNoticeScrollDirectionHorizontal;
        [scrollView addContentViews:@[oneView]];
        
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(160);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(160);
            }
        }];
    }
    
    {
        XXXAutoScrollImageView * scrollView = [[XXXAutoScrollImageView alloc] initWithDirection:XXXAutoScrollDirectionVertical];
        scrollView.layer.cornerRadius = 5;
        scrollView.layer.masksToBounds = YES;
        scrollView.duration = 20.0f;
//        [scrollView setupImage:@"sunset"];
        [scrollView setupImage:@"http://out8i00tg.bkt.clouddn.com/FpwfCXsZMGOWXKv6mj1PigOoDQU5"
                   placeholder:@"sunset"];
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(20);
            make.right.equalTo(self.view).mas_offset(-20);
            make.height.mas_equalTo(100);
            make.top.equalTo(self.view.mas_centerY);
        }];
    }
}

#pragma mark - XXXNoticeScrollViewDelegate

- (void) noticeScrollView:(XXXNoticeScrollView *)view didSelected:(UIView *)contentView at:(NSInteger)index{
    NSLog(@"[Timer] didSelectedAt:%d",index);
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
