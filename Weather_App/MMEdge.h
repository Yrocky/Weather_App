//
//  MMEdge.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MMVertex;

// 图 中节点之间的边
@interface MMEdge : NSObject

@property (nonatomic ,strong ,readonly) MMVertex * from;
@property (nonatomic ,strong ,readonly) MMVertex * to;

@property (nonatomic ,strong) NSNumber * weight;

+ (instancetype) edgeFrom:(MMVertex *)from to:(MMVertex *)to;

@end

NS_ASSUME_NONNULL_END
