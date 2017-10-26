//
//  HLLStickIndicator.h
//  Weather_App
//
//  Created by user1 on 2017/10/26.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLLIndicatorProtocol <NSObject>

- (void) update:(CGFloat)percent;
@end

typedef NS_ENUM(NSUInteger ,HLLStickIndicatorDirection) {
    HLLStickIndicatorTop = 0,
    HLLStickIndicatorLeft,
    HLLStickIndicatorRight,
    HLLStickIndicatorBottom
};

@interface HLLDirectionView : UIView<HLLIndicatorProtocol>{
    
    CAShapeLayer * _directionLayer;
    HLLStickIndicatorDirection _direction;
}
- (void) configDirenction:(HLLStickIndicatorDirection)direction;
@end

@interface HLLStickIndicatorView : UIView<HLLIndicatorProtocol>{
    
    UILabel * _indicatorInfoLabel;
    HLLDirectionView * _indicatorDirectionView;
    HLLStickIndicatorDirection _direction;
}

- (instancetype) initWithDirection:(HLLStickIndicatorDirection)direction frame:(CGRect)frame;
- (void) configIndicatorInfo:(NSString *)indicatorInfo;
- (void) configIndicatorInfoAttributesString:(NSAttributedString *)indicatorInfo;
@end
