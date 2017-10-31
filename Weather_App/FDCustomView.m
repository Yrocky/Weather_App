//
//  FDCustomView.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDCustomView.h"
#import "UIColor+Common.h"
#import "Masonry.h"

NSString * const FDDidShowAlertViewNotification = @"FDDidShowAlertViewNotification";
NSString * const FDDidDismissAlertViewNotification = @"FDDidDismissAlertViewNotification";

@implementation FDCustomView

- (void)dealloc{
    
    NSLog(@"%@ did dealloc",self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FDDidShowAlertViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FDDidDismissAlertViewNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _config];
    }
    return self;
}

- (void) _config{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowAlertViewGrayThemeAction) name:FDDidShowAlertViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDismissAlertViewGreenThemeAction) name:FDDidDismissAlertViewNotification object:nil];
}

- (void) onShowAlertViewGrayThemeAction{
}

- (void) onDismissAlertViewGreenThemeAction{
}

- (UIColor *) themeColor{
    return [UIColor colorWithHexString:@"1EBE99"];
}

- (UIColor *) grayColor{
    return [UIColor colorWithHexString:@"6F7376"];
}

@end
