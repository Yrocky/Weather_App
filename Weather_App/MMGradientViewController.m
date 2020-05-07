//
//  MMGradientViewController.m
//  Weather_App
//
//  Created by user1 on 2018/11/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMGradientViewController.h"
#import "MMGradientView.h"
#import "MMNoRetainTimer.h"
#import <Masonry/Masonry.h>

@interface MMGradientViewController ()
@property (nonatomic ,strong) UILabel * label;
@property (nonatomic ,strong) MMNoRetainTimer * timer;
@property (nonatomic ,strong) MMGradientView * gradientView;
@property (nonatomic ,strong) NSTimer * timer2;
@end

@implementation MMGradientViewController

- (void)dealloc{
    
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onGradientAction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.timer = [MMNoRetainTimer<NSString *> scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onTimerAction:) userInfo:@"hhhhhh" repeats:YES];
    
//    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onTimer2) userInfo:nil repeats:YES];
    
    self.gradientView = [MMBlurGradientView blurGradientView:UIBlurEffectStyleLight];
    self.gradientView.colors = @[[UIColor colorWithWhite:0 alpha:0],
                                 [UIColor colorWithWhite:0 alpha:1]];
    self.gradientView.highlightColors = @[[UIColor colorWithWhite:0 alpha:0.2],
                                          [UIColor colorWithWhite:0 alpha:0.2]];
    self.gradientView.locations = @[@(0),@(1)];
    self.gradientView.startPoint = CGPointMake(0.5, 0.61);
    self.gradientView.endPoint = CGPointMake(0, 1.4);
    [self.view addSubview:self.gradientView];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(125.0f);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view);
        }
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.center.mas_equalTo(self.view);
    }];
    
    self.label = [UILabel new];
    [self.view addSubview:self.label];
    self.label.textColor = [UIColor orangeColor];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom);
        make.centerX.equalTo(button);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(90);
    }];
}

- (void) onGradientAction{
    [self.timer invalidate];
    [self.timer2 invalidate];
//    [self.gradientView setHighlighted:!self.gradientView.isHighlighted
//                             animated:YES];
}

- (void) onTimerAction:(MMNoRetainTimer<NSString *> *)timer{
    NSLog(@"timer.userInfo:%@",timer.userInfo);
    [self.gradientView setHighlighted:!self.gradientView.isHighlighted
                             animated:YES];
    self.label.text = @"34:51";
}

- (void) onTimer2{
    [self.gradientView setHighlighted:!self.gradientView.isHighlighted
                             animated:YES];
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
