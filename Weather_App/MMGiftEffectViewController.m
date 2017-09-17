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

@interface MMGiftEffectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MMGiftEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.backgroundColor = [UIColor clearColor];
    NSString * a = @"a[bc]d(you)A[BCD]1【大家好】2《叔》a[gs]34(me)";
    NSAttributedString * attS = AttBuilderWith(a).
    configStringAndStyle(@"(?<=\\《)[^\\》]+",@{NSForegroundColorAttributeName:[UIColor orangeColor]}).
    configStringAndStyle(@"[《》]",@{NSForegroundColorAttributeName:[UIColor clearColor]}).
    attributedStr();
    self.label.attributedText = attS;
    
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
    
    
    // 以上的正则中用了**零宽断言**的语法 http://www.ibloger.net/article/31.html  https://developer.apple.com/documentation/foundation/nsregularexpression
    
    NSRegularExpression * rx = [NSRegularExpression regularExpressionWithPattern:@"h" options:0 error:nil];
    NSString * string = @"H-h-H-h";
    NSArray * match = [rx matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSLog(@"match :%@",match);
}

- (void)viewWillAppear:(BOOL)animated{

    
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
