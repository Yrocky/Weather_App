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

@interface BillExtensionView ()

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
        
        self.backgroundColor = [UIColor randomColor];
        
        UIButton * calendar = [self createButton:nil selectedImage:nil tag:10];
        [self addSubview:calendar];
        
        UIButton * location = [self createButton:nil selectedImage:nil tag:11];
        [self addSubview:location];
        
        UIButton * image = [self createButton:nil selectedImage:nil tag:12];
        [self addSubview:image];
        
        UIButton * remarks = [self createButton:nil selectedImage:nil tag:13];
        [self addSubview:remarks];
        
        NSArray * enters = @[calendar,location,image,remarks];
        [enters mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(self.mas_top).mas_offset(10);
        }];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat spacing = (screenWidth - enters.count * 50) / (enters.count + 1);
        [enters mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:spacing tailSpacing:spacing];
        
        self.extensionContentView = [[UIScrollView alloc] init];
        self.extensionContentView.showsHorizontalScrollIndicator = NO;
        self.extensionContentView.scrollEnabled = NO;
        self.extensionContentView.pagingEnabled = YES;
        self.extensionContentView.contentSize = (CGSize){
            enters.count * screenWidth,
            20
        };
        [self addSubview:self.extensionContentView];
        [self.extensionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.top.mas_equalTo(calendar.mas_bottom).mas_offset(10);
        }];
        
        self.calendarView = [[BillCalendarExtensionView alloc] init];
        [self.extensionContentView addSubview:self.calendarView];
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.extensionContentView);
            make.height.mas_equalTo(self.extensionContentView.mas_height);
            make.width.mas_equalTo(self.extensionContentView.mas_width);
        }];
        
        self.locationView = [[BillLocationExtensionView alloc] init];
        [self.extensionContentView addSubview:self.locationView];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.calendarView);
            make.left.mas_equalTo(self.calendarView.mas_right);
            make.bottom.mas_equalTo(self.calendarView.mas_bottom);
            make.width.mas_equalTo(self.calendarView.mas_width);
        }];
        
        self.imageView = [[BillImageExtensionView alloc] init];
        [self.extensionContentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationView);
            make.left.mas_equalTo(self.locationView.mas_right);
            make.bottom.mas_equalTo(self.locationView.mas_bottom);
            make.width.mas_equalTo(self.locationView.mas_width);
        }];
        
        self.remarksView = [[BillRemarksExtensionView alloc] init];
        [self.extensionContentView addSubview:self.remarksView];
        [self.remarksView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView);
            make.left.mas_equalTo(self.imageView.mas_right);
            make.bottom.mas_equalTo(self.imageView.mas_bottom);
            make.width.mas_equalTo(self.imageView.mas_width);
        }];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (UIButton *) createButton:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onExtensionEnterAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}

- (void) onExtensionEnterAction:(UIButton *)button{

    NSLog(@"tag:%ld",(long)button.tag);
    CGFloat offsetY = self.extensionContentView.contentOffset.y;

    CGPoint contentOffset = (CGPoint){
        (button.tag - 10) * [UIScreen mainScreen].bounds.size.width,
        offsetY
    };
    [self.extensionContentView setContentOffset:contentOffset animated:YES];
}

@end
