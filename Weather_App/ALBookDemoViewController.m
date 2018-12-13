//
//  ALBookDemoViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/12/3.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "ALBookDemoViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "MMConversation.h"
#import "UIView+AutoLayoutSupport.h"

@interface ALDebugView : UIView

@end

@implementation ALDebugView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}
@end

@interface ALShadowView : UIImageView
@end

@implementation ALShadowView

- (instancetype)initWithImage:(nullable UIImage *)image{
    
    self = [super initWithImage:image];
    if (self) {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = false;
//        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
//        self.layer.borderColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5].CGColor;
    }
    return self;
}

///<一般在使用一个有阴影或者有装饰的image的时候，这些装饰没有在布局的时候被考虑进去，就会导致
- (UIEdgeInsets)alignmentRectInsets{
//    CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return UIEdgeInsetsMake(0, 0, 3, 3);
}

@end

@interface ALBookDemoViewController ()

@property (nonatomic ,strong) ALDebugView * oneView;
@end

@implementation ALBookDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self nonatomicNoneCrashMethod];
//    [self nonatomicCarshMethod];
//    [self atomicNoneCrashMethod];
    
    self.oneView = [ALDebugView new];
    [self.view addSubview:self.oneView];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    
    ALDebugView * leftView = [ALDebugView new];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self.oneView.mas_left);
        make.centerY.equalTo(self.oneView);
    }];
    
    
    ALDebugView * topView = [ALDebugView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.oneView.mas_top).mas_offset(-0);
        make.centerX.equalTo(self.oneView);
    }];
    
    ALDebugView * rightView = [ALDebugView new];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.oneView.mas_right);
        make.centerY.equalTo(self.oneView);
    }];
    
    ALDebugView * bottomView = [ALDebugView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.oneView.mas_bottom).mas_offset(0);
        make.centerX.equalTo(self.oneView);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button addTarget:self action:@selector(onShowAction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.center.equalTo(self.view);
    }];
    
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
}

- (void) onShowAction{
    
//    [self.oneView ADKHideView:YES withConstraints:ADKLayoutAttributeWidth];
    [UIView animateWithDuration:3 animations:^{
        [self.oneView ADKHideViewWidth];
        [self.oneView ADKHideViewHeight];
        [self.view layoutIfNeeded];
    }];
}

- (void) layout{
    UIImage * tenShadowImage = [UIImage imageNamed:@"bill_three_shadow"];
    
    ALShadowView * tenShadowView = [[ALShadowView alloc] initWithImage:tenShadowImage];
    [self.view addSubview:tenShadowView];
    [tenShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    UIImageView * tenShadowImageView = [[UIImageView alloc] initWithImage:tenShadowImage];
    tenShadowImageView.backgroundColor = tenShadowView.backgroundColor;
    tenShadowImageView.contentMode = UIViewContentModeScaleAspectFill;
    tenShadowImageView.clipsToBounds = 1;
    [self.view addSubview:tenShadowImageView];
    [tenShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(tenShadowView);
        make.top.mas_equalTo(tenShadowView.mas_bottom).mas_offset(tenShadowView.alignmentRectInsets.bottom);
        make.centerX.equalTo(self.view);
    }];
    ALDebugView * leftView = [ALDebugView new];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(tenShadowView.mas_left);
        make.bottom.height.equalTo(tenShadowView);
    }];
    ALDebugView * rightView = [ALDebugView new];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(tenShadowView.mas_right).mas_offset(tenShadowView.alignmentRectInsets.right);
        make.bottom.height.equalTo(tenShadowView);
    }];
    ALDebugView * topView = [ALDebugView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(tenShadowView.mas_top).mas_offset(-tenShadowView.alignmentRectInsets.top);
        make.left.right.equalTo(tenShadowView);
    }];
    
    ///<自动布局不可以实现基于等分的约束设置
    ALDebugView * oneView = [ALDebugView new];
    [self.view addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        //        make.centerX.mas_equalTo(self.view.mas_width).multipliedBy(0.25);
        make.centerY.mas_equalTo(self.view);
    }];
}
#pragma mark - 单向数据流

- (void) nonatomicCarshMethod{
    MMConversation * model = [MMConversation new];

    ///这里为什么使用while之后就会导致崩溃？
    ///使用while就是表示会一直调用这个属性，因为异步多线程不确定执行的时机，
    ///所以这里是模拟了一个同时访问一个属性
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            model.messages = @[@"1",@"2"];
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            NSLog(@"%@",model.messages);
        }
    });
}

- (void) nonatomicNoneCrashMethod{
    MMConversation * model = [MMConversation new];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        model.messages = @[@"1",@"2"];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",model.messages);
    });
}

- (void) atomicNoneCrashMethod{
    MMConversation * model = [MMConversation new];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            model.names = @[@"1",@"2"];
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            NSLog(@"%@",model.names);
        }
    });
}
@end
