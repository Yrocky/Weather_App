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
#import "ALBookDemoViewController.h"
#import "PromiseKitViewController.h"
#import "CardCollectionViewController.h"
#import "RoomModel.h"
#import "MMNavigationController.h"
#import "XXXWebViewController.h"
#import "FishBoViewController.h"
#import "InterpreterViewController.h"
#import "ResumeViewController.h"
#import "NoticeScrollViewController.h"
#import "OldLoginViewController.h"
#import "FinanceViewController.h"
#import <JLRoutes/JLRoutes.h>

#define weakify(...) autoreleasepool {} __attribute__((objc_ownership(weak))) __typeof__(self) self_weak_ = (self);

#define strongify(...) autoreleasepool {} __attribute__((objc_ownership(strong))) __typeof__(self) self = self_weak_;

#define MMLiveRoute [JLRoutes routesForScheme:@"MMLive"]

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
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    } else {
        // Fallback on earlier versions
    }
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printSome) name:@"noti_mm_custom" object:nil];
    [ANYMethodLog logMethodWithClass:[HSTableViewModel class] condition:^BOOL(SEL sel) {
        @strongify(self);

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
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🦋365计划🦋" actionBlock:^(HSTitleCellModel *model) {
            
//            FinanceViewController * vc = [[FinanceViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/FinanceViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🍒Login🍒" actionBlock:^(HSTitleCellModel *model) {
//            OldLoginViewController * vc = [[OldLoginViewController alloc] init];
//            MMNavigationController * navi = [[MMNavigationController alloc] initWithRootViewController:vc];
//            [self.navigationController presentViewController:navi animated:YES completion:nil];
            
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"present/OldLoginViewController?title=%@&addNavi=true",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🍇NoticeScroll🍇" actionBlock:^(HSTitleCellModel *model) {
            
//            NoticeScrollViewController * vc = [[NoticeScrollViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/NoticeScrollViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🍇Resume🍇" actionBlock:^(HSTitleCellModel *model) {

//            ResumeViewController * vc = [[ResumeViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ResumeViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🥩解释器模式🥩" actionBlock:^(HSTitleCellModel *model) {
            
//            InterpreterViewController * vc = [[InterpreterViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/InterpreterViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🍗辣鸡bo🍗" actionBlock:^(HSTitleCellModel *model) {
            
//            FishBoViewController * vc = [[FishBoViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/FishBoViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
       
        c = [[HSTitleCellModel alloc] initWithTitle:@"🍳webview🍳" actionBlock:^(HSTitleCellModel *model) {
            
//            XXXWebViewController * vc = [[XXXWebViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/XXXWebViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🥪直播间无限轮滑🥪" actionBlock:^(HSTitleCellModel *model) {
            
            CardCollectionViewController * vc = [[CardCollectionViewController alloc] init];
            vc.title = model.title;
            [vc setupDataSource:[RoomModel dataSource] roomIndex:2];
            MMNavigationController * navi = [[MMNavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
            
//            [MMLiveRoute routeURL:[NSURL URLWithString:({
//                [NSString stringWithFormat:@"push/HLLIndicatorViewController?title=%@",model.title];
//            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🧐PromiseKit🧐" actionBlock:^(HSTitleCellModel *model) {
            
//            PromiseKitViewController * vc = [[PromiseKitViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/PromiseKitViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🙈Emoji🙉" actionBlock:^(HSTitleCellModel *model) {
            
//            EmojiViewController * vc = [[EmojiViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/EmojiViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"🥧Auto Layout🌮" actionBlock:^(HSTitleCellModel *model) {
            
//            ALBookDemoViewController * vc = [[ALBookDemoViewController alloc] init];
//            vc.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ALBookDemoViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"渐变" actionBlock:^(HSTitleCellModel *model) {
            
//            MMGradientViewController * vc = [[MMGradientViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMGradientViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"信号" actionBlock:^(HSTitleCellModel *model) {
            
//            SignalViewController * vc = [[SignalViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/SignalViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"礼物特效" actionBlock:^(HSTitleCellModel *model) {
            
//            GiftEffectViewController * vc = [[GiftEffectViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/GiftEffectViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"NSProxy" actionBlock:^(HSTitleCellModel *model) {
            
//            ProxyViewController * vc = [[ProxyViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ProxyViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"圆角问题" actionBlock:^(HSTitleCellModel *model) {
            
//            RoundCornerViewController * vc = [[RoundCornerViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/RoundCornerViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Core Text" actionBlock:^(HSTitleCellModel *model) {
            
//            MMCoreTextViewController * vc = [[MMCoreTextViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMCoreTextViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"记账-拓展功能" actionBlock:^(HSTitleCellModel *model) {
            
//            ExtensionViewController * vc = [[ExtensionViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ExtensionViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"记账-首页" actionBlock:^(HSTitleCellModel *model) {
            
//            HomeViewController * vc = [[HomeViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/HomeViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Runway" actionBlock:^(HSTitleCellModel *model) {

//            RunwayViewController * vc = [[RunwayViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/RunwayViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"礼物效果" actionBlock:^(HSTitleCellModel *model) {

//            MMGiftEffectViewController * vc = [[MMGiftEffectViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMGiftEffectViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"自动回复" actionBlock:^(HSTitleCellModel *model) {

//            MM_AutoReplyViewController * vc = [[MM_AutoReplyViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MM_AutoReplyViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"模型化TableView" actionBlock:^(HSTitleCellModel *model) {

//            TableDemoViewController * vc = [[TableDemoViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/TableDemoViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"CollectionView折叠" actionBlock:^(HSTitleCellModel *model) {

//            MMSearchViewController * vc = [[MMSearchViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMSearchViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"粘性指引视图" actionBlock:^(HSTitleCellModel *model) {

//            HLLIndicatorViewController * vc = [[HLLIndicatorViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/HLLIndicatorViewController?title=%@",model.title];
            })]];
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

        c = [[HSTitleCellModel alloc] initWithTitle:@"生成PDF" actionBlock:^(HSTitleCellModel *model) {

//            CreatePDFViewController * vc = [[CreatePDFViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/CreatePDFViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"渲染HTML" actionBlock:^(HSTitleCellModel *model) {

//            MarkdownRenderHTMLViewController * vc = [[MarkdownRenderHTMLViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MarkdownRenderHTMLViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"发现界面" actionBlock:^(HSTitleCellModel *model) {

//            MM_FindFriendEntryViewController * vc = [[MM_FindFriendEntryViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MM_FindFriendEntryViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"布局" actionBlock:^(HSTitleCellModel *model) {

//            LayoutViewController * vc = [[LayoutViewController alloc] init];
//            vc.title = @"布局";
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/LayoutViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Collection" actionBlock:^(HSTitleCellModel *model) {

//            MMCollectionViewController * vc = [[MMCollectionViewController alloc] init];
//            vc.title = @"Collection";
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self.navigationController presentViewController:nav animated: 1 completion:nil];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"present/MMCollectionViewController?title=%@&addNavi=true",model.title];
            })]];

        }];
        [s addCellModel:c];


        c = [[HSTitleCellModel alloc] initWithTitle:@"Xib" actionBlock:^(HSTitleCellModel *model) {

//            MMXibViewController * vc = [[MMXibViewController alloc] init];
//            vc.title = @"Xib";
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMXibViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Card" actionBlock:^(HSTitleCellModel *model) {

//            MMCardViewController * vc = [[MMCardViewController alloc] init];
//            vc.title = @"Card";
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMCardViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Animation" actionBlock:^(HSTitleCellModel *model) {

//            MMAnimationViewController * vc = [[MMAnimationViewController alloc] init];
//            vc.title = @"Animation";
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMAnimationViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Async" actionBlock:^(HSTitleCellModel *model) {

//            AsyncDrawViewController * vc = [[AsyncDrawViewController alloc] init];
//            vc.title = @"Async";
//            [self.navigationController pushViewController:vc animated:YES];
            [MMLiveRoute routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/AsyncDrawViewController?title=%@",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        s;
    })];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mm_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [self addRoutes];
}

