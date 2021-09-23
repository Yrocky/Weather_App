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
#import "MMPreviewHUD.h"
#import "NSUserDefaults+MM_Common.h"
#import "MMOBJ.h"
#import <SDWebImage/UIImage+GIF.h>

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
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) MMOBJ * obj;

@property (nonatomic ,strong) NSString * str1;
@property (nonatomic ,copy) NSString * str2;

@property (nonatomic ,strong) NSArray * arr1;
@property (nonatomic ,copy) NSArray * arr2;
@end

@implementation ViewController

- (void)mm_debugerTool{

    NSLog(@"mm_debugerTool");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"change:%@",change);
}
- (MMOBJ *)obj{

    if (!_obj){
        _obj = [[MMOBJ alloc] init];
    }
    return _obj;
}

- (id) someInstanceVariable:(NSString *)name{
    
    return name == nil ? name : [self valueForKeyPath:name];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIImageView * imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage sd_animatedGIFNamed:@"img_user_level_8"];
    imageView.frame = CGRectMake(20, 100, 28, 12);
    [self.view addSubview:imageView];
    
//    NSLog(@"obj:%@",[self valueForKeyPath:@"obj"]);// 内部相当于调用了 self.obj
    NSLog(@"obj:%@",[self valueForKeyPath:@"_obj"]);
//    self.obj;
    NSLog(@"obj:%@",[self valueForKeyPath:@"_obj"]);
    NSLog(@"obj:%@",[self valueForKeyPath:@"obj"]);
    
