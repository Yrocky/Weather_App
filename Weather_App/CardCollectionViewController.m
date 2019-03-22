//
//  CardCollectionViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "CardCollectionViewController.h"
#import "Masonry.h"
#import "CardCollectionView.h"
#import "RoomViewController.h"
#import "RoomModel.h"
#import "NSArray+Sugar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CardCollectionViewController ()<
CardCollectionViewDelegate>{
    
    NSArray <RoomModel *>* origDataSource;
    NSMutableArray <RoomModel *>* prepareToRemoveRoomInfos;///<已经关播的主播，需要移除
    NSUInteger _roomIndex;
}

@property (nonatomic ,strong) RoomViewController * userLiveVC;
@property (nonatomic ,strong) CardCollectionView * collectionView;

@end

@implementation CardCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - Init

- (void)initUI {
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    [self addChildViewController:self.userLiveVC];
    
    [self.collectionView setupDataSource:origDataSource
                                 atIndex:_roomIndex];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - API

- (void)setupDataSource:(NSArray<RoomModel *> *)dataSource
              roomIndex:(NSUInteger)roomIndex{
    
    origDataSource = dataSource;
    _roomIndex = roomIndex;
}

#pragma mark - CardCollectionViewDelegate

- (BOOL) cardCollectionViewShouldScroll:(CardCollectionView *)view{
    return YES;
}

- (__kindof UIView *)cardCollectionViewShouldAddLiveView:(CardCollectionView *)view{
    
    return self.userLiveVC.view;
}

- (void)cardCollectionView:(CardCollectionView *)view willStartToggleRoom:(RoomModel *)roomInfo{
    NSLog(@"will start toggle room:%ld",(long)roomInfo.roomId);
}
- (void) cardCollectionView:(CardCollectionView *)view didToggleRoom:(RoomModel *)roomInfo atIndex:(NSUInteger)index{
    
    [self.userLiveVC updateLiveRoom:roomInfo atIndex:index];
}

- (void)cardCollectionView:(CardCollectionView *)view didFinishToggleRoom:(RoomModel *)roomInfo{
    NSLog(@"finish toggle room:%ld",(long)roomInfo.roomId);
    if (prepareToRemoveRoomInfos.count) {///<有已经下播的房间
        [view removeRoomWithRoomIds:[prepareToRemoveRoomInfos mm_map:^id _Nonnull(RoomModel * _Nonnull obj) {
            return @(obj.roomId);
        }]];
        [prepareToRemoveRoomInfos removeAllObjects];
    }
}

#pragma mark - Getter

- (CardCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[CardCollectionView alloc] initWithFrame:self.view.bounds];
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (RoomViewController *)userLiveVC{
    if (!_userLiveVC) {
        _userLiveVC = [[RoomViewController alloc] init];
        _userLiveVC.view.frame = self.view.bounds;
        __weak typeof(self) weakSelf = self;
        _userLiveVC.bRemoveRoomInfo = ^(RoomModel * _Nonnull roomInfo) {
            
//            weakSelf->prepareToRemoveRoomInfos;
//            if (nil == weakSelf->prepareToRemoveRoomInfos) {
//                weakSelf->prepareToRemoveRoomInfos = [NSMutableArray array];
//            }
//            [weakSelf->prepareToRemoveRoomInfos addObject:roomInfo];
        };
        _userLiveVC.bCloseRoom = ^{
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _userLiveVC;
}

@end
