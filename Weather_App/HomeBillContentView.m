//
//  HomeBillContentView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "HomeBillContentView.h"
#import "HomeBillContentDateView.h"
#import "HomeBillContentListView.h"
#import "HomeBillContentDefaultView.h"
#import "Masonry.h"

@interface HomeBillContentView()

@property (nonatomic ,strong) NSCalendar * calendar;

@property (readwrite) NSDate * currentDate;
@property (nonatomic ,strong) NSDate * minDate;
@property (nonatomic ,strong) NSDate * maxDate;// 当前日期

@property (nonatomic ,strong) HomeBillContentDateView * dateView;
@property (nonatomic ,strong) HomeBillContentDefaultView * defaultView;
@property (nonatomic ,strong) HomeBillContentListView * billListView;
@end

@implementation HomeBillContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:[NSDate date]];
        components.hour = 0;
        _currentDate = [self.calendar dateFromComponents:components];
        _maxDate = [self tomorrowOf:[self tomorrowOf:self.currentDate]];// 设置当前日期的下下一天为最大日期
        _minDate = [self yesterdayOf:self.currentDate];// 模拟当前日期的前一天为最小日期，正常开发中是根据所有的记账日期中最早的日期为最小日期
        
        _dateView = [HomeBillContentDateView new];
        [self addSubview:self.dateView];
        
        self.billListView = [HomeBillContentListView new];
        [self addSubview:self.billListView];
        
        self.defaultView = [HomeBillContentDefaultView new];
        self.defaultView.hidden = YES;// debug
        [self addSubview:self.defaultView];
       
        [self updateDateViewAndBillListView];
        
        [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(30);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(180);
        }];
        
        [self.billListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.defaultView);
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.top.mas_equalTo(self.dateView.mas_bottom);
        }];
        
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(200);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-130);
        }];
    }
    return self;
}

- (void) updateContentViewWithPreDate{

    self.currentDate = [self yesterdayOf:self.currentDate];
    
    [self updateDateViewAndBillListView];
}

- (void) updateContentViewWithNextDate{
    
    self.currentDate = [self tomorrowOf:self.currentDate];
    
    [self updateDateViewAndBillListView];
}

- (void) updateDateViewAndBillListView{
    
    // 更新date-view
    [self.dateView updateDateViewWith:[self dateData]];
    
    // 更新日期下的bill-list-view
    // 根据日期去数据库查询数据，交给listView
    /*debug*/
    BOOL isToday = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:self.currentDate].day == [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:[NSDate date]].day;
    if (isToday) {// 模拟查询到当日没有记账数据
        self.billListView.hidden = YES;
        self.defaultView.hidden = NO;
    }else{
        self.billListView.hidden = NO;
        self.defaultView.hidden = YES;
        [self.billListView updateBillListViewWith:nil];
    }
}

- (BOOL) currentDateIsMinDate{
    return [self.currentDate compare:self.minDate];
}

- (BOOL) currentDateIsMaxDate{
    return [self.currentDate compare:self.maxDate];
}

#pragma mark - tools

- (NSDictionary *) dateData{
    
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    comps = [self.calendar components:unitFlags fromDate:self.currentDate];
    
    return @{@"year":@(comps.year),
             @"month":@(comps.month),
             @"day":@(comps.day),
             @"week":@(comps.weekday)
             };
}

- (NSDate *) tomorrowOf:(NSDate *)date{
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.day++;
    components.hour = 0;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *) yesterdayOf:(NSDate *)date{
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.day--;
    components.hour = 0;
    return [self.calendar dateFromComponents:components];
}
@end
