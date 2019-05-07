//
//  MMAST.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMObjDescribeAble.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 抽象语法树的抽象类
@interface MMAST : NSObject<MMObjDescribeAble>

// subclass override
- (CGFloat) visit;
- (NSString *) toLispStyle;
- (NSString *) toBackStyle;
@end

NS_ASSUME_NONNULL_END
