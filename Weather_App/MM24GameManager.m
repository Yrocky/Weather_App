//
//  MM24GameManager.m
//  Weather_App
//
//  Created by user1 on 2018/8/4.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MM24GameManager.h"
#include<stdio.h>

@interface MM24GameManager()
@property (nonatomic ,strong) NSArray * mark;
@end

@implementation MM24GameManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mark = @[@"+",@"-",@"*",@"/"];
    }
    return self;
}

- (float) cal:(float)x y:(float)y mark:(NSUInteger)mark{
    switch (mark) {
        case 0:
            return x + y;
        case 1:
            return x - y;
        case 2:
            return x * y;
        case 3:
            return x / y;
        default:
            return 0;
    }
}
- (float) cal_A:(float)a b:(float)b c:(float)c d:(float)d mark1:(NSUInteger)mark1 mark2:(NSUInteger)mark2 mark3:(NSUInteger)mark3{

    float r1,r2,r3;
    r1 = [self cal:a y:b mark:mark1];
    r2 = [self cal:r1 y:c mark:mark2];
    r3 = [self cal:r2 y:d mark:mark3];
    return r3;
}
- (float) cal_B:(float)a b:(float)b c:(float)c d:(float)d mark1:(NSUInteger)mark1 mark2:(NSUInteger)mark2 mark3:(NSUInteger)mark3{
    
    float r1,r2,r3;
    r1 = [self cal:b y:c mark:mark2];
    r2 = [self cal:a y:r1 mark:mark1];
    r3 = [self cal:r2 y:d mark:mark3];
    return r3;
}
- (float) cal_C:(float)a b:(float)b c:(float)c d:(float)d mark1:(NSUInteger)mark1 mark2:(NSUInteger)mark2 mark3:(NSUInteger)mark3{
    
    float r1,r2,r3;
    r1 = [self cal:c y:d mark:mark3];
    r2 = [self cal:b y:r1 mark:mark2];
    r3 = [self cal:a y:r2 mark:mark1];
    return r3;
}
- (float) cal_D:(float)a b:(float)b c:(float)c d:(float)d mark1:(NSUInteger)mark1 mark2:(NSUInteger)mark2 mark3:(NSUInteger)mark3{
    
    float r1,r2,r3;
    r1 = [self cal:b y:c mark:mark2];
    r2 = [self cal:r1 y:d mark:mark3];
    r3 = [self cal:a y:r2 mark:mark1];
    return r3;
}
- (float) cal_E:(float)a b:(float)b c:(float)c d:(float)d mark1:(NSUInteger)mark1 mark2:(NSUInteger)mark2 mark3:(NSUInteger)mark3{
    
    float r1,r2,r3;
    r1 = [self cal:a y:b mark:mark1];
    r2 = [self cal:c y:d mark:mark3];
    r3 = [self cal:r1 y:r2 mark:mark2];
    return r3;
}

- (NSArray *) sumEqual24Results:(NSUInteger)a b:(NSUInteger)b c:(NSUInteger)c d:(NSUInteger)d{
    NSMutableArray * results = [NSMutableArray array];
    int mark1,mark2,mark3;
    float flag=0;
    for(mark1=0;mark1<4;mark1++)
    {
        for(mark2=0;mark2<4;mark2++)
        {
            for(mark3=0;mark3<4;mark3++)
            {
                if([self cal_A:a b:b c:c d:d mark1:mark1 mark2:mark2 mark3:mark3] == 24){
                    NSString * result = [NSString stringWithFormat:@"((%lu %@ %lu) %@ %lu) %@ %lu = 24",(unsigned long)a,self.mark[mark1],b,self.mark[mark2],c,self.mark[mark3],d];
                    [results addObject:result];
                    flag = 1;
                }
                if([self cal_B:a b:b c:c d:d mark1:mark1 mark2:mark2 mark3:mark3] == 24){
                    NSString * result = [NSString stringWithFormat:@"(%lu %@ (%lu %@ %lu)) %@ %lu = 24",(unsigned long)a,self.mark[mark1],b,self.mark[mark2],c,self.mark[mark3],d];
                    [results addObject:result];
                    flag = 1;
                }
                if([self cal_C:a b:b c:c d:d mark1:mark1 mark2:mark2 mark3:mark3] == 24){
                    NSString * result = [NSString stringWithFormat:@"%lu %@ (%lu %@ (%lu %@ %lu)) = 24",(unsigned long)a,self.mark[mark1],b,self.mark[mark2],c,self.mark[mark3],d];
                    [results addObject:result];
                    flag = 1;
                }
                if([self cal_D:a b:b c:c d:d mark1:mark1 mark2:mark2 mark3:mark3] == 24){
                    NSString * result = [NSString stringWithFormat:@"%lu %@ ((%lu %@ %lu) %@ %lu) = 24",(unsigned long)a,self.mark[mark1],b,self.mark[mark2],c,self.mark[mark3],d];
                    [results addObject:result];
                    flag = 1;
                }
                if([self cal_E:a b:b c:c d:d mark1:mark1 mark2:mark2 mark3:mark3] == 24){
                    NSString * result = [NSString stringWithFormat:@"(%lu %@ %lu) %@ (%lu %@ %lu) = 24",(unsigned long)a,self.mark[mark1],b,self.mark[mark2],c,self.mark[mark3],d];
                    [results addObject:result];
                    flag = 1;
                }
            }
        }
    }
    if (flag) {
        return results;
    }else{
        return nil;
    }
}
@end

