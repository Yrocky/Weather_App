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
//
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

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
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
        NSLog(@"compera:%d",[other compare:date]);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

