//
//  RoomViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "RoomViewController.h"
#import "UIColor+Common.h"
#import "RoomModel.h"
#import "Masonry.h"
#import "ANYMethodLog.h"
#import "RankViewController.h"
//#import "UIImageView+WebCache.h"

@class InternalRoomView;
@protocol InternalRoomViewDelegate <NSObject>

- (void) roomViewDidMoveToSuperView:(InternalRoomView *)roomView;
@end
@interface InternalRoomView : UIView

@property (nonatomic ,weak) id<InternalRoomViewDelegate> delegate;
@end

@implementation InternalRoomView

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(roomViewDidMoveToSuperView:)]) {
        [self.delegate roomViewDidMoveToSuperView:self];
    }
}

@end
@interface RoomViewController ()<InternalRoomViewDelegate,RankViewControllerDelegate>{
    UIImageView * _iconImageView;
    UILabel * _nameLabel;
    UIButton * _recommendView;
    BOOL _isLinkMic;///<是否在连麦中
}
@property (nonatomic ,strong) RoomModel * room;
@end

@implementation RoomViewController

- (void)loadView{
    
    InternalRoomView * view = [InternalRoomView new];
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor randomColor];
    self.view.alpha = 0.6;
    
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius = 100.0f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderWidth = 2.0;
    _iconImageView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor randomColor];
    [self.view addSubview:_nameLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_nameLabel.mas_top).mas_offset(-80);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(20);
    }];
    
    UIButton * offlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [offlineButton setTitle:@"Offline" forState:UIControlStateNormal];
    [offlineButton setTitleColor:[UIColor greenColor]
                        forState:UIControlStateNormal];
    offlineButton.backgroundColor = [UIColor orangeColor];
    [offlineButton addTarget:self
                       action:@selector(onOfflineAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:offlineButton];
    [offlineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_nameLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(self->_nameLabel);
    }];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor redColor];
    [closeButton setTitleColor:[UIColor greenColor]
                      forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(onCloseAction)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).mas_offset(60);
    }];
    
    UIButton * rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setTitle:@"Rank" forState:UIControlStateNormal];
    [rankButton setTitleColor:[UIColor greenColor]
                     forState:UIControlStateNormal];
    rankButton.backgroundColor = [UIColor purpleColor];
    [rankButton addTarget:self action:@selector(onRankAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rankButton];
    [rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerY.equalTo(self.view).mas_offset(-40);
        make.right.equalTo(self.view);
    }];
    
    _recommendView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recommendView addTarget:self action:@selector(onRecommendAction)
             forControlEvents:UIControlEventTouchUpInside];
    _recommendView.backgroundColor = [UIColor randomColor];
    [self.view addSubview:_recommendView];
    [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-40);
        }
    }];
    
    UISwitch * toggle = [UISwitch new];
    [toggle addTarget:self action:@selector(onLinkMicAction:)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:toggle];
    [toggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_nameLabel.mas_top).mas_offset(-30);
    }];
}

#pragma mark - Action M

- (void) onRankAction{
    RankViewController * rank = [RankViewController new];
    rank.delegate = self;
    [self.navigationController pushViewController:rank animated:YES];
}

- (void) onCloseAction{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onOfflineAction:(UIButton *)button{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(roomViewController:offlineWithRoom:)]) {
        [self.delegate roomViewController:self offlineWithRoom:self.room];
    }
    _recommendView.hidden = NO;
}
- (void) onRecommendAction{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(roomViewController:didChangeRoom:)]) {
        [self.delegate roomViewController:self didChangeRoom:[RoomModel room:300]];
    }
}
- (void) onLinkMicAction:(UISwitch *)toggle{
    _isLinkMic = toggle.isOn;
}

#pragma mark - API

- (void) updateLiveRoom:(RoomModel *)room atIndex:(NSUInteger)index{
    
    self.room = room;
    
//    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:room.pic]];
    _nameLabel.text = [NSString stringWithFormat:@"%lu %lu",(unsigned long)index ,(unsigned long)room.roomId];
    _nameLabel.textColor = [UIColor randomColor];
    
//    self.view.backgroundColor = [UIColor randomColor];
}

- (BOOL) roomIsLinkMic{
    return _isLinkMic;
}

#pragma mark - RankViewControllerDelegate

- (void)rankViewController:(RankViewController *)rank didSelectedRoom:(RoomModel *)room{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(roomViewController:didInsertRoom:)]) {
        [self.delegate roomViewController:self didInsertRoom:room];
    }
}

#pragma mark - InternalRoomViewDelegate

- (void)roomViewDidMoveToSuperView:(InternalRoomView *)roomView{
    roomView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        roomView.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
    }];
    _recommendView.hidden = YES;
    ///<各个layerView进行替换数据的动画，将原始数据置空、对新数据进行获取然后设置
}
@end
