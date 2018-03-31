//
//  HLLStickIndicator.m
//  Weather_App
//
//  Created by user1 on 2017/10/26.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLStickIndicator.h"
#import "Masonry.h"

@interface HLLDirectionView : UIView<HLLIndicatorProtocol>{
    
    CAShapeLayer * _directionLayer;
    HLLStickIndicatorDirection _direction;
}
- (void) configDirenction:(HLLStickIndicatorDirection)direction;
@end

@implementation HLLDirectionView

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _directionLayer = (CAShapeLayer *)self.layer;
        _directionLayer.fillColor = [UIColor clearColor].CGColor;
        _directionLayer.strokeColor = [UIColor colorWithRed:0.99 green:0.21 blue:0.11 alpha:1.00].CGColor;
        _directionLayer.lineWidth = 2/[UIScreen mainScreen].scale;
        _directionLayer.strokeEnd = 1;
        _directionLayer.lineCap = kCALineCapRound;
        _directionLayer.lineJoin = kCALineJoinRound;
        _directionLayer.opacity = 0;
        _directionLayer.path = [self createPathWithHeight:0];
    }
    return self;
}

- (void) configDirenction:(HLLStickIndicatorDirection)direction{
    _direction = direction;
}

- (CGPathRef) createPathWithHeight:(CGFloat)height{
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint   = CGPointZero;
    CGPoint movePoint = CGPointZero;
    
    if (_direction == HLLStickIndicatorTop) {
        endPoint = (CGPoint){
            selfWidth,0
        };
        movePoint = (CGPoint){
            selfWidth/2,height
        };
    }
    else if (_direction == HLLStickIndicatorLeft){
        startPoint = (CGPoint){
            selfWidth,0
        };
        endPoint = (CGPoint){
            selfWidth,selfHeight
        };
        movePoint = (CGPoint){
            selfWidth - height,selfHeight/2
        };
    }
    else if (_direction == HLLStickIndicatorRight){
        endPoint = (CGPoint){
            0,selfHeight
        };
        movePoint = (CGPoint){
            height,selfHeight/2
        };
    }
    else if (_direction == HLLStickIndicatorBottom){
        startPoint = (CGPoint){
            0,selfHeight
        };
        endPoint = (CGPoint){
            selfWidth,selfHeight
        };
        movePoint = (CGPoint){
            selfWidth/2,height
        };
    }
    
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:movePoint];
    [bezierPath addLineToPoint:endPoint];
    
    return bezierPath.CGPath;
}

- (void)update:(CGFloat)percent{
//    NSLog(@"percent :  %f",percent);
    if (percent <= 0) {
        
        _directionLayer.path      = [self createPathWithHeight:0];
        _directionLayer.opacity   = 0;
        
    } else if (percent > 0 && percent <= 0.5f) { // [0, 0.5]
        
        _directionLayer.path      = [self createPathWithHeight:0];
        _directionLayer.opacity   = percent * 2.f;
        
    } else if (percent <= 1.f) { // (0.5, 1]
        
        CGFloat currentPercent = percent - 0.5f;
        CGFloat height = (_direction == HLLStickIndicatorLeft || _direction == HLLStickIndicatorRight)?self.frame.size.width : self.frame.size.height;
        _directionLayer.path      = [self createPathWithHeight:currentPercent * height * 2];
        _directionLayer.opacity   = 1.f;
        
    } else { // (1, +无穷大)
        CGFloat height = (_direction == HLLStickIndicatorLeft || _direction == HLLStickIndicatorRight)?self.frame.size.width : self.frame.size.height;
        _directionLayer.path      = [self createPathWithHeight:height];
        _directionLayer.opacity   = 1.f;
    }
}

@end

@implementation HLLStickIndicatorView{
    
    UILabel * _indicatorInfoLabel;
    HLLDirectionView * _indicatorDirectionView;
    HLLStickIndicatorDirection _direction;
}

- (instancetype) initWithDirection:(HLLStickIndicatorDirection)direction{
    
    return [self initWithDirection:direction frame:CGRectZero];
}

- (instancetype) initWithDirection:(HLLStickIndicatorDirection)direction frame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
        _direction = direction;
        
        _indicatorInfoLabel = [[UILabel alloc] init];
        _indicatorInfoLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorInfoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _indicatorInfoLabel.textColor = [UIColor colorWithRed:0.46 green:0.48 blue:0.53 alpha:1.00];
        _indicatorInfoLabel.text = @"display-text";
        _indicatorInfoLabel.numberOfLines = 0;
        [self addSubview:_indicatorInfoLabel];
        
        _indicatorDirectionView = [[HLLDirectionView alloc] init];
        [_indicatorDirectionView configDirenction:direction];
        [self addSubview:_indicatorDirectionView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    CGFloat margin = 5;
    
    if (_direction == HLLStickIndicatorTop) {
        
        [_indicatorDirectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 7));
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-margin);
        }];
        [_indicatorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(20);
            make.bottom.mas_equalTo(_indicatorDirectionView.mas_top).mas_offset(-margin);
            make.centerX.mas_equalTo(_indicatorDirectionView);
        }];
    }
    else if (_direction == HLLStickIndicatorLeft){
        
        _indicatorInfoLabel.textAlignment = NSTextAlignmentRight;
        [_indicatorDirectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-margin);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(7, 20));
        }];
        
        [_indicatorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_indicatorDirectionView.mas_top).mas_offset(-margin);
            make.right.mas_equalTo(_indicatorDirectionView);
            make.left.mas_equalTo(0);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
    }
    else if (_direction == HLLStickIndicatorRight){
        
        _indicatorInfoLabel.textAlignment = NSTextAlignmentLeft;
        
        [_indicatorDirectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(7, 20));
        }];
        
        [_indicatorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_indicatorDirectionView.mas_top).mas_offset(-margin);
            make.left.mas_equalTo(_indicatorDirectionView);
            make.right.mas_equalTo(0);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
    }
    else if (_direction == HLLStickIndicatorBottom){
        
        [_indicatorDirectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(margin);
            make.size.mas_equalTo(CGSizeMake(30, 7));
            make.centerX.mas_equalTo(self);
        }];
        
        [_indicatorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_indicatorDirectionView.mas_bottom).mas_offset(margin);
            make.centerX.mas_equalTo(_indicatorDirectionView);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
    }
}

- (void) configIndicatorInfoAttributesString:(NSAttributedString *)indicatorInfo{
    _indicatorInfoLabel.attributedText = indicatorInfo;
}

- (void) configIndicatorInfo:(NSString *)indicatorInfo{
    _indicatorInfoLabel.text = indicatorInfo;
}

- (void)update:(CGFloat)percent{
    
    _indicatorInfoLabel.alpha = percent;
    [_indicatorDirectionView update:percent];
}

@end
