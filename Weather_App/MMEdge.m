//
//  MMEdge.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMEdge.h"
#import "MMVertex.h"

@implementation MMEdge

- (void)dealloc{
    NSLog(@"[MMEdge] dealloc %@",self);
}

+ (instancetype) edgeFrom:(MMVertex *)from to:(MMVertex *)to{
    
    MMEdge * edge = [MMEdge new];
    edge->_from = from;
    edge->_to = to;
    edge.weight = @(0);
    return edge;
}

- (BOOL)isEqual:(id)object{
    return [object isKindOfClass:[self class]] &&
    ((MMEdge *)object).from == self.from &&
    ((MMEdge *)object).to == self.to;
}

- (NSUInteger)hash{
    return [self.from hash] + [self.to hash] + self.weight.integerValue;///<这里不是很严谨
}

- (NSString *)description{
    return [NSString stringWithFormat:@"[edge from:%@ to:%@]", self.from,self.to];
}

@end
