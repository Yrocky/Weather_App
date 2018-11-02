//
//  MMGradientView.m
//  memezhibo
//
//  Created by user1 on 2017/8/28.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import "MMGradientView.h"

@implementation MMGradientView

+ (instancetype) gradientView{

    return [[MMGradientView alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNeedParams];
    }
    return self;
}

-(void)setNeedParams{
    _gradientLayer = (CAGradientLayer *)self.layer;
    self.startPoint = CGPointMake(0, 0);
    self.endPoint = CGPointMake(1, 0);
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    _isHighlighted = highlighted;
    
    if (animated) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"colors"];
        animation.duration = 0.25f;
        animation.fromValue = highlighted ?
        [self _transformColorsForLayer:self.colors] :
        [self _transformColorsForLayer:self.highlightColors];
        animation.toValue = highlighted ?
        [self _transformColorsForLayer:self.highlightColors] :
        [self _transformColorsForLayer:self.colors];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_gradientLayer addAnimation:animation forKey:@"gradient-animation"];
    }else{
        _gradientLayer.colors = highlighted ?
        [self _transformColorsForLayer:self.highlightColors] :
        [self _transformColorsForLayer:self.colors];
    }
}

- (NSArray *) _transformColorsForLayer:(NSArray <UIColor *>*)colors{
    // 将color转换成CGColor
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *tmp in colors) {
        id cgColor = (__bridge id)tmp.CGColor;
        [cgColors addObject:cgColor];
    }
    
    return cgColors.copy;
}

+ (Class)layerClass{
    return [CAGradientLayer class];
}

- (void)setColors:(NSArray <UIColor *>*)colors {
    _colors = colors;
    // 设置Colors
    _gradientLayer.colors = [self _transformColorsForLayer:colors];
}

- (void)setLocations:(NSArray <NSNumber *>*)locations {
    _locations               = locations;
    _gradientLayer.locations = _locations;
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint               = startPoint;
    _gradientLayer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint               = endPoint;
    _gradientLayer.endPoint = endPoint;
}

@end

@implementation MMBlurGradientView

+ (instancetype)blurGradientView:(UIBlurEffectStyle)style{
    return [[self alloc] initWithBlurEffectStyle:style];
}

- (instancetype) initWithBlurEffectStyle:(UIBlurEffectStyle)style{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // blur
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        _blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _blurEffectView.frame = self.bounds;
}

@end
