//
//  MMGraph.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MMVertex;
@class MMEdge;
@interface MMGraph : NSObject

@property (nonatomic ,strong ,readonly) MMVertex * startVertex;

// 构建一个图，要有一个起始的节点
+ (instancetype) graphStart:(MMVertex *)startVertex;

- (MMVertex *) addVertex:(MMVertex *)vertex;

///<找到vertex的所有邻接节点
- (NSSet<MMVertex *> *) findAdjacents:(MMVertex *)vertex;

- (void) addEdge:(MMEdge *)edge;
- (void) addEdges:(NSArray<MMEdge *> *)edges;
@end

NS_ASSUME_NONNULL_END
