//
//  AsyncDrawViewController.m
//  Weather_App
//
//  Created by user1 on 2018/3/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "AsyncDrawViewController.h"
#import "UIView+AsyncDrawImage.h"
#import "HLLAttributedBuilder.h"

@interface AsyncDrawViewController ()

@end

@implementation AsyncDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self comAtt];
    return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"故障线@2x" ofType:@"png"]];
        NSLog(@"image:%@",image);
        CGSize size = image.size;
        NSLog(@"image.size:%@",NSStringFromCGSize(size));
        
        NSLog(@"image.size:%@",NSStringFromCGSize(image.size));
        NSLog(@"%f,%f",image.size.width,image.size.height);
//        NSLog(@"image.scale:%d",image.size);
        NSLog(@"+++++++++");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"故障线@3x" ofType:@"png"]];
            NSLog(@"image:%@",image);
            NSLog(@"image.size:%@",NSStringFromCGSize(image.size));
//            NSLog(@"image.scale:%d",image.size);
            NSLog(@"%f,%f",image.size.width,image.size.height);
        });
    });
    
    
    
//    [self loadImageWithAsyncContents];
    [self loadImageWithAsync];
    [self loadImageWithImageFilePath];
    [self loadImageWithImageName];
}

- (void) loadImageWithAsyncContents{
    
    UIImageView * view = [[UIImageView alloc] init];
    view.frame = CGRectMake(100, 50, 56, 24);
    [self.view addSubview:view];
//    [view asyncDrawImage:@"img_user_level_20" result:^(UIImage *image) {
//        view.layer.contents = (__bridge id _Nullable)(image.CGImage);
//    }];
}

- (void) loadImageWithAsync{
    
    UIButton * view = [[UIButton alloc] init];
    view.frame = CGRectMake(100, 100, 28, 12);
    [view asyncDrawImage:@"img_user_level_0" forState:UIControlStateNormal];
//    [view asyncDrawImage:@"故障线@3x" forState:UIControlStateHighlighted];
    [view asyncDrawBackgroundImageWithColor:[UIColor colorWithWhite:0.9 alpha:0.6] forState:UIControlStateNormal];
    
    [self.view addSubview:view];
//    [view asyncDrawImage:@"img_user_level_20" result:^(UIImage *image) {
//        view.image = image;
//    }];
}

- (void) loadImageWithImageFilePath{
    
    UIButton * view = [[UIButton alloc] init];
    view.frame = CGRectMake(100, 150, 56, 24);
    [view setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_user_level_0" ofType:@"png"]] forState:UIControlStateNormal];
    [view setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_user_level_1" ofType:@"png"]] forState:UIControlStateHighlighted];
    [self.view addSubview:view];
//    otherImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_user_level_20" ofType:@"gif"]];
}

- (void) loadImageWithImageName{
    
    UIButton * view = [[UIButton alloc] init];
    view.frame = CGRectMake(100, 200, 56, 24);
    
    [view setImage:[UIImage imageNamed:@"img_user_level_0"] forState:UIControlStateNormal];
    [view setImage:[UIImage imageNamed:@"img_user_level_1"] forState:UIControlStateHighlighted];
    [self.view addSubview:view];
//    otherImageView.image = [UIImage imageNamed:@"img_user_level_20.gif"];
}

- (void) comAtt{
    
    [self hllAtt];
    [self sysAtt];
}

- (void) hllAtt{
    
    UILabel * label = [UILabel new];
    label.frame = CGRectMake(20, 100, 300, 20);
    [self.view addSubview:label];
    label.attributedText = [HLLAttributedBuilder builderWithString:@"this is name for rocky" defaultStyle:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                     NSForegroundColorAttributeName:[UIColor orangeColor]}].appendString(@"HELLO").attributedString;
}

- (void) sysAtt{
    
    UILabel * labe = [UILabel new];
    labe.frame = CGRectMake(20, 200, 300, 20);
    [self.view addSubview:labe];
    labe.attributedText = [[NSMutableAttributedString alloc] initWithString:@"this is name for rocky" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                            NSForegroundColorAttributeName:[UIColor orangeColor]}];
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
