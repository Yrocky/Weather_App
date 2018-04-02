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
#import "LunarCore.h"

@interface HomeBillContentDateView()

@property (nonatomic ,strong) UILabel * yearMonthLabel;
@property (nonatomic ,strong) UILabel * dayLabel;
@property (nonatomic ,strong) UILabel * weekLabel;
@property (nonatomic ,strong) UILabel * restLabel;
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
        
        self.restLabel = [UILabel new];
        self.restLabel.textColor = [UIColor whiteColor];
        self.restLabel.textAlignment = NSTextAlignmentCenter;
        self.restLabel.text = @"休";
        self.restLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        self.restLabel.layer.masksToBounds = YES;
        self.restLabel.layer.cornerRadius = 5;
        self.restLabel.backgroundColor = [UIColor colorWithHexString:@"e84357"];
        [self addSubview:self.restLabel];
        
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
        
        [self.restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    NSString * weekDay = __weekDay(date[@"week"]);
    
    NSDictionary * calendarData = solarToLunar([date[@"year"] intValue],[date[@"month"] intValue],[date[@"day"] intValue]);
    
    // rest-view
    int worktime = [calendarData[@"worktime"] intValue];
    int week = [date[@"week"] intValue];
    BOOL isRest = NO;
    if (worktime == 0) {// 无特殊安排
        isRest = (week == 1 || week == 7);
    }else if(worktime == 2){// 放假
        isRest = YES;
    }
    self.restLabel.hidden = !isRest;
    
    // week-view
    NSString * solarFestival = calendarData[@"solarFestival"];
    NSString * lunarFestival = calendarData[@"lunarFestival"];
    NSString * term = calendarData[@"term"];
    
    if (lunarFestival.length > 0) {
        weekDay = [weekDay stringByAppendingString:__addPrefix(@"·", [lunarFestival componentsSeparatedByString:@" "][0])];
    }
    else if(term.length > 0){
        weekDay = [weekDay stringByAppendingString:__addPrefix(@"·", term)];
    }
    else if (solarFestival.length > 0) {
        weekDay = [weekDay stringByAppendingString:__addPrefix(@"·", [solarFestival componentsSeparatedByString:@" "][0])];
    }
    self.weekLabel.text = weekDay;
}

static inline NSString * __weekDay(NSNumber * week){
    
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

static inline NSString * __addPrefix(NSString *prefix,NSString *string){

    if ([string hasPrefix:@"*"]) {
        string = [string substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@%@",prefix,string];
}
@end
