//
//  BillExtensionView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillExtensionView.h"
#import "BillCalendarExtensionView.h"
#import "BillLocationExtensionView.h"
#import "BillImageExtensionView.h"
#import "BillRemarksExtensionView.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface BillExtensionView ()<UIScrollViewDelegate>

//@property (nonatomic ,strong) NSArray * extensionsEnter;
@property (strong, nonatomic) UIScrollView * extensionContentView;

@property (strong, nonatomic) BillCalendarExtensionView * calendarView;
@property (strong, nonatomic) BillLocationExtensionView * locationView;
@property (strong, nonatomic) BillImageExtensionView * imageView;
@property (strong, nonatomic) BillRemarksExtensionView * remarksView;
@end

@implementation BillExtensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * calendar = [self createButton:nil selectedImage:nil tag:10];
        [self addSubview:calendar];
        
        UIButton * location = [self createButton:nil selectedImage:nil tag:11];
        [self addSubview:location];
        
        UIButton * image = [self createButton:nil selectedImage:nil tag:12];
        [self addSubview:image];
        
        UIButton * remarks = [self createButton:nil selectedImage:nil tag:13];
        [self addSubview:remarks];
        
        self.extensionContentView = [[UIScrollView alloc] init];
        self.extensionContentView.showsHorizontalScrollIndicator = NO;
        self.extensionContentView.delegate = self;
        self.extensionContentView.pagingEnabled = YES;
        [self addSubview:self.extensionContentView];
        
        self.calendarView = [[BillCalendarExtensionView alloc] init];
        [self.extensionContentView addSubview:self.calendarView];
        
        self.locationView = [[BillLocationExtensionView alloc] init];
        [self.extensionContentView addSubview:self.locationView];
        
        self.imageView = [[BillImageExtensionView alloc] init];
        [self.extensionContentView addSubview:self.imageView];
        
        self.remarksView = [[BillRemarksExtensionView alloc] init];
        [self.extensionContentView addSubview:self.remarksView];
        
    }
    
    return self;
}

- (UIButton *) createButton:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.tag = tag;
    return button;
}

- (void) onExtensionEnterAction:(UIButton *)button{

    NSLog(@"tag:%ld",(long)button.tag);
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    NSLog(@"offset:%f",scrollView.contentOffset.x);
}

@end
