//
//  main.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HLLAttributedBuilder.h"
#import "NSArray+Sugar.h"
#import "NSNumber+Sugar.h"

//static int static_golbal_val = 10;


//void am(NSMutableArray * a){
////    char b = 'b';
//    [a addObject:^{
//        printf("234567C\n");
//    }];
//}
//
//void e(){
//    NSMutableArray * a = [[NSMutableArray alloc] init];
//    am(a);
//    void (^block)() = a[0];
//    block();
//}

NSArray * getBlockFromArray(){
    
    NSArray * arr = [NSArray arrayWithObjects:^{NSLog(@"blk-1");}, ^{NSLog(@"blk-2");},nil];
    NSLog(@"blk:%@",arr[0]);
    return arr;
}

void (^global_blk)(void) = ^{ NSLog(@"global block"); };

CFAbsoluteTime StartTime;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        StartTime = CFAbsoluteTimeGetCurrent();
        
        typedef void (^BlockType)();
        NSLog(@"load main-func");
        BlockType blk = getBlockFromArray()[0];
        
        blk();
        
        NSLog(@"global block:%@",global_blk);
        
        NSDate * date = [NSDate new]; // to
        
        NSDate * other = [NSDate dateWithTimeIntervalSince1970:1000];// from
        
        NSInteger index = [[[NSUserDefaults standardUserDefaults] valueForKey:@"key-asfsd"] integerValue];
        
        NSDictionary * d = @{@"key":@"sfsdf"};
        d = nil;
        NSLog(@"%d",[d[@"key"] boolValue]);
        NSLog(@"value:%@",[d objectForKey:@"key1"]);
        
//        e();
        
//        NSData* jsonData = [d dataUsingEncoding:NSUTF8StringEncoding];
//        //
//        NSError * error;
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSArray * ar = @[date];
        NSMutableArray * muarr = [ar mutableCopy];
        //
//        NSLog(@"compera:%d",[other compare:date]);
        
        
        NSArray * a =  @[@2,@3,@4,@5,@6,@7];
        
        int i = 0;
        for (NSUInteger index = 0 ; index < 30 ; index ++) {
            
//            NSLog(@"%@",[a subarrayWithRange:NSMakeRange(i * 2, 2)]);
            i ++;
            
            if (i >= a.count/2){
                i = 0;
            }
        }
        NSLog(@"...");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

