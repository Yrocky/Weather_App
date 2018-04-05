//
//  ExtensionViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "ExtensionViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface ExtensionViewController ()

@property (nonatomic ,strong) UIView * keyboardView;
@property (nonatomic ,strong) MASConstraint * keyboardViewBottomConstraint;

@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拓展功能";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.keyboardView = [UIView new];
    self.keyboardView.backgroundColor = [UIColor randomColor];
    [self.view addSubview:self.keyboardView];
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
        if (@available(iOS 11.0, *)) {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
