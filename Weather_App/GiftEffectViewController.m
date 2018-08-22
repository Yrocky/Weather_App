//
//  GiftEffectViewController.m
//  Weather_App
//
//  Created by user1 on 2018/8/17.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "GiftEffectViewController.h"
#import "Masonry.h"
#import "GIftEffectView/GiftEffect/GiftShapeEffectView.h"

@interface GiftEffectViewController ()
@property (nonatomic ,strong) GiftShapeEffectView * effectView;
@end

@implementation GiftEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.effectView = [[GiftShapeEffectView alloc] init];
    self.effectView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.effectView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Gift" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
        }
        make.height.mas_equalTo(300);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 40));
        make.left.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)sendGift {
    
    [self.effectView start:EFFECT_TYPE_50 image:[UIImage imageNamed:@"red_dot"]];
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
