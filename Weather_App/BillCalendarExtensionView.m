//
//  BillCalendarExtensionView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillCalendarExtensionView.h"
#import "Masonry.h"

@interface BillCalendarExtensionView ()

@property (strong, nonatomic) UIDatePicker * datePickerView;
@end

@implementation BillCalendarExtensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.datePickerView = [[UIDatePicker alloc] init];
        self.datePickerView.date = [NSDate date];
        self.datePickerView.maximumDate = [NSDate date];
        self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview:self.datePickerView];
        [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (void) configCalendarWithDate:(NSDate *)date{
    
    self.datePickerView.date = date;
}

- (NSDate *)billDate{
    return self.datePickerView.date;
}
@end
