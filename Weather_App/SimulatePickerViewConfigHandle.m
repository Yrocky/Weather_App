//
//  SimulatePickerViewConfigHandle.m
//  Weather_App
//
//  Created by Rocky Young on 2017/9/23.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "SimulatePickerViewConfigHandle.h"

@implementation SimulatePickerViewConfigHandle


@end


@implementation SimulateConfig

- (void)config:(NSArray<NSString *> *(^)(NSUInteger))cb{

    _rowDataItemAt = cb;
}

@end
