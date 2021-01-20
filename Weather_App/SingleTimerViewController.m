//
//  SingleTimerViewController.m
//  Weather_App
//
//  Created by rocky on 2021/1/18.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import "SingleTimerViewController.h"
#import "SingleTimer.h"
#import "UIColor+Common.h"
#import <Masonry/Masonry.h>
#import "XXXBasePopupView.h"

@class SubComponentView;
@protocol SubComponentViewDelegate <NSObject>

- (void) subCompoenentView:(SubComponentView *)view shouldBecomeTimerObserver:(BOOL)become;
@end

@interface SubComponentView : XXXBasePopupView<TimerObserver>
@property (nonatomic ,weak) id<SubComponentViewDelegate> delegate;
@end

@interface SingleTimerViewController ()<
TimerObserver,
SubComponentViewDelegate>
@property (nonatomic ,strong) SingleTimer * timer;
@property (nonatomic ,assign) NSInteger counter;
@property (nonatomic ,strong) UILabel * displayLabel;
@end

@implementation SingleTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayLabel = [UILabel new];
    [self.view addSubview:self.displayLabel];
    self.displayLabel.font = [UIFont systemFontOfSize:40];
    self.displayLabel.textColor = [UIColor colorWithHexString:@"#D4666C"];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.counter = 0;
    
    self.timer = [[SingleTimer alloc] initWithInterval:1];
//    [self.timer addTimerObserver:self];
    
    {
        UIButton * button = [UIButton new];
        [button addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.bottom.equalTo(self.displayLabel.mas_top);
            make.centerX.equalTo(self.view);
        }];
    }
    {
        UIButton * button = [UIButton new];
        [button addTarget:self action:@selector(onShow) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Show" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.top.equalTo(self.displayLabel.mas_bottom);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (void) onAdd{
    [self.timer addTimerObserver:self];
}

- (void) onShow {
    SubComponentView * view = [SubComponentView new];
    view.delegate = self;
    [view showIn:self.view];
}

#pragma mark - SubComponentViewDelegate

- (void) subCompoenentView:(SubComponentView *)view shouldBecomeTimerObserver:(BOOL)become{
    if (become) {
        [self.timer addTimerObserver:view];
    } else {
        [self.timer removeTimerObserver:view];
    }
}

#pragma mark - TimerObserver

- (NSString *)uniqueId{
    return @"dfsggfg";
}

- (void)onTimer{
    self.counter ++;
}

- (void)setCounter:(NSInteger)counter{
    _counter = counter;
    self.displayLabel.text = [NSString stringWithFormat:@"%ld",(long)counter];
}
@end

@implementation SubComponentView{
    UILabel * _textLabel;
    NSInteger _counter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubContentView];
    }
    return self;
}

- (void)addSubContentView{
    [super addSubContentView];
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont systemFontOfSize:50];
    _textLabel.textColor = [UIColor colorWithHexString:@"#6AA97D"];
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.center.equalTo(self.contentView);
    }];
    
    UISwitch * toggle = [[UISwitch alloc] init];
    [toggle addTarget:self action:@selector(onToggle:)
     forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:toggle];
    [toggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).mas_offset(30);
    }];
}

- (void) onToggle:(UISwitch *)toggle{

    if ([self.delegate respondsToSelector:@selector(subCompoenentView:shouldBecomeTimerObserver:)]) {
        [self.delegate subCompoenentView:self shouldBecomeTimerObserver:toggle.isOn];
    }
}

- (XXXPopupMaskColorType)touchMaskViewColorType{
    return XXXPopupMaskColorBlack;
}

- (CGFloat) contentViewFixedHeight{
    return 300;
}

#pragma mark - TimerObserver

- (NSString *)uniqueId{
    return @"dfsggfgsdge";
}

- (void)onTimer{
    _counter += 1;
    _textLabel.text = [NSString stringWithFormat:@"%ld",(long)_counter];
}
@end
