//
//  FaceUViewController.m
//  Weather_App
//
//  Created by skynet on 2019/11/11.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "FaceUViewController.h"
#import "Masonry.h"
#import "XXXBasePopupView.h"
#import "KXBeautyMainViewController.h"

@interface XXXDemoPopupView : XXXBasePopupView

@end

@interface FaceUViewController ()

@property (nonatomic ,strong) XXXBasePopupView * popupView;
@property (nonatomic ,strong) UIButton * buggon;
@end

@implementation FaceUViewController

-(void)dealloc{
    NSLog(@"FaceUViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.buggon = [UIButton new];
    [self.buggon addTarget:self action:@selector(onButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.buggon.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.buggon];
    
    [self.buggon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 50));
    }];
}

- (void) onButtonAction{
    
    [[XXXDemoPopupView new] showIn:self.view];
    return;
    if (!_popupView) {
        KXBeautyMainViewController * mainVC = [KXBeautyMainViewController new];
        [self addChildViewController:mainVC];
        XXXBasePopupView * popupView = [XXXBasePopupView new];
        
        [mainVC setBPopupCanToushMaskDismiss:^(BOOL can) {
            popupView.dismissOnMaskTouched = can;
        }];
//        [popupView wrapViewController:mainVC fixedHeight:350 + 52];
        [popupView wrapViewController:mainVC
                           layoutType:XXXPopupLayoutTypeCenter
                      contentViewSize:CGSizeMake(375, 350+52)];
        popupView.contentView.backgroundColor = [UIColor clearColor];
        [popupView clearContentViewCornerRadius];
        self.popupView = popupView;
    }
    [self.popupView showIn:self.view];
}

@end

@implementation XXXDemoPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubContentView];
    }
    return self;
}

- (CAAnimation *)customShowAnimation{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.duration = 2;
    animation.fillMode = kCAFillModeBackwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGFloat y = -55;
    animation.values = @[@(200),@(y), @(-y),@(0)];
    
    return animation;
}

- (CAAnimation *)customDismissAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.duration = 0.55;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CGFloat y = -55;
    animation.values = @[@(0),@(y),@(200)];
    
    return animation;
}

- (XXXPopupLayoutType)layoutType{
    return XXXPopupLayoutTypeBottom;
}

- (CGFloat)contentViewFixedHeight{
    return 200;
}

- (XXXPopupMaskColorType)touchMaskViewColorType{
    return XXXPopupMaskColorBlack;
}

@end
