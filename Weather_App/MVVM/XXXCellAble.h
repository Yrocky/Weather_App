//
//  XXXCellAble.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXCellLayoutData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XXXCellAble <NSObject>

@property (nonatomic ,strong ,readonly) __kindof XXXCellLayoutData * layoutData;

- (void) setupWithLayoutData:(__kindof XXXCellLayoutData *)layoutData;

@end

NS_ASSUME_NONNULL_END
