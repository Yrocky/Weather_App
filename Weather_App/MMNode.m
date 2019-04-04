//
//  MMNode.m
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMNode.h"

@interface MMNode ()
@property (nonatomic ,strong ,readwrite) id value;
@end
@implementation MMNode

- (void)dealloc{
    NSLog(@"node %@ dealloc",self);
}

+ (instancetype) nodeWithValue:(id)value{
    
    MMNode * node = [[MMNode alloc] init];
    node.value = value;
    return node;
}

- (void) updateValue:(id)newValue{
    self.value = newValue;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"node %@", self.value];
}
- (NSString *)debugDescription{
    return [self description];
}
@end
