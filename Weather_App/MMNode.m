//
//  MMNode.m
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMNode.h"

@implementation MMNode

+ (instancetype) nodeWithValue:(id)value{
    
    MMNode * node = [[MMNode alloc] init];
    node.value = value;
    return node;
}

@end
