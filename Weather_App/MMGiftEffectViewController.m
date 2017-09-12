//
//  MMGiftEffectViewController.m
//  Weather_App
//
//  Created by user1 on 2017/9/12.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftEffectViewController.h"

@interface MMGiftEffectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MMGiftEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    NSRegularExpression * rx = [NSRegularExpression regularExpressionWithPattern:@"h" options:0 error:nil];
    NSString * string = @"H-h-H-h";
    NSArray * match = [rx matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    
    NSLog(@"match :%@",match);
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
