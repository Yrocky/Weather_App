//
//  HLLAlert.h
//  One
//
//  Created by Rocky Young on 2017/2/21.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HLLAlertActionSheetProtocol <NSObject>

@optional

#pragma mark - config

- (id<HLLAlertActionSheetProtocol>) title:(NSString *)titile;
- (id<HLLAlertActionSheetProtocol>) message:(NSString *)message;

/** Default handle button type is `UIAlertActionStyleDefault`. */
- (id<HLLAlertActionSheetProtocol>) buttons:(NSArray *)buttons;
/** Explain some as above .这个采用多字符串的方式传递buttons，以应对button-fetch不对应的问题*/
- (id<HLLAlertActionSheetProtocol>) buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** Config special button type at `index`. */
- (id<HLLAlertActionSheetProtocol>) style:(UIAlertActionStyle)style index:(NSInteger)index;

- (id<HLLAlertActionSheetProtocol>) addButton:(void (^)(NSInteger index))click title:(NSString *)title style:(UIAlertActionStyle)style;
- (id<HLLAlertActionSheetProtocol>) addCancelButton:(NSString *)title;

#pragma mark - hide

- (id<HLLAlertActionSheetProtocol>) hide:(void(^)())hide;

@required

#pragma mark - fetch

- (id<HLLAlertActionSheetProtocol>) fetchClick:(void (^)(NSInteger index))click;

#pragma mark - show

- (id<HLLAlertActionSheetProtocol>) show;
- (id<HLLAlertActionSheetProtocol>) showIn:(__kindof UIViewController *)vc;

#pragma mark - dismiss

- (void) dismiss;
- (void) dismiss:(void (^ __nullable)(void))completion;
@end

/**
 * `Alert` 是不允许除了添加的handle按钮之外的点击消失
 * `ActionSheet` 却允许点击空白处消失
 */
/**
     一种情况，如果传入的buttons中有一个为nil
     虽然可以使用runtime将为nil的不加入数组，但是其对应的fetchHandle还是存在的
     就导致了fetchHandle响应了不正确的button
     ex:
         NSString * one = nil;
         NSString * two = @"two";
         
         buttons:@[@"Cancel",one,two]
         fetchClick:(NSIntsger index){
             if (index = 1){ ... }// 原意是这一个分支对应的是buttons中的one，但是这个时候由于其为nil，所以其实对应的是two
             if (index = 2){ ... }// 这个分支一直不会走
         }
     这样的情况总是出乎意料的，系统方面(UIAlert/ActioinSheetView)的做法是传递一个多字符串的东西，
     然后再里面读取有多少个String，直到为 nil 的时候停止，
     这样就保证了nil前面的button对应的fetch都会正确执行，
     而为nil的button以及其后的button对应的fetch都不会执行
     
     那么，这里就需要将传递数组这种方式修改为和系统一样的传递方式
     多字符串形式`(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION`
     https://stackoverflow.com/questions/14199987/access-individual-string-parameters-uialertview-otherbuttontitles
     
 */

#ifndef HLLAlertUtil
#define HLLAlertUtil [HLLAlertActionSheet alert]
#endif

#ifndef HLLActionSheetUtil
#define HLLActionSheetUtil [HLLAlertActionSheet actionSheet]
#endif

/**
 *  对系统的UIAlertController的简单封装
 */
@interface HLLAlertActionSheet : NSObject

#pragma mark - config

+ (id<HLLAlertActionSheetProtocol>) alert;

+ (id<HLLAlertActionSheetProtocol>) actionSheet;

+ (__kindof UIViewController *)getPresentedViewController;
@end

