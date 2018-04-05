//
//  BillCalendarExtensionView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillCalendarExtensionView : UIView

@property (nonatomic ,strong ,readonly) NSDate * billDate;

- (void) configCalendarWithDate:(NSDate *)date;
@end
