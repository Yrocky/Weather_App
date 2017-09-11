//
//  ViewController.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "ViewController.h"
#import "HLLWaveView.h"
#import "HLLCircularLoaderView.h"
#import "HLLAttributedBuilder.h"
#import "Masonry.h"
#import "DataSourceProtocol.h"
#import "MMRunwayCoreView.h"
#import "MMRunwayProContentView.h"

@interface MMColorView : UIView<DataSource>

+ (instancetype) view:(UIColor *)color;
- (void) animation;
@end

@implementation MMColorView

+ (instancetype)view:(UIColor *)color{

    MMColorView * view = [[self alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void) animation{

    [self.layer removeAllAnimations];
//    self.layer.opacity = 0;
    CGPoint position = self.layer.position;
    CAKeyframeAnimation * positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(position.x, position.y)],
                                 [NSValue valueWithCGPoint:CGPointMake(position.x, position.y - 80)],
                                 [NSValue valueWithCGPoint:CGPointMake(position.x, position.y)]];
    
    CAKeyframeAnimation * alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[[NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.2],
                              [NSNumber numberWithFloat:0]];
    
    CAAnimationGroup * animation = [CAAnimationGroup animation];
    animation.duration = 3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.animations = @[positionAnimation,alphaAnimation];
    [self.layer addAnimation:animation forKey:@"animation"];
}
@end

@interface MMDisplayLabel : UILabel

@end

@implementation MMDisplayLabel

- (void)setText:(NSString *)text{

    [super setText:text];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: self.font} context:nil].size;
    CGRect frame = self.frame;
    self.frame = (CGRect){
        frame.origin,
        textSize.width,frame.size.height
    };
}

@end
@interface ViewController ()

@property (nonatomic ,strong) HLLWaveView * waveView;
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (nonatomic ,strong) HLLCircularLoaderView * loaderView;

@property (nonatomic ,strong) MMRunwayProContentView * runwayProView;
@property (nonatomic ,strong) MMColorView * colorView;

@property (nonatomic ,strong) MMRunwayCoreView * coreView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MMRunwayLabel * label = [[MMRunwayLabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    CGSize size = [label configText:@"恭喜【愤怒的小奴奴】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条"];
    label.frame = (CGRect){10, 400, size};
    [self.view addSubview:label];
    
    self.runwayProView = [[MMRunwayProContentView alloc] init];
    self.runwayProView.frame = CGRectMake(0, 40, self.view.frame.size.width, 46);
    [self.view addSubview:self.runwayProView];

    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"red_dot"];
    attachment.bounds = CGRectMake(0, 0, 9, 9);
    NSAttributedString * string = [[[[[[[HLLAttributedBuilder builder]
                                        appendAttachment:attachment]
                                       appendString:@"nihao"]
                                      appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                                       NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                                       NSUnderlineStyleAttributeName:@1}]
                                     appendAttachment:attachment]
                                    appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                                      NSStrokeWidthAttributeName:@1}]
                                   attributedString];
    self.displayLabel.attributedText = string;
    
    
    NSString * display = @"hello = nihao = Hello = 你好 = nihao";
    NSAttributedString * attString = [[[[[[[HLLAttributedBuilder builderWithString:display]
                                         configString:@"hello" forStyle:@{NSUnderlineColorAttributeName:[UIColor redColor],
                                                                          NSUnderlineStyleAttributeName:@1,
                                                                          NSForegroundColorAttributeName:[UIColor orangeColor]}]
                                        configString:@"nihao" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                                         NSStrokeWidthAttributeName:@1}]
                                       configString:@"H" forStyle:@{NSBackgroundColorAttributeName:[UIColor greenColor]}]
                                      appendAttachment:attachment]
                                      appendString:@"娃大喜"]
                                      attributedString];
    NSLog(@"size:%@",[NSValue valueWithCGSize:[attString size]]);
    
    label = [[MMRunwayLabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    size = [label configAttributedString:attString];
    label.frame = (CGRect){0, 0, size};
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 360, size.width - 100, size.height)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(size.width - 80, size.height);
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(40, 0)];
    [scrollView addSubview:label];
    
    self.displayLabel.attributedText = attString;
    NSLog(@"%@",[HLLAttributedBuilder builder].appendString(@"nihao=Hello").attributedStr());
    
    self.loaderView = [HLLCircularLoaderView circularLoaderView];
    self.loaderView.frame = self.displayImageView.bounds;
    self.loaderView.circleLineColor = [UIColor orangeColor];
    [self.displayImageView addSubview:self.loaderView];
    
    self.waveView = [HLLWaveView waveView];
    self.waveView.frame = CGRectMake(0, 100, self.view.frame.size.width, 20);
    self.waveView.waveColor = [UIColor colorWithRed:0.49 green:0.36 blue:0.96 alpha:.5];
    self.waveView.waveSpeed = 0.0125;
    self.waveView.waveCycle = 400;
    [self.waveView start];
    [self.view addSubview:self.waveView];
    
    HLLWaveView * waveView = [HLLWaveView waveView];
    waveView.waveColor = [UIColor colorWithRed:0.49 green:0.36 blue:0.96 alpha:.80];
    waveView.waveSpeed = self.waveView.waveSpeed * 2;
    waveView.waveCycle = self.waveView.waveCycle * 1;
    waveView.frame = self.waveView.frame;
    waveView.offsetX = 40;
    [waveView start];
    [self.view addSubview:waveView];
    
    //
    UIButton * button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(stopWave) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 150, 150, 50);
    [button setTitle:@"Animation" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    
    self.coreView = [[MMRunwayCoreView alloc] initWithSpeed:1 defaultSpace:30];
    self.coreView.frame = CGRectMake(20, 300, 300, 40);
    [self.view addSubview:self.coreView];
    self.coreView.backgroundColor = [UIColor brownColor];
    [self.coreView appendAttributedString:attString];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void) actioin:(id)ges{

    NSLog(@"++++");
}

- (void) stopWave{
    
    NSString *scrollTitle = @"恭喜【愤怒的小奴奴】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条";
    
    [self.coreView appendText:scrollTitle];
    
    [self.colorView animation];
    
    
    MMColorView * testView = [MMColorView view:[UIColor redColor]];
    testView.frame = CGRectMake(0, 0, 1000, 46);
    MMDisplayLabel * label = [[MMDisplayLabel alloc] init];
    label.numberOfLines = 1;
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 1000, 46);
    label.text = @"恭喜【愤怒的小奴奴】和【开心的小涵涵】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条";
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actioin:)];
    [label addGestureRecognizer:gesure];
    [self.runwayProView addMarquee:label];
    
    //
    [self.loaderView reset];
    
    __block CGFloat time = 2.0;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        self.loaderView.progress += (1.0/time);
        
        if (self.loaderView.progress >= 1) {
            [timer invalidate];
            [self.loaderView reveal];
        }
    }];
    
    //
    BOOL start = YES;
    if (start) {
        [self.waveView start];
    }else{
        [self.waveView stop];
    }
}
@end
