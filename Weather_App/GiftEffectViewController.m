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
#import "MMDirectionGestureRecognizer.h"
#import "MMAObject.h"
#import "MMGiftContainerView.h"

@interface GiftEffectViewController ()<MMGiftViewDelegate>

@property (nonatomic ,strong) UIView * redView;

@property (nonatomic ,strong) MMGiftContainerView * giftView;
@property (nonatomic ,strong) GiftShapeEffectView * effectView;

@property (nonatomic ,strong) UILabel * directionLabel;
@property (nonatomic ,strong) UIView * circleView;
@end

@implementation GiftEffectViewController


- (void) onDirectoinGesture:(MMDirectionGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.circleView.hidden = NO;
        self.circleView.center = [gesture locationInView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGFloat offset = gesture.offset;
        offset = offset > 0 ? pow(offset, 0.6) : -pow(-offset, 0.6);
        
        NSString * direction = @"";
        if (gesture.direction == MMDirectionGestureRecognizerUp) {
            direction = @"up";
            self.redView.transform = CGAffineTransformMakeTranslation(0, offset);
        }
        if (gesture.direction == MMDirectionGestureRecognizerDown) {
            direction = @"down";
            self.redView.transform = CGAffineTransformMakeTranslation(0, offset);
        }
        if (gesture.direction == MMDirectionGestureRecognizerLeft) {
            direction = @"left";
            self.redView.transform = CGAffineTransformMakeTranslation(offset, 0);
        }
        if (gesture.direction == MMDirectionGestureRecognizerRight) {
            direction = @"right";
            self.redView.transform = CGAffineTransformMakeTranslation(offset, 0);
        }
        self.directionLabel.text = direction;
    }else if(gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateFailed){
        
        UISpringTimingParameters * timingParameters = [[UISpringTimingParameters alloc] initWithDampingRatio:0.6 initialVelocity:CGVectorMake(0.3, 0.3)];
        UIViewPropertyAnimator * animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 timingParameters:timingParameters];
        [animator addAnimations:^{
            self.redView.transform = CGAffineTransformIdentity;
        }];
        [animator startAnimation];
    }else{
        self.circleView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.redView = [UIView new];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.layer.cornerRadius = 10.0f;
    self.redView.layer.masksToBounds = YES;
    self.redView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:self.redView];
    
    self.directionLabel = [UILabel new];
    self.directionLabel.textAlignment = NSTextAlignmentCenter;
    self.directionLabel.textColor = [UIColor colorWithRed:0.91 green:0.26 blue:0.34 alpha:1.00];
    [self.view addSubview:self.directionLabel];
    [self.directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    
    MMDirectionGestureRecognizer * gesture = [[MMDirectionGestureRecognizer alloc] initWithTarget:self action:@selector(onDirectoinGesture:)];
    gesture.hysteresisOffset = 2;
//    [self.view addGestureRecognizer:gesture];
    
    self.circleView = [UIView new];
    self.circleView.layer.borderColor = [UIColor redColor].CGColor;
    self.circleView.layer.borderWidth = 1;
    self.circleView.bounds = CGRectMake(0, 0, gesture.hysteresisOffset * 2, gesture.hysteresisOffset * 2);
    self.circleView.layer.cornerRadius = gesture.hysteresisOffset;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.hidden = YES;
    [self.view addSubview:self.circleView];
    
//    UIViewPropertyAnimator * animator = [UIViewPropertyAnimator new];
    self.giftView = [MMGiftContainerView new];
    self.giftView.proxy = self;
    [self.view addSubview:self.giftView];
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.equalTo(self.view);
    }];
    return;
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
    
    MM_Number * five = [MM_Number number:5];
    five.add(4);// 9
    MM_Number.number(3).add(4);// 7
//    @(2).add(3).minus(4).integerValue;
}


- (void)sendGift {
    
    [self.effectView start:EFFECT_TYPE_50 image:[UIImage imageNamed:@"red_dot"]];
}

#pragma mark - MMGiftView

- (void)trackCallback{
    NSLog(@"in delegate callback");
}

@end
