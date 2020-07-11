//
//  XXXKwaiFrameAdjustView.m
//  Weather_App
//
//  Created by skynet on 2019/12/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXKwaiFrameAdjustView.h"
#import "Masonry.h"

@interface XXXKwaiSeparateView : UIView{
    NSArray <UIView *> * vSepareteViews;
    NSArray <UIView *> * hSepareteViews;
}

/// count为分割为几部分，default 2
- (instancetype) initWithSeparaterCount:(NSInteger)count;
@end

@interface XXXKwaiFrameAdjustView (){
    BOOL _frozened;
}

@property(nonatomic) _Bool showGuideWhenTouched;

@property(retain, nonatomic) UIView *guideGesView;
@property(retain, nonatomic) UIView *borderView;

@property(retain, nonatomic) UIView *hDashLine;
@property(retain, nonatomic) UIView *vDashLine;

@property(retain, nonatomic) UILabel *tipsLabel;

@property(retain, nonatomic) UIPinchGestureRecognizer *pinch;
@property(retain, nonatomic) UIPanGestureRecognizer *pan;
@property(retain, nonatomic) UITapGestureRecognizer *tap;

@property(nonatomic) double oriY;
@property(nonatomic) double oriX;
//@property(copy, nonatomic) CDUnknownBlockType onTouchEndBlock;
//@property(copy, nonatomic) CDUnknownBlockType onTouchStartBlock;
//@property(copy, nonatomic) CDUnknownBlockType frameAdjustOnTapBlock;
//@property(copy, nonatomic) CDUnknownBlockType frameAdjustEndBlock;
//@property(copy, nonatomic) CDUnknownBlockType frameAdjustBlock;
@end
@implementation XXXKwaiFrameAdjustView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.oriX = self.oriY = 0.0f;
        
        self.clipsToBounds = YES;
        
        // guideGes view
        self.guideGesView = [UIView new];
        self.guideGesView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.guideGesView.userInteractionEnabled = YES;
        [self addSubview:self.guideGesView];
        
        // border view
        self.borderView = [UIView new];
        self.borderView.hidden = YES;
        self.borderView.layer.borderColor = [UIColor orangeColor].CGColor;
        self.borderView.layer.borderWidth = 1.0f;
        [self addSubview:self.borderView];
        
        // dashLine view
        [self addSubview:self.hDashLine];
        [self addSubview:self.vDashLine];
        
        CGFloat height = 2.0f;
        [self.hDashLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
        }];
        [self.vDashLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(height);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.guideGesView.frame = self.bounds;
    self.borderView.frame = self.bounds;
}

- (void)removeGestures{
    [self removeGestureRecognizer:_pinch];
    [self removeGestureRecognizer:_pan];
    [self removeGestureRecognizer:_tap];
    _pinch = nil;
    _pan = nil;
    _tap = nil;
}

- (void)addGestures{

    [self removeGestures];
    
    [self addGestureRecognizer:self.pinch];
    [self addGestureRecognizer:self.pan];
    [self addGestureRecognizer:self.tap];
}

- (void)addDashLineNotifications{
    
}

- (void) moveBorderView:(CGPoint)offset{
    CGPoint center = self.borderView.center;
    center.x += offset.x;
    center.y += offset.y;
    self.borderView.center = center;
}

- (void) frozenIfNeeds{

    if (_frozened) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - Action M

- (void)onPinch:(UIPinchGestureRecognizer *)gesture{
    
}
- (void)onPan:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.borderView.hidden = NO;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self];
        NSLog(@"pan translation:%@",NSStringFromCGPoint(translation));
        [self moveBorderView:translation];
        [gesture setTranslation:CGPointZero inView:gesture.view];

    } else if (gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateEnded) {
        self.borderView.hidden = YES;
    }
}

- (void)onTap:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    NSLog(@"tap point:%@",NSStringFromCGPoint(point));
}

#pragma mark - Touch M

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
//    self.borderView.hidden = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
//    self.borderView.hidden = NO;
}

#pragma mark - DashLine M

- (void)setHiddenAndDealWithGesture:(_Bool)arg1{
    
}

- (void)showHDashLine:(BOOL)show{
    
}

- (void)showVDashLine:(BOOL)show{
    
}

#pragma mark - Border M

- (void)showBorderWithTransform:(id)arg1 ratio:(double)arg2{
    
}

#pragma mark - Lazy M

- (UIPinchGestureRecognizer *)pinch{
    if (!_pinch) {
        _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
        action:@selector(onPinch:)];
    }
    return _pinch;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(onPan:)];
    }
    return _pan;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(onTap:)];
    }
    return _tap;
}

- (UIView *)hDashLine{
    if (!_hDashLine) {
        _hDashLine = [UIView new];
        _hDashLine.backgroundColor = [UIColor greenColor];
    }
    return _hDashLine;
}

- (UIView *)vDashLine{
    if (!_vDashLine) {
        _vDashLine = [UIView new];
        _vDashLine.backgroundColor = [UIColor greenColor];
    }
    return _vDashLine;
}
@end

@implementation XXXKwaiSeparateView

- (instancetype) initWithSeparaterCount:(NSInteger)count{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        if (count == 1) {
            return nil;
        }
        
        NSMutableArray * vTmp = [NSMutableArray array];
        NSMutableArray * hTmp = [NSMutableArray array];
        
        for (NSInteger index = 0; index < count; index ++) {
            UIView * vSepareteView = [UIView new];
            vSepareteView.backgroundColor = [UIColor greenColor];
            [self addSubview:vSepareteView];
            [vTmp addObject:vSepareteView];
            
            UIView * hSepareteView = [UIView new];
            hSepareteView.backgroundColor = [UIColor greenColor];
            [self addSubview:hSepareteView];
            [hTmp addObject:hSepareteView];
        }
        [vTmp mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [hTmp mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return self;
}

@end
