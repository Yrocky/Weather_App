//
//  RoomModel.h
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomModel : NSObject

@property (nonatomic ,assign) NSUInteger roomId;
@property (nonatomic ,copy) NSString * roomName;
@property (nonatomic ,copy) NSString * pic;

+ (instancetype) room:(NSUInteger)roomId;

+ (NSArray<RoomModel *> *)dataSource;
@end

NS_ASSUME_NONNULL_END
