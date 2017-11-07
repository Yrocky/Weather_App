//
//  AppDelegate.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "AppDelegate.h"
#import "NSArray+Sugar.h"

//#import <objc/objc-runtime.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UINavigationBar appearance].backItem.leftItemsSupplementBackButton = YES;
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
    
//    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
//    if ([overlayClass respondsToSelector:NSSelectorFromString(@"prepareDebuggingOverlay")]) {
//        [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
//    }
//    NSArray * ar = [NSArray array];
//    [ar countByEnumeratingWithState:nil objects:nil count:2];
//    NSRange range;
//    [ar isKindOfClass:objc_getClass("dsfds")];
    
//    NSString * s = @"";
//    [s substringToIndex:range.location];
    
//    NSArray * array = @[@"12",@"34",@"45",@"56"];
//    NSLog(@"have %d",array.have(@"12"));
//    NSLog(@"sample %@",array.sample);
//    
//    [array each:^(id obj) {
//        NSLog(@"obj:%@",obj);
//    }];
//    
//    [array eachWithIndex:^(id obj, NSInteger index) {
//        NSLog(@"obj:%@ at index:%ld",obj,(long)index);
//    }];
//    
//    NSLog(@"map:%@",[array map:^id(id obj) {
//        return [NSString stringWithFormat:@"<map-%@>",obj];
//    }]);
//    
//    NSLog(@"select:%@",[array select:^BOOL(id obj) {
//        
//        return [obj isEqual: @"12"];
//    }]);
//    
//    NSArray * other = @[@"12",@"56",@"67",@"78"];
//    
//    NSLog(@"union:%@",[array union:other]);// 12 34 45 56 67 78
//    NSLog(@"intersect:%@",[array intersect:other]);// 12 56
//    NSLog(@"difference:%@",[array difference:other]);// 34 45 67 78
//    NSLog(@"array-subtract-other:%@",[array subtract:other]);// 34 45
//    NSLog(@"other-subtract-array:%@",[other subtract:array]);// 67 78
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
