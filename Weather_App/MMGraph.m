//
//  MMGraph.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMGraph.h"
#import "MMVertex.h"
#import "MMEdge.h"
#import "NSArray+Sugar.h"

@interface MMGraph ()

@property (nonatomic ,strong) NSMutableSet * vertexs;

@end

@implementation MMGraph

- (void)dealloc{
    NSLog(@"[MMGraph] dealloc %@",self);
}

+ (instancetype) graphStart:(MMVertex *)startVertex{
    
    MMGraph * graph = [MMGraph new];
    graph->_startVertex = startVertex;
    return graph;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _vertexs = [NSMutableSet set];
    }
    return self;
}

- (MMVertex *) addVertex:(MMVertex *)vertex{

    NSAssert(vertex, @"请插入正确的节点:%@",vertex);
    
    if (![_vertexs containsObject:vertex]){
        [_vertexs addObject:vertex];
    }
    return vertex;
}

- (NSSet<MMVertex *> *) findAdjacents:(MMVertex *)vertex{

    NSAssert([_vertexs containsObject:vertex], @"当前图中没有该节点:%@",vertex);
    return vertex.adjacents;
}

- (void) addEdge:(MMEdge *)edge{
    
    MMVertex * from = [self addVertex:edge.from];
    MMVertex * to = [self addVertex:edge.to];
    [from addAdjacent:to];
}

- (void) addEdges:(NSArray<MMEdge *> *)edges{
    
    [edges mm_each:^(MMEdge *edge) {
        [self addEdge:edge];
    }];
}
@end
