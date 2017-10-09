//
//  SimulatePickerViewConfigHandle.h
//  Weather_App
//
//  Created by Rocky Young on 2017/9/23.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimulateConfig : NSObject{

    NSArray *(^_rowDataItemAt)(NSUInteger);
}

@property (nonatomic ,assign) NSUInteger components;

- (void) config:(NSArray <NSString *>*(^)(NSUInteger))cb;


@end

@interface SimulatePickerViewConfigHandle : NSObject

- (instancetype) initWithConfig:(SimulateConfig *)config;

@end
