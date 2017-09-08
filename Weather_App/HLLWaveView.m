//
//  HLLWaveView.m
//  Weather_App
//
//  Created by user1 on 2017/8/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "HLLWaveView.h"

@interface HLLWaveView (){
    CGFloat _height;
    CGFloat _width;
}
/**
 *  波纹频率
 */
@property (nonatomic ,assign) CGFloat waveRate;
/**
 *  波纹高度
 */
@property (nonatomic ,assign) CGFloat waterWaveHeight;
/**
 *  定时器
 */
@property (nonatomic, strong) CADisplayLink * waveDisplaylink;
/**
 *  波纹图层
 */
@property (nonatomic, strong) CAShapeLayer * waveLayer;

@end
@implementation HLLWaveView

#pragma mark - API M

+ (instancetype)waveView{

    return [[self alloc] initWaveView];
}

- (instancetype) initWaveView{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        //振幅
        self.waveAmplitude = 10.0f;
        //周期
        self.waveCycle = 300.0f;
        //速度
        self.waveSpeed = 0.1f;
        //颜色
        self.waveColor = [UIColor redColor];
        
        //
        _waveLayer = [CAShapeLayer layer];
        _waveLayer.fillColor = self.waveColor.CGColor;
        [self.layer addSublayer:_waveLayer];
        
    }
    return self;
}

- (void)start{

    [self stop];
    
    // 启动定时调用
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandleForCurrentWave)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop{

    [_waveDisplaylink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _waterWaveHeight = _height;
}

#pragma mark - Timer M

- (void)displayLinkHandleForCurrentWave{
    
    // 波浪位移
    self.offsetX += self.waveSpeed;
    if (self.waterWaveHeight > _height - self.waveAmplitude) {
        self.waterWaveHeight = _height - self.waveAmplitude;
    }
    [self drawCurrentWaveLayerPath];
}

- (void)drawCurrentWaveLayerPath{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat currentWavePointY = _height - self.waterWaveHeight;
    CGPathMoveToPoint(path, nil, 0, currentWavePointY);
    for (float x = 0.0f; x <= _width ; x++) {
        // 正弦波浪公式
        CGFloat y = self.waveAmplitude * sin(self.waveRate * x + self.offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, _width, _height);
    CGPathAddLineToPoint(path, nil, 0, _height);
    CGPathCloseSubpath(path);
    self.waveLayer.path = path;
    CGPathRelease(path);
}

#pragma mark - Seter M

- (void)setWaveCycle:(CGFloat)waveCycle{
    
    _waveCycle = waveCycle;
    _waveRate = 2*M_PI/_waveCycle;
}

- (void)setWaveColor:(UIColor *)waveColor{

    _waveColor = waveColor;
    _waveLayer.fillColor = self.waveColor.CGColor;
}

@end
