//
//  XXXRoute.m
//  Weather_App
//
//  Created by skynet on 2019/12/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXRoute.h"
#import <UIKit/UIKit.h>

@implementation XXXRoute

+ (JLRoutes *) core{
    return [JLRoutes routesForScheme:@"MMLive"];
}

+ (void) registRoutes{
    
    [self registViewControllerPresentRoute];
    [self registViewControllerPushRoute];
}

+ (void) registViewControllerPresentRoute{
    // present
    [XXXRoute.core addRoute:XXXRoutePresentURL handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {

        NSString * className = parameters[@"vc"];
        NSString * title = parameters[@"title"];
        BOOL animated = [parameters[@"animated"] boolValue];
        BOOL needAddNavigation = [parameters[@"addNavi"] boolValue];
        if (![parameters.allKeys containsObject:@"animated"]) {
            animated = YES;
        }
        
        UIViewController * vc = [[NSClassFromString(className) alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.title = title;

            if (needAddNavigation) {
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                vc = nav;
            }
            
            UIViewController * tempVc = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (tempVc.navigationController) {
                [tempVc.navigationController presentViewController:vc animated:animated completion:nil];
                return YES;
            }
        }
        return NO;
    }];
}

+ (void) registViewControllerPushRoute{
    
    // push
    [XXXRoute.core addRoute:XXXRoutePushURL handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        NSString * className = parameters[@"vc"];
        NSString * title = parameters[@"title"];
        BOOL animated = [parameters[@"animated"] boolValue];
        if (![parameters.allKeys containsObject:@"animated"]) {
            animated = YES;
        }
        
        UIViewController * vc = [[NSClassFromString(className) alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        if ([vc isKindOfClass:[UIViewController class]]) {
            vc.title = title;
            
            UIViewController * tempVc = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (tempVc.navigationController) {
                [tempVc.navigationController pushViewController:vc animated:animated];
                return YES;
            } else if ([tempVc isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)tempVc) pushViewController:vc animated:animated];
                return YES;
            }
        }
        return NO;
    }];
}
@end
