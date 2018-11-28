//
//  MMGiftEffectViewController.m
//  Weather_App
//
//  Created by user1 on 2017/9/12.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftEffectViewController.h"
#import "HLLAttributedBuilder.h"
#import "MM_AutoReplyViewController.h"
#import "NSArray+Sugar.h"

@interface MMGiftEffectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic ,strong) CAShapeLayer * rLayer;

@end

@implementation MMGiftEffectViewController

- (void) mm_debugerTool{

    NSLog(@"mm_debugerTool");
}

- (void) mm_switchNotifyStatusAction{

    NSLog(@"asfhsduhfukshd");
}
static inline NSString * mm_replaceInBracket(NSString *str,NSString * full){
    
    NSString * pattern = @"(?<=\\（)[^\\）]+";
    NSRegularExpression * rx = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult * result = [rx matchesInString:full options:0 range:NSMakeRange(0, full.length)].firstObject;
    NSRange range = result.range;
    range = NSMakeRange(range.location - 1, range.length + 2);
    
    return [full stringByReplacingCharactersInRange:range withString:str];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * full = @"贵宾推荐位（60分钟/次）";
    
    NSString * pattern = mm_replaceInBracket(@"xxx", full);
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * s = @"wxid_nixe0l418pg522,luoqi983272765,333,";
    s = [s substringToIndex:s.length - 1];
    NSArray * a_ = [s componentsSeparatedByString:@","];
    
    NSLog(@"skip:%@",[a_ mm_mapWithskip:^id(id obj, BOOL *skip) {
        
//        *skip = [obj isEqualToString:@"333"];
        return obj;
    }]);
    [a_ enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    UIView * v = [[UIView alloc] initWithFrame:(CGRect){
        100,100,
        1,40
    }];
    v.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:v];
    
    UIView * sv = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 100, 38)];
    sv.backgroundColor = [UIColor redColor];
    [v addSubview:sv];
    UITapGestureRecognizer * mm_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm_switchNotifyStatusAction)];
    mm_tapGesture.numberOfTapsRequired = 1;
    [sv addGestureRecognizer:mm_tapGesture];
    
    
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.label.backgroundColor = [UIColor clearColor];
    NSString * a = @"nihao你好_a:[bc]d(yo:u)A[BCD]1【大家好】2《叔》a[gs]34(me)";
    NSAttributedString * attS = AttBuilderWith(a).
    firstConfigStringAndStyle(@"([^:：]+)[:：]",@{NSForegroundColorAttributeName:[UIColor orangeColor]}).
//    configStringAndStyle(@"[《》]",@{NSForegroundColorAttributeName:[UIColor redColor]}).
    attributedStr();// ([^:：]+)[:：] [a-zA-Z0-9_\u4e00-\u9fa5]+(?=\\:)
    self.label.attributedText = attS;
    
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor orangeColor];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mm_debugerTool)];
    tapGesture.numberOfTouchesRequired = 2;
    [statusBar addGestureRecognizer:tapGesture];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    // 匹配中括号内的内容
    // pattern : abcd[you]ABCD1234[miss]
    // rx: \\[.*\\]
    // result : abcd#[you]ABCD1234[miss]# wrong
    
    // 匹配圆括号内的内容
    // pattern : abcd(you)ABCD1234(miss)
    // rx : (?<=\\()[^\\)]+
    // result : abcd(#you#)ABCD1234(#miss#) right
    
    // 只匹配a字母开始的中括号内的内容
    // pattern : a[bc]d(you)A[BCD]12a[gs]34(miss)
    // rx : (?<=a\\()[^\\)]+
    // result : a[#bc#]d(you)A[BCD]12a[#gs#]34(miss) right
    
    // 匹配冒号前的文字
    // pattern : nihao你好_a:[bc]d(yo:u)A
    // rx : ([^:：]+)[:：]
    
    // 以上的正则中用了**零宽断言**的语法 http://www.ibloger.net/article/31.html  https://developer.apple.com/documentation/foundation/nsregularexpression
    
    NSRegularExpression * rx = [NSRegularExpression regularExpressionWithPattern:@"h" options:0 error:nil];
    NSString * string = @"H-h-H-h";
    NSArray * match = [rx matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSLog(@"match :%@",match);
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor redColor];
    textLabel.text = @"GreenColor";
    textLabel.frame = CGRectMake(50, 300, 100, 30);
    [self.view addSubview:textLabel];
    
    textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor greenColor];
    textLabel.text = @"GreenColor";
    textLabel.frame = CGRectMake(50, 300, 100, 30);
    [self.view addSubview:textLabel];

    self.rLayer = [CAShapeLayer layer];
    self.rLayer.position = CGPointMake(textLabel.bounds.size.width / 2, 1 * textLabel.bounds.size.height / 2);
    self.rLayer.bounds = textLabel.bounds;
    self.rLayer.backgroundColor = [UIColor yellowColor].CGColor;
    
    textLabel.layer.mask = self.rLayer;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.view addGestureRecognizer:tap];
    
    NSCache *  cache = [NSCache new];
}

- (void) move:(UITapGestureRecognizer *)gesture{
    
    [self addMicroPhoneAnimation];
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
    }
}

- (void)addMicroPhoneAnimation
{
    CGPoint beginPoint = self.rLayer.position;
    CGPoint endPoint = CGPointMake(beginPoint.x + 100, beginPoint.y);
    self.rLayer.position = endPoint;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:beginPoint];
    positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAnimation.duration = 10;
    
    [self.rLayer addAnimation:positionAnimation forKey:@""];
}

- (IBAction)gotoAutoReplay:(id)sender {
    
    MM_AutoReplyViewController * autoReplay = [[MM_AutoReplyViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:autoReplay];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)animation:(id)sender {
    
    [UIView transitionWithView:self.label
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                    }
                    completion:NULL];
}


- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
