//
//  HomeViewController.m
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeBillContainerView.h"
#import "HomeBillContentView.h"
#import "UIColor+Common.h"
#import "Masonry.h"
#import "FDPresentingAnimator.h"
#import "FDDismissingAnimator.h"
#import "BillViewController.h"

@interface HomeViewController ()<HomeBillContainerViewDelegate>

@property (nonatomic ,strong) HomeBillContainerView * containerView;

@property (nonatomic ,strong) HomeBillContentView * contentView;

@property (nonatomic ,strong) UIButton * addBillButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bill";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleDone target:self action:@selector(onGotoToday)];
    self.navigationItem.rightBarButtonItem = right;
    self.containerView = [[HomeBillContainerView alloc] init];
    self.containerView.tag = 0;
    self.containerView.delegate = self;
//    self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:self.containerView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view);
        }
        make.width.mas_equalTo(self.view);
    }];
    
    HomeBillContentView * contentView = [HomeBillContentView new];
    self.contentView = contentView;
    [self.containerView configBillContentView:self.contentView];
    
    self.addBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBillButton setTitle:@"记一笔" forState:UIControlStateNormal];
    self.addBillButton.backgroundColor = [UIColor redColor];
    [self.addBillButton addTarget:self action:@selector(onAddBillAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addBillButton];
    [self.addBillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-30);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-30);
        }
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(50);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-50);
    }];
}

- (void) onGotoToday{
    
    NSCalendar * cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour fromDate:[NSDate date]];
    comp.day = 30;
    comp.month = 3;// 2018-3-30
    NSDate * debugDate = [cal dateFromComponents:comp];
    debugDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSLog(@"debugDate:%@",[formatter stringFromDate:debugDate]);
    NSLog(@"currentDate:%@",[formatter stringFromDate:self.contentView.currentDate]);
    
    // 模拟根据一些日期进行跳转
    if ([self.contentView currentDateCompare:debugDate] == NSOrderedDescending) {// -1
        NSLog(@"debugDate is currentDate 以前");
        [self.containerView moveContentViewFromLeftSide];
        [self.contentView updateContentViewFor:debugDate];
    }
    else if ([self.contentView currentDateCompare:debugDate] == NSOrderedAscending){// 1
        NSLog(@"debugDate is currentDate 以后");
        [self.containerView moveContentViewFromRightSide];
        [self.contentView updateContentViewFor:debugDate];
    }
    else if ([self.contentView currentDateCompare:debugDate] == NSOrderedSame){
        NSLog(@"debugDate is currentDate");
    }
}
#pragma mark - HomeBillContainerViewDelegate

- (void) billContainerViewNeedUpdatePreContentView:(HomeBillContainerView *)containerView{

    [self.contentView updateContentViewWithPreDate];
//    self.contentView.backgroundColor = [UIColor randomColor];
}

- (void) billContainerViewNeedUpdateNextContentView:(HomeBillContainerView *)containerView{
    
    [self.contentView updateContentViewWithNextDate];
//    self.contentView.backgroundColor = [UIColor randomColor];
}

- (BOOL)allowBillContainerViewLoadPreContentView:(HomeBillContainerView *)containterView{
    
    // 在这里根据contentView的日期判断是否可以加载
    return 1;//[self.contentView currentDateIsMinDate];
}

- (BOOL)allowBillContainerViewLoadNextContentView:(HomeBillContainerView *)containterView{
    return [self.contentView currentDateIsMaxDate];
}

- (void) onAddBillAction{

    BillViewController * bill = [[BillViewController alloc] init];
    [self presentViewController:bill animated:YES completion:nil];
}

#pragma mark - 定制转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    return [FDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [FDDismissingAnimator new];
}

@end
