//
//  HomeBillContainerView.m
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContainerView.h"
#import "HLLStickIndicator.h"

@interface HomeBillContainerView()
@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic ,strong) HLLStickIndicatorView * leftIndocatorView;
@property (nonatomic ,strong) HLLStickIndicatorView * rightIndocatorView;
@end

@implementation HomeBillContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        
        self.leftIndocatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorLeft];
        self.leftIndocatorView.restorationIdentifier = @"left-indocator";
        [self.leftIndocatorView configIndicatorInfo:@"前一天"];
        [self addSubview:self.leftIndocatorView];
        
        self.rightIndocatorView = [[HLLStickIndicatorView alloc] initWithDirection:HLLStickIndicatorRight];
        self.rightIndocatorView.restorationIdentifier = @"right-indocator";
        [self.rightIndocatorView configIndicatorInfo:@"后一天"];
        [self addSubview:self.rightIndocatorView];
    }
    return self;
}

@end
