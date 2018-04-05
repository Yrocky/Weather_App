//
//  BillExtensionView.h
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillExtensionView;

@protocol BillExtensionViewDelegate <NSObject>

//- (void) billExtensionViewDidAddImageForBill:(BillExtensionView *)ectensionView;

@end

@interface BillExtensionView : UIView

@property (nonatomic ,weak) id<BillExtensionViewDelegate>delegate;
@end
