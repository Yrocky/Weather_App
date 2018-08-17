//
//  GiftShapeEffectView.h
//  test1
//
//  Created by pengbo.sui on 16/1/18.
//  Copyright © 2016年 pengbo.sui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EFFECT_TYPE_NONE    = 0,
    EFFECT_TYPE_50      = 1,
    EFFECT_TYPE_100     = 2,
    EFFECT_TYPE_300     = 3,
    EFFECT_TYPE_520     = 4,
    EFFECT_TYPE_1000    = 5,
    EFFECT_TYPE_1314    = 6,
    EFFECT_TYPE_3344    = 7,
    EFFECT_TYPE_9999    = 8,
} EFFECT_TYPE;

@interface GiftShapeEffectView : UIView

-(void)start:(EFFECT_TYPE)type image:(UIImage *)image;

@end
