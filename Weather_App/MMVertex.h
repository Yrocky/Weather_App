//
//  MMVertex.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MMEdge;
// 图 中的节点
@interface MMVertex<V> : NSObject{
    NSMutableSet<MMEdge *> * _edges;
    NSMutableSet<MMVertex *> * _vertexs;///<内部使用一个弱引用对象的集合
    NSHashTable<MMVertex *> * _table;///<使用hashtable来弱引用相邻接点
}

@property (nonatomic ,strong ,readonly) V value;///<该节点存储的数据

//@property (nonatomic ,copy ,readonly) NSSet<MMEdge *> * adjacentEdges;///<改节点相邻的边
@property (nonatomic ,copy ,readonly) NSSet<MMVertex<V> *> * adjacents;///<该节点指向的顶点

//@property (nonatomic ,assign ,readonly) NSUInteger indegree;///<入度
@property (nonatomic ,assign ,readonly) NSUInteger outdegree;///<出度

+ (instancetype) vertex:(V)value;

- (void) addAdjacent:(MMVertex *)node;

//- (void) addEdge:(MMEdge *)edge;
@end

NS_ASSUME_NONNULL_END
