//
//  HomeBillContentListView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/1.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBillContentListView : UIView

// 外部根据日期获取到对应日期下的记账数据：列表、汇总
- (void) updateBillListViewWith:(id)data;
@end
