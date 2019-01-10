//
//  EaseDevice.h
//  Weather_App
//
//  Created by meme-rocky on 2019/1/10.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///对开发中常用的数据的静态封装，等效于宏定义
@interface EaseDevice : NSObject

@end

///@屏幕
@interface EaseDevice (Screen)

@property (class ,readonly) CGSize screenSize;
@property (class ,readonly) CGFloat screenWidth;
@property (class ,readonly) CGFloat screenHeight;

@property (class ,readonly) CGFloat statusBarHeight;

@property (class ,readonly) CGFloat navigationBarHeight;

@property (class ,readonly) CGFloat tabBarHeight;

@end

///@机型
@interface EaseDevice (Model)

///是否是6、7、8机型
@property (class ,readonly) BOOL isIPhone678;
@property (class ,readonly) BOOL isIPhone678Plus;

///是否是异形屏幕
@property (class ,readonly) BOOL isNotchPhone;

@property (class ,readonly) BOOL isIPhoneX;
@property (class ,readonly) BOOL isIPhoneXR;
@property (class ,readonly) BOOL isIPhoneXS;
@property (class ,readonly) BOOL isIPhoneXSMax;

@end

@interface EaseDevice (System)

@property (class ,readonly) NSString * name;///<iOS
@property (class ,readonly) NSString * version;///<4.1.0
@property (class ,readonly) NSString * format;///<iOS 4.1.0

+ (BOOL) versionEqualTo:(NSString *)version;

+ (BOOL) versionGreaterThen:(NSString *)version;
+ (BOOL) versionGreaterThenOrEqualTo:(NSString *)version;

+ (BOOL) versionLessThen:(NSString *)version;
+ (BOOL) versionLessThenOrEqualTo:(NSString *)version;
@end
NS_ASSUME_NONNULL_END
