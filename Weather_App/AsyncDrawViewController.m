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
#import <malloc/malloc.h>
#import "HLLAlert.h"
#import <objc/runtime.h>
#import "UIView+RoundCorner.h"

@interface MMObject : NSProxy{
//    int age;// 4字节
//    NSString * name;// 8字节
}
- (void) foo;
+ (void) mock;
@end
@implementation MMObject
- (void) foo{}
+ (void) mock{}
@end

@interface MMString : NSString

@end
@implementation MMString

- (instancetype)init{

    id result = [super init];
    if (result == self) {
        NSLog(@"result:%@\nself:%@",result,self);
    }
    return result;
}
@end
@interface AsyncDrawViewController ()

@end

@implementation AsyncDrawViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    return;
    MMString * string = [[MMString alloc] init];
    
    for (int i = 0; i < 1; i ++) {
        
        MMObject * obj = [MMObject alloc];
//        [obj methodForSelector:nil];
        NSString * msg = [NSString stringWithFormat:@"Size of MMObject: %zd bytes", malloc_size((__bridge const void *) obj)];
        [[[[[HLLAlertActionSheet alert]
           title:@"Size"]
          message:msg]
         buttons:@[@"cancel"]]
         showIn:self];
            NSLog(@"%@", msg);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self comAtt];
    
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
//    [self loadImageWithAsync];
//    [self loadImageWithImageFilePath];
//    [self loadImageWithImageName];
    
    [self loadAsyncImage];
}

- (void) loadAsyncImage{
    UIImageView * view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"sunset"];
    view.frame = CGRectMake(100, 50, 150, 100);
    [self.view addSubview:view];
//    [UIImage asyncImageWith:[UIColor redColor] size:CGSizeMake(56, 24) cornerRadius:CGSizeMake(3, 3) corner:UIRectCornerAllCorners result:^(UIImage *img) {
//        view.image = img;
//    }];
//    [view xw_roundedCornerWithCornerRadii:CGSizeMake(10, 10) cornerColor:[UIColor whiteColor] corners:UIRectCornerAllCorners borderColor:[UIColor orangeColor] borderWidth:2];
    [view mm_makeRoundCorner:^(MM_RoundCorner *make) {
        make.outerColor([UIColor whiteColor]);
        make.radius(CGSizeMake(10, 10)).corners(UIRectCornerAllCorners);
        make.borderWidth(2).borderColor([UIColor orangeColor]);
//        make.shadowColor([UIColor colorWithWhite:0.5 alpha:0.2]).shadowOffset(CGSizeMake(5, -10));
    }];
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
