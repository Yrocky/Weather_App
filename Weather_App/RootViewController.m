//
//  RootViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "RootViewController.h"
#import "HSTitleCellModel.h"
#import "MM_AutoReplyViewController.h"
#import "MMGiftEffectViewController.h"
#import "TableDemoViewController.h"
#import "MMSearchViewController.h"
#import "HLLIndicatorViewController.h"
#import "ANYMethodLog.h"
#import "FDViewController.h"
#import "FDPresentingAnimator.h"
#import "FDDismissingAnimator.h"
#import "CreatePDFViewController.h"
#import "MarkdownRenderHTMLViewController.h"
#import "MM_FindFriendEntryViewController.h"
#import "LayoutViewController.h"
#import "MMCollectionViewController.h"
#import "MMXibViewController.h"
#import "MMCardViewController.h"
#import "MMAnimationViewController.h"
#import "AsyncDrawViewController.h"
#import "RunwayViewController.h"
#import "HomeViewController.h"
#import "ExtensionViewController.h"
#import "ProxyViewController.h"
#import "MMCoreTextViewController.h"
#import "RoundCornerViewController.h"
#import "GiftEffectViewController.h"
#import "SignalViewController.h"
#import "MMGradientViewController.h"
#import "EmojiViewController.h"

@interface RootViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic ,strong) NSString * str;
@end

@implementation RootViewController

- (void) printSome{

    NSLog(@"+_+_+_+");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Root";
    self.str = @"123";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printSome) name:@"noti_mm_custom" object:nil];
    [ANYMethodLog logMethodWithClass:[HSTableViewModel class] condition:^BOOL(SEL sel) {
        
        return [NSStringFromSelector(sel) isEqualToString:@"addSection:"];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        NSLog(@" before target:%@ sel:%@",target,NSStringFromSelector(sel));
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        
    }];
    
    [self.tableViewModel addSection:({
        
        HSSectionModel * s = [[HSSectionModel alloc] init];
        s.heightForHeader = 0;
        
        HSTitleCellModel * c = [[HSTitleCellModel alloc] initWithTitle:@"原来的Main控制器" actionBlock:^(HSBaseCellModel *model) {
            
            [self performSegueWithIdentifier:@"RootToMain" sender:nil];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🙈Emoji🙉" actionBlock:^(HSTitleCellModel *model) {
            
            EmojiViewController * vc = [[EmojiViewController alloc] init];
            vc.title = model.title;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"渐变" actionBlock:^(HSBaseCellModel *model) {
            
            MMGradientViewController * vc = [[MMGradientViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"信号" actionBlock:^(HSBaseCellModel *model) {
            
            SignalViewController * vc = [[SignalViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"礼物特效" actionBlock:^(HSBaseCellModel *model) {
            
            GiftEffectViewController * vc = [[GiftEffectViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"NSProxy" actionBlock:^(HSBaseCellModel *model) {
            
            ProxyViewController * vc = [[ProxyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"圆角问题" actionBlock:^(HSBaseCellModel *model) {
            
            RoundCornerViewController * vc = [[RoundCornerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Core Text" actionBlock:^(HSBaseCellModel *model) {
            
            MMCoreTextViewController * vc = [[MMCoreTextViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"记账-拓展功能" actionBlock:^(HSBaseCellModel *model) {
            
            ExtensionViewController * vc = [[ExtensionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"记账-首页" actionBlock:^(HSBaseCellModel *model) {
            
            HomeViewController * vc = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Runway" actionBlock:^(HSBaseCellModel *model) {

            RunwayViewController * vc = [[RunwayViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"礼物效果" actionBlock:^(HSBaseCellModel *model) {

            MMGiftEffectViewController * vc = [[MMGiftEffectViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"自动回复" actionBlock:^(HSBaseCellModel *model) {

            MM_AutoReplyViewController * vc = [[MM_AutoReplyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"模型化TableView" actionBlock:^(HSBaseCellModel *model) {

            TableDemoViewController * vc = [[TableDemoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"CollectionView折叠" actionBlock:^(HSBaseCellModel *model) {

            MMSearchViewController * vc = [[MMSearchViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"粘性指引视图" actionBlock:^(HSBaseCellModel *model) {

            HLLIndicatorViewController * vc = [[HLLIndicatorViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"咸鱼首页" actionBlock:^(HSBaseCellModel *model) {

            FDViewController * vc = [[FDViewController alloc] init];
            vc.transitioningDelegate  = self;
            vc.modalPresentationStyle = UIModalPresentationCustom;
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"生成PDF" actionBlock:^(HSBaseCellModel *model) {

            CreatePDFViewController * vc = [[CreatePDFViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"渲染HTML" actionBlock:^(HSBaseCellModel *model) {

            MarkdownRenderHTMLViewController * vc = [[MarkdownRenderHTMLViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"发现界面" actionBlock:^(HSBaseCellModel *model) {

            MM_FindFriendEntryViewController * vc = [[MM_FindFriendEntryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"布局" actionBlock:^(HSBaseCellModel *model) {

            LayoutViewController * vc = [[LayoutViewController alloc] init];
            vc.title = @"布局";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Collection" actionBlock:^(HSBaseCellModel *model) {

            MMCollectionViewController * vc = [[MMCollectionViewController alloc] init];
            vc.title = @"Collection";
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated: 1 completion:nil];
        }];
        [s addCellModel:c];


        c = [[HSTitleCellModel alloc] initWithTitle:@"Xib" actionBlock:^(HSBaseCellModel *model) {

            MMXibViewController * vc = [[MMXibViewController alloc] init];
            vc.title = @"Xib";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Card" actionBlock:^(HSBaseCellModel *model) {

            MMCardViewController * vc = [[MMCardViewController alloc] init];
            vc.title = @"Card";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Animation" actionBlock:^(HSBaseCellModel *model) {

            MMAnimationViewController * vc = [[MMAnimationViewController alloc] init];
            vc.title = @"Animation";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Async" actionBlock:^(HSBaseCellModel *model) {

            AsyncDrawViewController * vc = [[AsyncDrawViewController alloc] init];
            vc.title = @"Async";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [s addCellModel:c];
        
        s;
    })];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mm_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void) mm_didReceiveMemoryWarning{
    NSLog(@"RootViewController warning");
}

- (void)didReceiveMemoryWarning{
    NSLog(@"RootViewController override warning");
}

- (BOOL)prefersStatusBarHidden{
    
    return NO;
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
