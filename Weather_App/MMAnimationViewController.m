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
#import "MMAnimationTimingFunctionType.h"
#import "MMAnimationType.h"
#import "MMAnimatable.h"
#import "MMAnimationPromise.h"

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
    self.superView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.superView];
    
    [self.superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(300);
    }];
    
    self.view.backgroundColor = [UIColor greenColor];
    [[[UIView.animator.duration(2.0f) animations:^{
//        self.view.backgroundColor = [UIColor orangeColor];
    }] completion:^(BOOL finished) {
        NSLog(@"animator completion");
    }] animate];
    
    // 有一个缺点，在设置完动画相关的属性之后还需要主动调用`animate`方法来启动动画，如何做到自动开启动画呢，
    // 期望的效果如下所示
    /**
    [[UIView.springAnimator.dampingRatio(10).velocity(20)
       .duration(2.0f).delay(4.25f) animations:^{
           self.superView.backgroundColor = [UIColor purpleColor];
       }] completion:^(BOOL finished) {
           NSLog(@"springAnimator completion");
       }];
    **/
    // 还有一个缺点，如果是对一个视图进行组合动画，就又回到了以前的书写效果上了，在一个animation的completion里面开始另一个animation
    /**
    [[[UIView.animator.duration(2.0f) animations:^{
        self.view.backgroundColor = [UIColor orangeColor];
    }] completion:^(BOOL finished) {
        [[UIView.animator.duration(1) animations:^{
            self.view.backgroundColor = [UIColor whiteColor];
        }] animate];
    }] animate];
    **/
    // 第三个缺点，没有对接口进行友好的提示，当设置`duration`的时候，block接收的参数不知道是什么类型的
    
    // 第四个缺点，如果先设置springAnimator的delay，然后再设置dampingRatio、velocity会报错，
    // 因为delay返回的是 MMAnimator 协议，而 dampingRatio 是 MMSpringAnimator 协议的
    // 使用类的时候，比如SuperClass有一个`-(SuperClass *)func;`，而子类SonClass有一个属性`NSString *name`
    // 在子类进行下面操作 `[[SonClass new] func].name = @"rocky";`的时候会报错，因为`-func`方法返回的是父类
    // 系统给出的解决办法是使用`instancetype`这个关键字来解决，谁调用返回的就是哪个具体的类的实例对象，
    // 但可惜的是，协议中没有这种方法
    
    [[[UIView.springAnimator.dampingRatio(10).velocity(20)
       .duration(2.0f).delay(4.25f) animations:^{
//           self.superView.backgroundColor = [UIColor purpleColor];
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
//          self.itemView3.backgroundColor = [UIColor orangeColor];
      }] animate];
    
    NSArray * itemViews = @[self.itemView1,self.itemView2,self.itemView3];
    [itemViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.superView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

//    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:10 tailSpacing:10];
//    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withViewsAlignment:MASViewsAlignmentCenter fixedItemLength:50 fixedSpacing:20];
    
    id tf = MMAnimationTimingFunctionEaseInQuint();
    id as = MMAnimationTypeMakeSlide(MMAnimationWayOut, MMAnimationWayDirectionUp);
    
    MMAnimationType * zoom = MMAnimationTypeMakeZoom(MMAnimationWayIn);
    
    id scale = [MMAnimationType scaleToX:1 y:3];
    MMAnimationType * shake = MMAnimationTypeMakeShake(2);
    
    MMAnimationType * rotate = MMAnimationTypeMakeRotate(MMAnimationWayRotationDirectionCW);
    
    MMAnimationConfiguration * config = MMAnimationConfiguration.new.duration(2.3)
    .force(1.3).damping(0.8).velocity(2).timingFunction(tf);
    
    [[[self.superView animationWith:rotate configuration:config].delay(3)
      thenAnimation:zoom config:config] animationCompletiond];
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
