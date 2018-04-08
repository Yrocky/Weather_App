//
//  BillKeyboardView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/6.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillKeyboardView.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface _BillKeyboardItemButton : UIButton

@end

@implementation _BillKeyboardItemButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}

+ (instancetype) itemButtonWith:(NSString *)title{
    
    _BillKeyboardItemButton * button = [[_BillKeyboardItemButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateHighlighted];
    return button;
}
@end

@interface BillKeyboardView ()

@property (nonatomic ,strong) _BillKeyboardItemButton * doneButton;

@end

@implementation BillKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor randomColor];
        @autoreleasepool{
            
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat itemWidth = (screenWidth - 3) / 4.0;
            CGFloat itemHeight = itemWidth / 1.68;
            
            NSArray * lineOne = @[
                                  [self createButton:@"7" tag:7],
                                  [self createButton:@"8" tag:8],
                                  [self createButton:@"9" tag:9],
                                  [self createButton:@"Del" tag:10],
                                  ];
            [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            [lineOne mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
            
            NSArray * lineTwo = @[
                                  [self createButton:@"4" tag:4],
                                  [self createButton:@"5" tag:5],
                                  [self createButton:@"6" tag:6],
                                  [self createButton:@"+" tag:11],
                                  ];
            [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).mas_offset(itemHeight + 1);
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            [lineTwo mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
            
            NSArray * lineThree = @[
                                    [self createButton:@"1" tag:1],
                                    [self createButton:@"2" tag:2],
                                    [self createButton:@"3" tag:3],
                                    [self createButton:@"-" tag:12],
                                    ];
            [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).mas_offset(itemHeight * 2 + 2);
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            [lineThree mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
            
            NSArray * lineFour = @[
                                   [self createButton:@"" tag:13],
                                   [self createButton:@"0" tag:0],
                                   [self createButton:@"." tag:14],
                                   [self createButton:@"完成" tag:15],
                                   ];
            self.doneButton = lineFour[3];
            [self.doneButton setTitle:@"=" forState:UIControlStateSelected];
            [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).mas_offset(itemHeight * 3 + 3);
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            }];
            [lineFour mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
        }
    }
    return self;
}

- (_BillKeyboardItemButton *) createButton:(NSString *)title tag:(NSInteger)tag{
    
    _BillKeyboardItemButton * button = [_BillKeyboardItemButton itemButtonWith:title];
    button.tag = tag;
    [button addTarget:self action:@selector(onKeyboardItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void) onKeyboardItemAction:(UIButton *)button{
    
    NSInteger tag = button.tag;
    
    if (tag != 13) {
        if (tag == 12 || tag == 11) {
            self.doneButton.selected = YES;
        }else{
            self.doneButton.selected = NO;
        }
        if (tag == 15) {
            if (self.doneButton.isSelected) {
                NSLog(@"进行计算");
            }else{
                NSLog(@"点击完成");
            }
        }
    }
}

@end
