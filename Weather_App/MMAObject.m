//
//  MMAObject.m
//  Weather_App
//
//  Created by user1 on 2018/7/27.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMAObject.h"
#import "MMBObject.h"

@implementation MMAObject
- (void) doSomthing:(int)foo{
    NSLog(@"A doSomthing %d",foo);
}
@end

@implementation MMOtherObject
- (id) getAObject{
    return [MMAObject new];
}
- (id) getBObject{
    return [MMBObject new];
}
@end