//    self.obj = [[MMOBJ alloc] init];
//    [self.obj addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.obj setValue:@"rocky" forKeyPath:@"name"];
//        self.obj.name = @"yrocky";
//        _obj.name = @"yyrocky";
//    });
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    statusBar.backgroundColor = [UIColor orangeColor];
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm_debugerTool)];
//    tapGesture.numberOfTouchesRequired = 2;
//    [statusBar addGestureRecognizer:tapGesture];
    
    ////////////// 创建跑道视图
    self.coreView = [[MMRunwayCoreView alloc] initWithSpeed:1 defaultSpace:30];
    self.coreView.frame = CGRectMake(20, 300, 300, 40);
    self.coreView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.coreView];
    
    ////////////// 添加一个UILabel类型的跑道视图
    NSString * string = @"恭喜【1234554】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条";
    MMRunwayLabel * label = [[MMRunwayLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    CGSize size = [label configText:string];
    label.frame = (CGRect){10, 400, size};
    [self.coreView appendRunwayLabel:label];
    
    
//    NSString * a = @"a[bc]d(you)A[BCD]1【大家好】2a[gs]34(me)";
//    NSAttributedString * attS = AttBuilderWith(a).
//    configStringAndStyle(@"(?<=\\【)[^\\】]+",@{NSForegroundColorAttributeName:[UIColor orangeColor]}).
//    attributedStr();
    
    ////////////// 根据属性字符串添加一个UILabel跑道视图
    NSAttributedString * attString;
    attString = [[[HLLAttributedBuilder builderWithString:string]
                  configString:@"(?<=\\【)[^\\】]+" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                  NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                  NSUnderlineStyleAttributeName:@1}]
                 attributedString];
    [self.coreView appendAttributedString:attString];
    
    ////////////// 根据属性字符串添加跑道视图
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage sd_animatedGIFNamed:@"img_user_level_8"];
    attachment.bounds = CGRectMake(0, 0, 28, 12);
    attString = [[[[[[[HLLAttributedBuilder builder]
                      appendAttachment:attachment]
                     appendString:@"nihao"]
                    appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                     NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                     NSUnderlineStyleAttributeName:@1}]
                   appendAttachment:attachment]
                  appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                    NSStrokeWidthAttributeName:@1}]
                 attributedString];
    self.displayLabel.attributedText = attString;
    [self.coreView appendAttributedString:attString];

    ////////////// 根据属性字符串添加跑道视图
    NSString * display = @"hello = nihao = Hello = 你好 = nihao";
    attString = [[[[[[[HLLAttributedBuilder builderWithString:display]
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
    [self.coreView appendAttributedString:attString];
    
    ////////////// 根据属性字符串添加跑道视图
    [self.coreView appendAttributedString:
     [[[HLLAttributedBuilder builderWithString:string]
       configString:@"【.】" forStyle:@{NSUnderlineColorAttributeName:[UIColor orangeColor],
                                      NSUnderlineStyleAttributeName:@1}] attributedString]];
    
    
    
    
    
    return;
    
    
    self.runwayProView = [[MMRunwayProContentView alloc] init];
    self.runwayProView.frame = CGRectMake(0, 40, self.view.frame.size.width, 46);
    [self.view addSubview:self.runwayProView];
    
    label = [[MMRunwayLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    size = [label configAttributedString:attString];
    label.frame = (CGRect){0, 0, size};
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 360, size.width - 0, size.height)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(0, 0)];
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
    button.frame = CGRectMake(50, 150, 150, 50);
    [button setTitle:@"Animation" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    
    button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(clearnAllOperation) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(260, 150, 50, 50);
    [button setTitle:@"clearn" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    NSString * str3 = @"123";
    
    NSString * cmd = @"setOpenDebugerToggle:";
    cmd = [cmd substringFromIndex:3];
    NSInteger leng = cmd.length;
    cmd = [cmd substringToIndex:leng - 1];
    NSString * key = [NSString stringWithFormat:@"MM_%@",cmd];
    
    MM_UserDefaults.mm_addInt(@"someInt",23);
    MM_UserDefaults.mm_addBool(@"someBool",YES);
    MM_UserDefaults.mm_addString(@"someString",@"string");
    MM_UserDefaults.mm_addObject(@"someObject",@[@"12",@"213"]);

    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    [self.obj setValue:@"rocky" forKeyPath:@"name"];
//    self.obj.name = @"hll";
}
- (void) clearnAllOperation{
    
    [self.coreView removeAllRunwayView];
}

- (void) actioin:(id)ges{
    
    NSLog(@"+++_+_");
    
    MMPreviewHUD * hud = [[MMPreviewHUD alloc] init];
    //[hud showWhileExecuting:@selector(testAction) onTarget:self withObject:nil];
}

- (void) testAction{

    NSLog(@"action");
}

- (void) mm_debugerTool2{

    NSLog(@"mm_debugerTool2");
}

- (void) stopWave{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm_debugerTool2)];
    tapGesture.numberOfTouchesRequired = 2;
    [statusBar addGestureRecognizer:tapGesture];
    
    NSLog(@"%ld",(long)MM_UserDefaults.mm_intValue(@"someInt"));
    NSLog(@"%d",MM_UserDefaults.mm_boolValue(@"someBool"));
    NSLog(@"%@",MM_UserDefaults.mm_stringValue(@"someString"));
    NSLog(@"%@",MM_UserDefaults.mm_objectValue(@"someObject"));
    
    NSString * text = @"<昵称:>消息内容";
    NSArray * array = @[@"<昵称:>消息内容",
                        @"<昵称:>消息内容消息内容",
                        @"<昵称昵称:>消容",
                        @"<昵称:>消息内容消息内容消息内容内容消息内容消息内容内容消息内容消息内容"];
    NSStringFromClass([self class]);
    
    
//    objc_msgSend(self, @selector(testAction));
//    objc_msgSend(self,@selector(testAction));

    
    [self performSelector:@selector(testAction)];
//    SEL testFunc = NSSelectorFromString(@"testAction");
//    ((void(*)(id,SEL))objc_msgSend)(self, testFunc);
    
    NSMutableArray * a = [array mutableCopy];
    while (a.count > 1) {
        [a removeObjectAtIndex:1];
    }
    NSLog(@"a:%@",a);

    return;
    self.index += 1;
    
    if (_index >= array.count) {
        _index = 0;
    }
    text = array[_index];
    
    [MMPreviewHUD showHUD:text inView:self.view target:self action:@selector(actioin:)];
    
    return;
    {
        NSString *scrollTitle = @"恭喜【愤怒的小奴奴】获得【真情七夕活动】中的特别奖品 鹊桥项链 一条";
        
        UIView * testView = [UIView new];
        testView.backgroundColor = [UIColor orangeColor];
        testView.frame = CGRectMake(0, 0, 50, 20);
        [self.coreView appendCustomView:testView];
        [self.coreView appendText:scrollTitle];
        
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
                                        appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor orangeColor],
                                                                          NSStrokeWidthAttributeName:@1}]
                                       attributedString];
        [self.coreView appendAttributedString:string];
        
    }
    
    {
        [self.colorView animation];
    }
    
    
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
