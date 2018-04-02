
//
//  HomeBillContentListView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContentListView.h"
#import "UIColor+Common.h"
#import "Masonry.h"

@interface HomeBillListCell : UITableViewCell
@property (nonatomic ,strong) UILabel * billLabel;
@end

@implementation HomeBillListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.transform = CGAffineTransformMakeScale (1,-1);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.billLabel = [UILabel new];
        self.billLabel.textAlignment = NSTextAlignmentRight;
        self.billLabel.textColor = [UIColor colorWithHexString:@"363B40"];
        self.billLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        [self.contentView addSubview:self.billLabel];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.billLabel.frame = self.contentView.frame;
}

@end

@interface HomeBillContentListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * listView;
@property (nonatomic ,strong) UIView * lineView;
@property (nonatomic ,strong) UILabel * totalBillLabel;

@property (nonatomic ,strong) CAGradientLayer * customMaskLayer;
@end

@implementation HomeBillContentListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.listView = [[UITableView alloc] init];
        self.listView.delegate = self;
        self.listView.dataSource = self;
        self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.listView.rowHeight = 30;
        self.listView.transform = CGAffineTransformMakeScale (1,-1);
        self.listView.showsVerticalScrollIndicator = NO;
        self.listView.backgroundColor = [UIColor clearColor];
        [self.listView registerClass:[HomeBillListCell class] forCellReuseIdentifier:@"bill-reuse-identifier"];
        self.listView.backgroundView = nil;
        [self addSubview:self.listView];
        
        self.customMaskLayer = [CAGradientLayer layer];
        self.customMaskLayer.startPoint = CGPointMake(0, 0);
        self.customMaskLayer.endPoint   = CGPointMake(0, 1);
        self.customMaskLayer.locations  = @[@(0), @(0.03), @(1)];
        self.customMaskLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
                                        (__bridge id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,
                                        (__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
        self.layer.mask = self.customMaskLayer;
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"9B9B9B"];
        [self addSubview:self.lineView];
        
        self.totalBillLabel = [UILabel new];
        self.totalBillLabel.textAlignment = NSTextAlignmentRight;
        self.totalBillLabel.textColor = [UIColor colorWithHexString:@"363B40"];
        self.totalBillLabel.text = @"记账10笔，消费1234元";
        self.totalBillLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        [self addSubview:self.totalBillLabel];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.customMaskLayer.frame = self.bounds;
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(50 + 20);
        make.right.mas_equalTo(self.mas_right).mas_offset(-50 - 20);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.lineView.mas_top).mas_offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.listView);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(self.totalBillLabel.mas_top);
    }];
    
    [self.totalBillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.right.mas_equalTo(self.listView);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)updateBillListViewWith:(id)data{

    [self.listView reloadData];
    [self.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 12;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeBillListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bill-reuse-identifier"];
    cell.billLabel.text = [NSString stringWithFormat:@"row:%ld",(long)indexPath.row];
    return cell;
}

@end
