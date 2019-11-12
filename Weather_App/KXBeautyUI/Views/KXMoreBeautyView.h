//
//  KXMoreBeautyView.h
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXMoreBeautyView : UIView

@property (nonatomic ,copy) void(^bBackAction)(void);
- (void) reloadData;
@end

NS_ASSUME_NONNULL_END
