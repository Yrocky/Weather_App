//
//  MMAnimationViewController.m
//  Weather_App
//
//  Created by user1 on 2018/1/19.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMAnimationViewController.h"
#import "YALPreloaderCircleView.h"
#import "Masonry.h"

#import "MMAnimator.h"

@interface MMAnimationViewController ()

@property (nonatomic ,strong) UIView * superView;
@property (nonatomic ,strong) UIView * itemView1;
@property (nonatomic ,strong) UIView * itemView2;
@property (nonatomic ,strong) UIView * itemView3;

@property (nonatomic ,strong) YALPreloaderCircleView * circleView;
@end

@implementation MMAnimationViewController
- (void)dealloc{
    NSLog(@"MMAnimationViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.circleView = ({
//        CGRect rect = [self initialCircleRect];
//        YALPreloaderCircleView *circleView = [[YALPreloaderCircleView alloc] initWithFrame:rect];
//        circleView.alpha = 1;
//        circleView.layerFillColor = [UIColor orangeColor];
//        [self.view addSubview:circleView];
//        circleView;
//    });
    
    self.superView = [UIView new];
    self.superView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.superView];
    
    [self.superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(300);
    }];
    
    self.view.backgroundColor = [UIColor redColor];
    [[[UIView.animator.duration(2.0f) animations:^{
        self.view.backgroundColor = [UIColor orangeColor];
    }] completion:^(BOOL finished) {
        NSLog(@"animator completion");
    }] animate];
    
    [[[UIView.springAnimator.dampingRatio(10).velocity(20)
       .duration(2.0f).delay(4.25f) animations:^{
           self.superView.backgroundColor = [UIColor purpleColor];
       }] completion:^(BOOL finished) {
           NSLog(@"springAnimator completion");
       }] animate];
    self.itemView1 = [UIView new];
    self.itemView1.backgroundColor = [UIColor redColor];
    [self.superView addSubview:self.itemView1];
    
    self.itemView2 = [UIView new];
    self.itemView2.backgroundColor = [UIColor redColor];
    [self.superView addSubview:self.itemView2];
    
    self.itemView3 = [UIView new];
    self.itemView3.backgroundColor = [UIColor redColor];
    [self.superView addSubview:self.itemView3];
    
    [[UIView.keyframeAnimator.keyFrameOptions(UIViewKeyframeAnimationOptionCalculationModeCubic)
      .duration(2.0f) animations:^{
          self.itemView3.backgroundColor = [UIColor orangeColor];
      }] animate];
    
    NSArray * itemViews = @[self.itemView1,self.itemView2,self.itemView3];
    [itemViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.superView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

//    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:10 tailSpacing:10];
//    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withViewsAlignment:MASViewsAlignmentCenter fixedItemLength:50 fixedSpacing:20];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.circleView animateToRect:[self destinationCircleRect]
                        completion:^{
                        }];
}

- (CGRect)initialCircleRect {
    CGRect preloaderBounds = self.view.bounds;
    CGFloat preloaderWidth = CGRectGetWidth(preloaderBounds);
    CGFloat preloaderHeight = CGRectGetHeight(preloaderBounds);
    CGFloat startCircleSide = MAX(preloaderWidth, preloaderHeight) * 2;
    CGFloat startX = (preloaderWidth - startCircleSide) * .5;
    CGFloat startY = (preloaderHeight - startCircleSide) * .5;
    return CGRectMake(startX, startY, startCircleSide, startCircleSide);
}

- (CGRect)destinationCircleRect {
    CGRect preloaderBounds = self.view.bounds;
    CGFloat preloaderWidth = CGRectGetWidth(preloaderBounds);
    CGFloat preloaderHeight = CGRectGetHeight(preloaderBounds);
    CGFloat destinationSize = MIN(preloaderWidth, preloaderHeight) * .75;
    CGFloat destinationX = (preloaderWidth - destinationSize) * .5;
    CGFloat destinationY = (preloaderHeight - destinationSize) * .5;
    return CGRectMake(destinationX, destinationY, destinationSize, destinationSize);
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
