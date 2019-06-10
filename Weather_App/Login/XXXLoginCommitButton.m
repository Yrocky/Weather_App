//
//  XXXLoginCommitButton.m
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXLoginCommitButton.h"

@implementation XXXLoginCommitButton

- (void)dealloc{
    NSLog(@"XXXLoginCommitButton dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(0.97, 0.97);
        gl.colors = [self normalColors];
        _gradientLayer = gl;
        [self.layer addSublayer:_gradientLayer];
        self.layer.masksToBounds = YES;
        
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height*0.5;
    _gradientLayer.frame = self.bounds;
}

- (void) setupTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void) showGradient:(BOOL)show{
    _gradientLayer.hidden = !show;
}
- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        _gradientLayer.colors = [self normalColors];
    } else {
        _gradientLayer.colors = [self disenableColors];
    }
}

- (NSArray *) normalColors{
    return @[(__bridge id)[UIColor colorWithRed:254/255.0 green:171/255.0 blue:83/255.0 alpha:1.0].CGColor,
             (__bridge id)[UIColor colorWithRed:250/255.0 green:106/255.0 blue:135/255.0 alpha:1.0].CGColor];
}

- (NSArray *) disenableColors{
    return @[(__bridge id)[UIColor colorWithRed:255/255.0 green:201/255.0 blue:201/255.0 alpha:1.0].CGColor,
             (__bridge id)[UIColor colorWithRed:255/255.0 green:179/255.0 blue:194/255.0 alpha:1.0].CGColor];
}
@end
