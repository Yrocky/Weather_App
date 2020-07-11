//
//  UIView+FrameLayoutSupport.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/27.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAnchor : NSObject

@end
@interface MMAnchorMaker : NSObject


@end

@interface UIView (FrameLayoutSupport)

- (UIView *(^)(UIView *)) equalTo;
- (void(^)(CGFloat))offset;

@end

NS_ASSUME_NONNULL_END
