//
//  RoomModel.m
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "RoomModel.h"
#import "NSArray+Sugar.h"

static NSArray * pics;

@implementation RoomModel

+ (void)initialize{
    pics = @[@"http://n.sinaimg.cn/games/3c3de2ce/20160105/3.jpg",
             @"http://img4.duitang.com/uploads/item/201402/14/20140214120558_2f4NN.jpeg",
             @"http://pic1.win4000.com/wallpaper/2018-12-01/5c02207660e6d.jpg",
             @"http://img4.kfcdn.com/isy/upload/booklet/20130428/e3uc6ca64kvmyhgi_watermark.jpg",
             @"http://s9.knowsky.com/bizhi/l/20090808/200911053%20%2838%29.jpg",
             @"http://a1.hoopchina.com.cn/attachment/Day_091002/176_272354_e50d5bc53324bad.jpg"];
}

+ (instancetype) room:(NSUInteger)roomId{
    return [[self alloc] initWithRoom:roomId];
}

- (instancetype) initWithRoom:(NSUInteger)roomId{
    self = [super init];
    if (self) {
        
        self.roomId = roomId;
        self.roomName = [NSString stringWithFormat:@"name:%ld",(long)roomId];
        self.pic = [pics mm_sample];
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        return ((RoomModel *)object).roomId == self.roomId;
    }
    return [super isEqual:object];
}

+ (NSArray<RoomModel *> *)dataSource{
    return @[[RoomModel room:100],
             [RoomModel room:101],
             [RoomModel room:102],
             [RoomModel room:103],
             [RoomModel room:104]
             ];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"RoomModel【id:%ld】", (long)self.roomId];
}
- (NSString *)debugDescription{
    return [self description];
}
@end
