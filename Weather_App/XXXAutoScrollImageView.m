//
//  XXXAutoScrollImageView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXAutoScrollImageView.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "UIImageView+AFNetworking.h"

static NSString * XXXVerticalAnimationKey = @"Vertical";
static NSString * XXXHorizontalAnimationKey = @"Horizontal";
static NSString * XXXLeftToRightDiagonalAnimationKey = @"LeftToRightDiagonal";
static NSString * XXXRightToLeftDiagonalAnimationKey = @"RightToLeftDiagonal";

static inline NSValue* XXXPointValue(CGPoint point) {
    return [NSValue valueWithCGPoint:point];
}

static inline NSValue* XXXPointValueMake(CGFloat x, CGFloat y) {
    return XXXPointValue((CGPoint){ x,y });
}

static inline NSValue* XXXPointValueOffset(CGPoint point, CGFloat x, CGFloat y) {
    return XXXPointValueMake(point.x + x, point.y + y);
}

@interface XXXAutoScrollImageView ()<CAAnimationDelegate>{
    BOOL _enterBackground;
}
@property (nonatomic ,strong) UIImageView * internalImageView;

@property (nonatomic ,assign) CGFloat margin_v;///<垂直方向上需要移动的距离
@property (nonatomic ,assign) CGFloat margin_h;///<水平方向上需要移动的距离
@end

@implementation XXXAutoScrollImageView

- (void)dealloc{
    [self pause];
    [self.internalImageView removeFromSuperview];
    self.internalImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"XXXAutoScrollImageView dealloc");
}

- (instancetype) initWithDirection:(XXXAutoScrollDirection)direction{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.duration = 10.0;
        _direction = direction;
        
        self.clipsToBounds = YES;
        
        self.internalImageView = [UIImageView new];
        self.internalImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.internalImageView.backgroundColor = [UIColor randomColor];
        [self addSubview:self.internalImageView];
        
        [self.internalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        ///<add noti
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void) setupImage:(NSString *)imageName{
    self.internalImageView.image = [UIImage imageNamed:imageName];
    [self start];
}

- (void) setupImage:(NSString *)imageUrl placeholder:(NSString *)placeholder{
    
    __weak typeof(self) weakSelf = self;
    [self.internalImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]]
                                  placeholderImage:[UIImage imageNamed:placeholder]
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               weakSelf.internalImageView.image = image;
                                               [weakSelf start];
                                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               [weakSelf start];
                                           }];
}

- (void)start{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
        
        [self setupMarginWithImage:self.internalImageView.image];
        
        [self onAnimation];
    });
}

- (void)pause{
    [self.internalImageView.layer removeAllAnimations];
}

- (void) setupMarginWithImage:(UIImage *)image{
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    ///<垂直方向上的位移距离
    self.margin_v = (imageHeight - height) * 0.5;
    ///<水平方向上的位移距离
    self.margin_h = (imageWidth - width) * 0.5;
    NSLog(@"[autoScrollView] margin_h:%f, margin_v:%f",self.margin_h,self.margin_v);
}

#pragma mark - action

- (void) onAnimation{
    
    if (self.direction == XXXAutoScrollDirectionVertical) {
        [self onVerticalAnimation];
    } else if (self.direction == XXXAutoScrollDirectionHorizontal) {
        [self onHorizontalAnimation];
    } else if (self.direction == XXXAutoScrollDirectionLeftToRightDiagonal) {
        [self onLeftToRightDiagonalAnimation];
    } else if (self.direction == XXXAutoScrollDirectionRightToLeftDiagonal) {
        [self onRightToLeftDiagonalAnimation];
    }
}

#pragma mark - notification

- (void) onEnterForeground:(NSNotification *)noti{
    if (_enterBackground) {
        [self onAnimation];
        _enterBackground = NO;
    }
}

- (void) onEnterBackground:(NSNotification *)noti{
    _enterBackground = YES;
    [self pause];
}

#pragma mark - Animation

- (void) onVerticalAnimation{
    
    [self onAnimation:^(CAKeyframeAnimation *animation, CGPoint position) {
        animation.values = @[XXXPointValue(position),
                             XXXPointValueOffset(position, 0, self.margin_v),
                             XXXPointValue(position),
                             XXXPointValueOffset(position, 0, -self.margin_v),
                             XXXPointValue(position)];
    }];
}

- (void) onHorizontalAnimation{
    [self onAnimation:^(CAKeyframeAnimation *animation, CGPoint position) {
        animation.values = @[XXXPointValue(position),
                             XXXPointValueOffset(position, self.margin_h, 0),
                             XXXPointValue(position),
                             XXXPointValueOffset(position, -self.margin_h, 0),
                             XXXPointValue(position)];
    }];
}

- (void) onLeftToRightDiagonalAnimation{
    [self onAnimation:^(CAKeyframeAnimation *animation, CGPoint position) {
        animation.values = @[XXXPointValue(position),
                             XXXPointValueOffset(position, self.margin_h, self.margin_v),
                             XXXPointValue(position),
                             XXXPointValueOffset(position, -self.margin_h, -self.margin_v),
                             XXXPointValue(position)];
    }];
}

- (void) onRightToLeftDiagonalAnimation{
    [self onAnimation:^(CAKeyframeAnimation *animation, CGPoint position) {
        animation.values = @[XXXPointValue(position),
                             XXXPointValueOffset(position, -self.margin_h, -self.margin_v),
                             XXXPointValue(position),
                             XXXPointValueOffset(position, self.margin_h, self.margin_v),
                             XXXPointValue(position)];
    }];
}

- (void) onAnimation:(void(^)(CAKeyframeAnimation * animation, CGPoint position))config{
    
    [self.internalImageView.layer removeAllAnimations];
    
    CGPoint position = self.internalImageView.center;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = self.duration;
    if (config) {
        config(animation, position);
    }
    animation.calculationMode = kCAAnimationPaced;
    animation.delegate = self;
    animation.repeatCount = INFINITY;
    [self.internalImageView.layer addAnimation:animation forKey:XXXVerticalAnimationKey];
    
}
#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        [self onAnimation];
    }
}

@end
