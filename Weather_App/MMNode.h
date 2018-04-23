//
//  MMNode.h
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMNode<T> : NSObject

@property (nonatomic ,strong) MMNode * pre;
@property (nonatomic ,strong) MMNode * next;
@property (nonatomic ,strong) T value;

+ (instancetype) nodeWithValue:(T)value;
@end
