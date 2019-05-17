//
//  MMVertex.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMVertex.h"
#import "MMEdge.h"
#import "NSArray+Unretained.h"

@implementation MMVertex

- (void)dealloc{
    NSLog(@"[MMVertex] dealloc %@",self);
}

+ (instancetype) vertex:(id)value{
    
    MMVertex * v = [MMVertex new];
    v->_value = value;
    return v;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _edges = [NSMutableSet set];
        _vertexs = [NSMutableSet unreatainedMutableSet];
        
        NSPointerFunctionsOptions options = NSPointerFunctionsWeakMemory |
        NSPointerFunctionsOpaquePersonality;
        
        NSHashTable *table = [NSHashTable hashTableWithOptions:options];
        _table = table;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    return [object isKindOfClass:[self class]] &&
    ((MMVertex *)object).value == self.value;
}

- (NSUInteger)hash{
    return [self.value hash];
}

- (void)addAdjacent:(MMVertex *)node{

    NSAssert(node, @"要添加的邻接节点不能为空");
    
    if ([_vertexs containsObject:node]) {
        return;
    }
    if ([_table containsObject:node]) {
        return;
    }
    ///<使用集合的弱引用分类方法
//    @synchronized (_vertexs) {
//        [_vertexs unretainedAddObj:node];
//    }

    ///<使用哈希表
    @synchronized (_table) {
        [_table addObject:node];
    }
//    MMEdge * edge = [MMEdge edgeFrom:self to:node];
//    [self addEdge:edge];
}

- (void)addEdge:(MMEdge *)edge{
    
    NSAssert(edge &&
             (edge.from == self || edge.to == self), @"请设置正确edge:%@",edge);
    @synchronized (_edges) {
        [_edges addObject:edge];
    }
}

- (NSSet<MMEdge *> *)adjacentEdges{
    
    @synchronized (_edges) {
        return [_edges copy];
    }
}

- (NSSet *)adjacents{
    
//    @synchronized (_vertexs) {
//        return [_vertexs copy];
//    }
    @synchronized (_table) {
        return [NSSet setWithArray:[_table allObjects]];
    }
}

- (NSUInteger)outdegree{
    return self.adjacents.count;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"(vertex: %@)", self.value];
}
@end
