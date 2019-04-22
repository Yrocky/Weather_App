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
#import "HLLAlert.h"
#import "RoomCycleScrollView.h"

@interface CardCollectionViewController ()<
CardCollectionViewDelegate,
RoomViewControllerDelegate,
RoomCycleScrollViewDelegate>{
    
    NSArray <RoomModel *>* origDataSource;
    NSMutableArray <RoomModel *>* prepareToRemoveRooms;///<已经关播的主播，需要移除
    NSUInteger _roomIndex;
}

@property (nonatomic ,strong) RoomViewController * userLiveVC;
@property (nonatomic ,strong) CardCollectionView * collectionView;
@property (nonatomic ,strong) RoomCycleScrollView * cycleScrollView;

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
    [self.view addSubview:self.cycleScrollView];
    
    [self addChildViewController:self.userLiveVC];
    
    [self.collectionView setupDataSource:origDataSource
                                 atIndex:_roomIndex];
    [self.cycleScrollView setupDataSource:origDataSource
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
    ///<这部分可以用来在直播间正进行比较重要的事情，比如和主播连麦，来询问用户是否要先停止了连麦再滑动
    if (self.userLiveVC.roomIsLinkMic) {
        
        [[[HLLAlertUtil title:@"当前房间在连麦中，请先停止连麦再切换直播间！"]
          buttonTitles:@"确定", nil] showIn:self];
        return NO;
    }
    return YES;
}

- (__kindof UIView *)cardCollectionViewShouldAddLiveView:(CardCollectionView *)view{
    
    return self.userLiveVC.view;
}

- (void)cardCollectionView:(CardCollectionView *)view willStartToggleRoom:(RoomModel *)room{
    NSLog(@"will start toggle room:%ld",(long)room.roomId);
}

- (void) cardCollectionView:(CardCollectionView *)view didToggleRoom:(RoomModel *)room atIndex:(NSUInteger)index{
    
    [self.userLiveVC updateLiveRoom:room atIndex:index];
}

- (void)cardCollectionView:(CardCollectionView *)view didFinishToggleRoom:(RoomModel *)room{
    NSLog(@"finish toggle room:%ld",(long)room.roomId);
    if (prepareToRemoveRooms.count) {///<有已经下播的房间
        [view removeRooms:prepareToRemoveRooms.copy];
        [prepareToRemoveRooms removeAllObjects];
    }
}

#pragma mark - RoomCycleScrollViewDelegate
- (__kindof UIView *)roomCycleScrollViewShouldAddLiveView:(RoomCycleScrollView *)view{
    return self.userLiveVC.view;
}

- (BOOL) roomCycleScrollViewShouldScroll:(RoomCycleScrollView *)view{
    ///<这部分可以用来在直播间正进行比较重要的事情，比如和主播连麦，来询问用户是否要先停止了连麦再滑动
    if (self.userLiveVC.roomIsLinkMic) {
        
        [[[HLLAlertUtil title:@"当前房间在连麦中，请先停止连麦再切换直播间！"]
          buttonTitles:@"确定", nil] showIn:self];
        return NO;
    }
    return YES;
}

- (void) roomCycleScrollView:(RoomCycleScrollView *)view
         willStartToggleRoom:(RoomModel *)room{
//    NSLog(@"will toggle room:%@",room);
}

- (void) roomCycleScrollView:(RoomCycleScrollView *)view
               didToggleRoom:(RoomModel *)room atIndex:(NSUInteger)index{
//    NSLog(@"toggle room:%@ at index:%ld",room,(long)index);
    if (prepareToRemoveRooms.count) {///<有已经下播的房间
        NSArray * temp = prepareToRemoveRooms.copy;
        NSLog(@"移除房间%@",temp);
        [prepareToRemoveRooms removeAllObjects];
        [view removeRooms:temp];
    } else {    
        NSLog(@"更新房间%@",room);
        [self.userLiveVC updateLiveRoom:room atIndex:index];
    }
}

- (void) roomCycleScrollView:(RoomCycleScrollView *)view
         didFinishToggleRoom:(RoomModel *)room{
//    NSLog(@"finish toggle room:%ld",(long)room.roomId);
//    if (prepareToRemoveRooms.count) {///<有已经下播的房间
//        NSLog(@"移除房间%@",room);
//        [view removeRooms:prepareToRemoveRooms.copy];
//        [prepareToRemoveRooms removeAllObjects];
//    }
}

#pragma mark - RoomViewControllerDelegate
- (void)roomViewController:(RoomViewController *)liveRoom allowScroll:(BOOL)allow{
    [self.collectionView allowScroll:allow];
    [self.cycleScrollView allowScroll:allow];
}

- (void)roomViewController:(RoomViewController *)liveRoom didChangeRoom:(RoomModel *)room{
    [self.collectionView updateWithNewRoom:room];
    [self.cycleScrollView updateWithNewRoom:room];
}

- (void)roomViewController:(RoomViewController *)liveRoom didInsertRoom:(RoomModel *)room{
    [self.collectionView insertNewRoom:room];
    [self.cycleScrollView insertNewRoom:room];
}

- (void)roomViewController:(RoomViewController *)liveRoom offlineWithRoom:(RoomModel *)room{
    if (nil == prepareToRemoveRooms) {
        prepareToRemoveRooms = [NSMutableArray array];
    }
    [prepareToRemoveRooms addObject:room];
}

#pragma mark - Getter

- (CardCollectionView *)collectionView{
    return nil;
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
        _userLiveVC.delegate = self;
    }
    return _userLiveVC;
}

- (RoomCycleScrollView *)cycleScrollView{
    if (nil == _cycleScrollView) {
        _cycleScrollView = [[RoomCycleScrollView alloc] initWithFrame:self.view.bounds];
        _cycleScrollView.cycleDelegate = self;
    }
    return _cycleScrollView;
}
@end
