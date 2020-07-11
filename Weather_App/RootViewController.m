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
#import "XXXRoute.h"
#import "FaceUViewController.h"

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
        self.navigationController.navigationBar.prefersLargeTitles = NO;
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
        
        [s addCellModel:({
            [[HSTitleCellModel alloc] initWithTitle:@"home" actionBlock:^(HSTitleCellModel *model) {
                        
                [XXXRoute.core routeURL:[NSURL URLWithString:({
                    [NSString stringWithFormat:@"push/XXXHomeModuleViewController"];
                })] withParameters:@{
                    @"title":model.title,
                    @"addNavi" : @(YES)
                }];
            }];
        })];
        
        [s addCellModel:({
            [[HSTitleCellModel alloc] initWithTitle:@"0ff39" actionBlock:^(HSTitleCellModel *model) {
                        
                [XXXRoute.core routeURL:[NSURL URLWithString:({
                    [NSString stringWithFormat:@"push/XXXMakeItEaseViewController"];
                })] withParameters:@{
                    @"title":model.title,
                    @"addNavi" : @(YES)
                }];
            }];
        })];
        
        [s addCellModel:({
            [[HSTitleCellModel alloc] initWithTitle:@"responder chain" actionBlock:^(HSTitleCellModel *model) {
                        
                [XXXRoute.core routeURL:[NSURL URLWithString:({
                    [NSString stringWithFormat:@"push/XXXLivingRoomViewController"];
                })] withParameters:@{
                    @"title":model.title,
                    @"addNavi" : @(YES)
                }];
            }];
        })];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"LiveContentView" actionBlock:^(HSTitleCellModel *model) {
                    
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/XXXLiveContentViewController"];
            })] withParameters:@{
                @"title":model.title,
                @"addNavi" : @(YES)
            }];
        }];
        
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Kwai ying" actionBlock:^(HSTitleCellModel *model) {
                    
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/XXXKwaiViewController"];
            })] withParameters:@{
                @"title":model.title,
                @"addNavi" : @(YES)
            }];
        }];
        
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"MMKV" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMKVViewController"];
            })] withParameters:@{
                @"title":model.title,
                @"addNavi" : @(YES)
            }];
//            [XXXRoute.core routeURL:[NSURL URLWithString:({
//                [NSString stringWithFormat:@"push/MMKVViewController?title=%@&addNavi=true",model.title];
//            })]];
            //            NSString * url = [NSString stringWithFormat:@"MMLive://push/FaceUViewController"];
            //            [XXXRoute.core routeURL:[NSURL URLWithString:url]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Faceu" actionBlock:^(HSTitleCellModel *model) {
            
            FaceUViewController * vc = [[FaceUViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

//            NSString * url = [NSString stringWithFormat:@"MMLive://push/FaceUViewController"];
//            [XXXRoute.core routeURL:[NSURL URLWithString:url]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"365计划" actionBlock:^(HSTitleCellModel *model) {

//            FinanceViewController * vc = [[FinanceViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            NSString * url = [NSString stringWithFormat:@"push/FinanceViewController"];
            [XXXRoute.core routeURL:[NSURL URLWithString:url]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Login" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"present/OldLoginViewController?title=%@&addNavi=true",model.title];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"NoticeScroll" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/NoticeScrollViewController"];
            })] withParameters:@{
                @"title":model.title,
            }];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Resume" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ResumeViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Interpreter" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/InterpreterViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"fish b0" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/FishBoViewController"];
            })]];
        }];
        [s addCellModel:c];
       
        c = [[HSTitleCellModel alloc] initWithTitle:@"webview" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"MMLive://push/XXXWebViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"直播间无限轮滑" actionBlock:^(HSTitleCellModel *model) {
            
            CardCollectionViewController * vc = [[CardCollectionViewController alloc] init];
            vc.title = model.title;
            [vc setupDataSource:[RoomModel dataSource] roomIndex:2];
            MMNavigationController * navi = [[MMNavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
            
//            [XXXRoute.core routeURL:[NSURL URLWithString:({
//                [NSString stringWithFormat:@"push/HLLIndicatorViewController"];
//            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"PromiseKit" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/PromiseKitViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Emoji" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/EmojiViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Auto Layout" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ALBookDemoViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"MMGradient" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMGradientViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Signal" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/SignalViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"GiftEffect" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/GiftEffectViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"NSProxy" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ProxyViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"RoundCorner" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/RoundCornerViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Core Text" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMCoreTextViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"bill-Extension" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/ExtensionViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"bill-home" actionBlock:^(HSTitleCellModel *model) {
            
            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/HomeViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        c = [[HSTitleCellModel alloc] initWithTitle:@"Runway" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/RunwayViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"MMGiftEffect" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMGiftEffectViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"AutoReply" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MM_AutoReplyViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"TableView" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/TableDemoViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"CollectionView" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMSearchViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Indicator" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/HLLIndicatorViewController"];
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

        c = [[HSTitleCellModel alloc] initWithTitle:@"create PDF" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/CreatePDFViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"markdown to HTML" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MarkdownRenderHTMLViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"find" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MM_FindFriendEntryViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"layout" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/LayoutViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Collection" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"present/MMCollectionViewController?title=%@&addNavi=true",model.title];
            })]];

        }];
        [s addCellModel:c];


        c = [[HSTitleCellModel alloc] initWithTitle:@"Xib" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMXibViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Card" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMCardViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Animation" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/MMAnimationViewController"];
            })]];
        }];
        [s addCellModel:c];

        c = [[HSTitleCellModel alloc] initWithTitle:@"Async" actionBlock:^(HSTitleCellModel *model) {

            [XXXRoute.core routeURL:[NSURL URLWithString:({
                [NSString stringWithFormat:@"push/AsyncDrawViewController"];
            })]];
        }];
        [s addCellModel:c];
        
        s;
    })];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mm_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
//    [self addRoutes];
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
        vc.view.backgroundColor = [UIColor whiteColor];
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
        [XXXRoute.core routeURL:[NSURL URLWithString:urlString]];
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
