//
//  UIButton+MMCustom.h
//  Weather_App
//
//  Created by user1 on 2018/9/14.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCustomButtonMaker : NSObject

@end

@interface UIButton (MMCustom)

- (void) mm_makeCustomImage:(void(^)(MMCustomButtonMaker *maker))block;
- (void) mm_makeCustomTitle:(void(^)(MMCustomButtonMaker *maker))block;
@end