- (void) addRoutes{
    
    // present
    [MMLiveRoute addRoute:@"present/:vc" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {

        NSString * className = parameters[@"vc"];
        NSString * title = parameters[@"title"];
        BOOL animated = [parameters[@"animated"] boolValue];
        BOOL needAddNavigation = [parameters[@"addNavi"] boolValue];
        if (![parameters.allKeys containsObject:@"animated"]) {
            animated = YES;
        }
        
        UIViewController * vc = [[NSClassFromString(className) alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.title = title;

            if (needAddNavigation) {
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                vc = nav;
            }
            [self.navigationController presentViewController:vc animated:animated completion:nil];
            
            return YES;
        }
        return NO;
    }];
    
    // push
    [MMLiveRoute addRoute:@"push/:vc" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        NSString * className = parameters[@"vc"];
        NSString * title = parameters[@"title"];
        BOOL animated = [parameters[@"animated"] boolValue];
        if (![parameters.allKeys containsObject:@"animated"]) {
            animated = YES;
        }
        
        UIViewController * vc = [[NSClassFromString(className) alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.title = title;
            [self.navigationController pushViewController:vc animated:animated];
            return YES;
        }
        return NO;
    }];
    
}

- (void) routeWithUrlString:(NSString *)urlString{
    if (urlString.length) {
        [MMLiveRoute routeURL:[NSURL URLWithString:urlString]];
    }
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
