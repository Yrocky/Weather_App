//
//  MMOBJ.m
//  Weather_App
//
//  Created by user1 on 2018/3/20.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMOBJ.h"


void am(NSMutableArray * a){
        char b = 'b';
    [a addObject:^{
        printf("234567%c\n",b);
    }];
}

void e(){
    NSMutableArray * a = [[NSMutableArray alloc] init];
    am(a);
    void (^block)() = a[0];
    block();
}

@implementation MMOBJ

- (void)dealloc
{
    NSLog(@"obj dealloc");
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        e();
    }
    return self;
}
@end
