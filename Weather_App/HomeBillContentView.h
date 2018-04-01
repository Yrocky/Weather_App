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
@end
