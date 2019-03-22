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
@interface RoomViewController ()<InternalRoomViewDelegate>{
    UILabel * _nameLabel;
    UIButton * _offlineButton;
}
@property (nonatomic ,strong) RoomModel * roomInfo;
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
//    self.view.alpha = 0.4;
    
//    [ANYMethodLog logMethodWithClass:[RoomViewController class] condition:^BOOL(SEL sel) {
//
//        return [NSStringFromSelector(sel) isEqualToString:@"addSection:"];
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSLog(@" before target:%@ sel:%@",target,NSStringFromSelector(sel));
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//
//    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:20];
    _nameLabel.textColor = [UIColor randomColor];
    [self.view addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(20);
    }];
    
    _offlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_offlineButton setTitle:@"Offline" forState:UIControlStateNormal];
    _offlineButton.backgroundColor = [UIColor orangeColor];
    [_offlineButton addTarget:self
                       action:@selector(onOfflineAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_offlineButton];
    [_offlineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_nameLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(self->_nameLabel);
    }];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor redColor];
    [closeButton addTarget:self
                    action:@selector(onCloseAction)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).mas_offset(60);
    }];
}

- (void) onCloseAction{
    if (self.bCloseRoom) {
        self.bCloseRoom();
    }
}

- (void) onOfflineAction:(UIButton *)button{
    if (self.bRemoveRoomInfo) {
        self.bRemoveRoomInfo(self.roomInfo);
    }
}
- (void) updateLiveRoom:(RoomModel *)roomInfo atIndex:(NSUInteger)index{
    
    self.roomInfo = roomInfo;
    
    _nameLabel.text = [NSString stringWithFormat:@"%d %d",index ,roomInfo.roomId];
    _nameLabel.textColor = [UIColor randomColor];
    
//    self.view.backgroundColor = [UIColor randomColor];
}
#pragma mark - InternalRoomViewDelegate
- (void)roomViewDidMoveToSuperView:(InternalRoomView *)roomView{
    roomView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:2.5 animations:^{
        roomView.backgroundColor = [UIColor redColor];
    }];
    ///<各个layerView进行替换数据的动画，将原始数据置空、对新数据进行获取然后设置
}
@end
