//
//  BillImageExtensionView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillImageExtensionView : UIScrollView

@property (nonatomic ,strong ,readonly) NSMutableArray * images;

- (void) configImages:(NSArray *)images;
@end
