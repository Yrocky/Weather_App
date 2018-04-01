//
//  HomeBillContentDateView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContentDateView.h"
#import "UIColor+Common.h"
#import "Masonry.h"

@interface HomeBillContentDateView()

@property (nonatomic ,strong) UILabel * yearMonthLabel;
@property (nonatomic ,strong) UILabel * dayLabel;
@property (nonatomic ,strong) UILabel * weekLabel;
@property (nonatomic ,strong) UIImageView * restImageView;
@end

@implementation HomeBillContentDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.yearMonthLabel = [UILabel new];
        self.yearMonthLabel.textAlignment = NSTextAlignmentCenter;
        self.yearMonthLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.yearMonthLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];
        [self addSubview:self.yearMonthLabel];
        
        self.dayLabel = [UILabel new];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = [UIFont systemFontOfSize:100 weight:UIFontWeightThin];
        self.dayLabel.textColor = [UIColor colorWithHexString:@"363B40"];
        [self addSubview:self.dayLabel];
        
        self.weekLabel = [UILabel new];
        self.weekLabel.textAlignment = NSTextAlignmentCenter;
        self.weekLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        self.weekLabel.textColor = [UIColor colorWithHexString:@"9B9B9B"];
        [self addSubview:self.weekLabel];
        
        self.restImageView = [UIImageView new];
        self.restImageView.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.restImageView];
        
        [self.yearMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(30);
        }];
        
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_greaterThanOrEqualTo(74);
            make.height.mas_equalTo(74);
        }];
        
        [self.restImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.left.mas_equalTo(self.dayLabel.mas_right);
            make.bottom.mas_equalTo(self.dayLabel);
        }];
        
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-12);
        }];
    }
    return self;
}

- (void) updateDateViewWith:(id)date{
    
    // 内部根据https://github.com/cyanzhong/LunarCore/blob/master/LunarCore/LunarCore.h进行节假日的获取
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%@.%@",date[@"year"],date[@"month"]];
    self.dayLabel.text = [NSString stringWithFormat:@"%@",date[@"day"]];
    self.weekLabel.text = weekDay(date[@"week"]);
}

static inline NSString * weekDay(NSNumber * week){
    
    NSString * weekDay;
    switch ([week integerValue]) {
        case 1:
            weekDay = @"星期日";
            break;
        case 2:
            weekDay = @"星期一";
            break;
        case 3:
            weekDay = @"星期二";
            break;
        case 4:
            weekDay = @"星期三";
            break;
        case 5:
            weekDay = @"星期四";
            break;
        case 6:
            weekDay = @"星期五";
            break;
        case 7:
            weekDay = @"星期六";
            break;
        default:
            break;
    }
    return weekDay;
}
@end
