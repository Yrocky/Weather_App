//
//  MMGradientViewController.m
//  Weather_App
//
//  Created by user1 on 2018/11/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMGradientViewController.h"
#import "MMGradientView.h"

#import <Masonry/Masonry.h>

@interface MMGradientViewController ()

@property (nonatomic ,strong) MMGradientView * gradientView;
@end

@implementation MMGradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(onGradientAction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
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
}

- (void) onGradientAction{
    
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