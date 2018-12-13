//
//  RoundCornerViewController.m
//  Weather_App
//
//  Created by user1 on 2018/8/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "RoundCornerViewController.h"
#import "MM24GameManager.h"
#import "UIView+RoundCorner.h"
#import "Masonry.h"
#import "UIImage+DrawImage.h"

@interface RoundCornerViewController ()
@property (nonatomic ,strong) UIView * roundView;
@property (nonatomic ,strong) UIView * roundMasView;
@property (nonatomic ,strong) UIView * roundMas2View;
@end

@implementation RoundCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    MM24GameManager * mgr = [[MM24GameManager alloc] init];
    NSArray * results = [mgr sumEqual24Results:2 b:1 c:10 d:13];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * roundView = [UIView new];
    roundView.frame = CGRectMake(20, 100, 100, 100);
    [self.view addSubview:roundView];
    
//    [roundView mm_makeRoundCorner:^(MM_RoundCorner *make) {
//        make.innerColor([UIColor redColor]);
//        make.radius(CGSizeMake(4, 4)).corners(UIRectCornerAllCorners);
//        make.borderWidth(1).borderColor([UIColor greenColor]);
//        make.shadowColor([UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]).shadowOffset(CGSizeMake(5, 5)).shadowBlur(2.0);
//    }];
    
    self.roundView = [UIView new];
    [self.view addSubview:self.roundView];
//    [self.roundView mm_makeRoundCorner:^(MM_RoundCorner *make) {
//        make.innerColor([UIColor orangeColor]);
//        make.borderWidth(1).borderColor([UIColor greenColor]);
//    }];
    
    UILabel * label = [UILabel new];
    label.text = @"    this is a text label    ";
    label.textColor = [UIColor greenColor];
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roundView.mas_right).mas_offset(40);
        make.top.mas_equalTo(self.roundView);
    }];
//    [label mm_makeRoundCorner:^(MM_RoundCorner *make) {
////        make.innerColor([UIColor redColor]);
//        make.borderColor([UIColor orangeColor]).borderWidth(1).radius(CGSizeMake(4, 4));
//        make.outerColor([UIColor grayColor]);
//    }];
    
    self.roundMasView = [UIView new];
    [self.view addSubview:self.roundMasView];
//    [self.roundMasView mm_makeRoundCorner:^(MM_RoundCorner *make) {
//        make.innerColor([UIColor greenColor]);
//        make.radius(CGSizeMake(10, 10)).corners(UIRectCornerTopRight | UIRectCornerTopLeft);
//    }];
    [self.roundMasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.right.left.mas_equalTo(self.roundView);
        make.top.mas_equalTo(self.roundView.mas_bottom).mas_offset(50);
    }];
    
    self.roundMas2View = [UIView new];
    [self.view addSubview:self.roundMas2View];
//    [self.roundMas2View mm_makeRoundCorner:^(MM_RoundCorner *make) {
//        make.innerColor([UIColor blueColor]);
//        make.borderWidth(4).borderColor([UIColor greenColor]);
//        make.radius(CGSizeMake(10, 10)).corners(UIRectCornerBottomRight | UIRectCornerBottomLeft);
//    }];
    
    UIImageView * view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"sunset"];
//    [view.layer yy_setImageWithURL:[NSURL URLWithString:imageURL] options:YYWebImageOptionSetImageWithFadeAnimation];
    view.frame = CGRectMake(150, 50, 150, 100);
    [self.view addSubview:view];
//    view.image = [[[[[[UIImage imageDrawerWithResizable]
//                      borderWidth:2]
//                     borderColor:[UIColor orangeColor]]
//                    borderAlinment:MMBorderAligmentCenter]
//                   cornerRadius:20] image];
    
//    view.image = [[[[[UIImage imageDrawerWithResizable]
//                     cornerTopLeft:10] cornerBottomRight:10]
//                   fillGradientColor:@[[UIColor orangeColor],[UIColor redColor]]
//                   locations:@[@(0.5),@(0.8)]
//                   startPoint:CGPointMake(.0, 0)
//                   endPoint:CGPointMake(1., 1.)] image];
    
    view.image = [[[[[[[UIImage imageDrawerWithResizable]
                      fillColor:[UIColor redColor]]
                     cornerTopLeft:10]
                     borderWidth:2] borderColor:[UIColor greenColor]]
                   borderAlinment:MMBorderAligmentInside] image];
//    [view mm_makeRoundCorner:^(MM_RoundCorner *make) {
//        make.outerColor([UIColor redColor]);
//        make.radius(CGSizeMake(10, 10)).corners(UIRectCornerAllCorners);
//        make.borderWidth(2).borderColor([UIColor orangeColor]);
//    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.roundView.frame = CGRectMake(20, 250, 100, 100);
    
    [self.roundMas2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.right.left.mas_equalTo(self.roundMasView);
        make.top.mas_equalTo(self.roundMasView.mas_bottom).mas_offset(50);
    }];
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

- (void) setCornerRadius:(CGSize)size corner:(UIRectCorner)corner color:(UIColor *)color{
    
//    self.backgroundColor = [UIColor clearColor];
    UIImage * image = [RoundCornerViewController mm_imageWithColor:color
                                                         imageSize:self.view.bounds.size
                                                      cornerRadius:size
                                                            corner:corner];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
//    self.layer.contents = (__bridge id)image.CGImage;
    [CATransaction commit];
}

+ (UIImage *)mm_imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize cornerRadius:(CGSize)size corner:(UIRectCorner)corner{
    CGRect rect = (CGRect){
        CGPointZero,
        imageSize
    };
    UIGraphicsBeginImageContext(rect.size);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:size];
    [path addClip];
    [color setFill];
    [path fill];
    [[UIColor greenColor] setStroke];
    path.lineWidth = 13/[UIScreen mainScreen].scale;
    [path stroke];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
