//
//  HomeBillContentView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBillContentView : UIView

@property (nonatomic ,strong ,readonly) NSDate * currentDate;

- (void) updateContentViewWithPreDate;

- (void) updateContentViewWithNextDate;

- (BOOL) currentDateIsMinDate;
- (BOOL) currentDateIsMaxDate;

- (BOOL) currentDateIsToday;
- (BOOL) currentDateIsPreOfToday;// 当前日期是今天的前面
- (BOOL) currentDateIsNextOfToday;// 当前日期是今天的后面

- (NSComparisonResult) currentDateCompare:(NSDate *)date;

// 处理外部点击展示今天的数据
- (void) updateContentViewForToday;
// 传递一个日期，然后更新改日期下的数据
- (void) updateContentViewFor:(NSDate *)date;

@end
