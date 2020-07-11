//
//  EaseDevice.m
//  Weather_App
//
//  Created by meme-rocky on 2019/1/10.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "EaseDevice.h"

@implementation EaseDevice

@end

@implementation EaseDevice (Screen)
+ (CGSize)screenSize{
    return UIScreen.mainScreen.bounds.size;
}
+ (CGFloat)screenWidth{
    return self.screenSize.width;
}
+ (CGFloat)screenHeight{
    return self.screenSize.height;
}

+ (CGFloat)statusBarHeight{
    return self.isNotchPhone ? 44.0f : 20.0f;
}
+ (CGFloat)navigationBarHeight{
    return self.isNotchPhone ? 84.0f : 64.0f;
}
+ (CGFloat)tabBarHeight{
    return self.isNotchPhone ? 83.0f : 49.0f;
}
@end

@implementation EaseDevice (Model)

+ (BOOL)isIPhone678{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (BOOL)isIPhone678Plus{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (BOOL)isNotchPhone{
    return self.isIPhoneX || self.isIPhoneXR || self.isIPhoneXS || self.isIPhoneXSMax;
}
+ (BOOL)isIPhoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (BOOL)isIPhoneXR{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (BOOL)isIPhoneXS{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (BOOL)isIPhoneXSMax{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ?
    CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO;
}
@end

@implementation EaseDevice (System)

+ (NSString *)name{
    return UIDevice.currentDevice.systemName;
}
+ (NSString *)version{
    return UIDevice.currentDevice.systemVersion;
}
+ (NSString *)format{
    return [NSString stringWithFormat:@"%@ %@",self.name,self.version];
}

+ (BOOL) versionEqualTo:(NSString *)version{
    return [self.version compare:version options:NSNumericSearch] == NSOrderedSame;
}

+ (BOOL) versionGreaterThen:(NSString *)version{
    return [self.version compare:version options:NSNumericSearch] == NSOrderedDescending;
}
+ (BOOL) versionGreaterThenOrEqualTo:(NSString *)version{
    return [self.version compare:version options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL) versionLessThen:(NSString *)version{
    return [self.version compare:version options:NSNumericSearch] == NSOrderedAscending;
}
+ (BOOL) versionLessThenOrEqualTo:(NSString *)version{
    return [self.version compare:version options:NSNumericSearch] != NSOrderedDescending;
}

@end
