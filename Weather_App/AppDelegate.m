//
//  AppDelegate.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "AppDelegate.h"
#import "NSArray+Sugar.h"
#import <AVKit/AVKit.h>
#import "EaseDevice.h"
#import "XXXHTTPProtocol.h"
#import <AppLord/AppLord.h>
#import "XXXHomeModule.h"
#import "XXXRoute.h"
#import "MMAObject.h"

//#import <objc/objc-runtime.h>
@interface AppDelegate ()

@end

void addBlockToArray(NSMutableArray *arr){

    char a = 'a';
    [arr addObject:^{
        printf("a:%c",a);
    }];
    
}
void example_A(){
    NSMutableArray * arr = [NSMutableArray array];

    addBlockToArray(arr);
    void (^block)() = arr[0];
    block();
}
extern CFAbsoluteTime StartTime;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Launched in %f sec", CFAbsoluteTimeGetCurrent() - StartTime);
    });
    
//    NSError *setCategoryErr = nil;
//    NSError *activationErr  = nil;
//    [[AVAudioSession sharedInstance]
//     setCategory: AVAudioSessionCategoryPlayback
//     error: &setCategoryErr];
//    [[AVAudioSession sharedInstance]
//     setActive: YES
//     error: &activationErr];
    
    [UINavigationBar appearance].backItem.leftItemsSupplementBackButton = YES;
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
    
    [self addRoutes];
    
    example_A();
    
    MMAObject * a = [MMAObject new];
    bool iseq = [a isEqual:a];
    
    [[ALContext sharedContext] loadModules];
//    [[ALContext sharedContext] registerModule:[XXXHomeModule class]];
//    [[ALContext sharedContext] registerService:@protocol(XXXHomeService)
//                                      withImpl:XXXHomeServiceImpl.class];
//    [[ALContext sharedContext] setObject:launchOptions forKey:@"ALLaunchOptionsKey"];

    [XXXHTTPProtocol start];
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
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"docPath:%@",docPath);
    
    NSLog(@"is Big endian :%d",isBigEndian());
    return YES;
}

BOOL isBigEndian(){
    
    int a = 0x1234;
    
    // 通过将int强制类型转换成char单字节，通过判断其实存储位置
    
    char b = *(char *)&a;
    
    if (b == 0x12) {
        
        return YES;
        
    }

return NO;

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
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
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"AppDelegate warning");
}

- (void) addRoutes{

    [XXXRoute registRoutes];
    
    [JLRoutes.globalRoutes addRoute:@"push/:viewControllerName" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        NSLog(@"parameters:%@",parameters);
        return YES;
    }];
    
//    [[JLRoutes routesForScheme:@"MMLive"] addRoute:@"push/:viewControllerName/second" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
//        NSLog(@"MMLive push parameters:%@",parameters);
//        return YES;
//    }];
//    
//    [[JLRoutes routesForScheme:@"MMLive"] addRoute:@"present/(:vcName)(c/d)" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
//        NSLog(@"MMLive present parameters:%@",parameters);
//        return YES;
//    }];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // bbanlive://jumpRoom?uid=122&nick=sfs
    // bbanlive://jumpRoom?json='uid=12,nick=dsfsd'
    return YES;
}
@end
