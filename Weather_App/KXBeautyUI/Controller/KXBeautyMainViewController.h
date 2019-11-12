//
//  KXBeautyMainViewController.h
//  KXLive
//
//  Created by ydd on 2019/11/6.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyMainViewController : UIViewController

@property (nonatomic, copy) void(^bPopupCanToushMaskDismiss)(BOOL can);
@end

NS_ASSUME_NONNULL_END
