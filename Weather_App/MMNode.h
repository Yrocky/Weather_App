//
//  MMNode.h
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMNode<T> : NSObject

@property (nonatomic ,strong) MMNode<T> * pre;
@property (nonatomic ,weak) MMNode<T> * next;
@property (nonatomic ,assign) NSUInteger index;

@property (nonatomic ,strong ,readonly) T value;

+ (instancetype) nodeWithValue:(T)value;
- (void) updateValue:(T)newValue;
@end
