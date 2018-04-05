//
//  BillRemarksExtensionView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillRemarksExtensionView.h"
#import "Masonry.h"
#import "HLLPlaceholderTextView.h"

@interface BillRemarksExtensionView ()

@property (strong, nonatomic) UIPlaceholderTextView * remarksView;

@end

@implementation BillRemarksExtensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.remarksView = [[UIPlaceholderTextView alloc] init];
        self.remarksView.placeholder = @"点击添加记账备注";
        self.remarksView.placeholderColor = [UIColor lightGrayColor];
        [self addSubview:self.remarksView];
        
    }
    return self;
}

@end
