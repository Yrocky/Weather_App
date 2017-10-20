//
//  MMPreviewHUD.m
//  Weather_App
//
//  Created by Rocky Young on 2017/9/14.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMPreviewHUD.h"
#import "HLLAttributedBuilder.h"
#import <objc/runtime.h>


static CGFloat kMaxPreviewWidth = 200;
static CGFloat kAnimationDuration = 0.45;
static CGFloat kDelayDismissTime = 5;

@interface MMPreviewLabel : UILabel
+ (instancetype)label;
- (CGSize) configAttributedString:(NSAttributedString *)attString;
@end

@implementation MMPreviewLabel

+ (instancetype)label {
    
    MMPreviewLabel *label = [[MMPreviewLabel alloc]init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (CGSize) configAttributedString:(NSAttributedString *)attString{
    
    [self setAttributedText:attString];
    CGSize size = [attString size];
    size = [attString boundingRectWithSize:CGSizeMake(kMaxPreviewWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}
@end

@interface MMPreviewHUD ()<CAAnimationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) NSTimer * minShowTimer;
@property (nonatomic ,strong) MMPreviewLabel * l;
@property (nonatomic ,assign) BOOL handleTapFlag;// default YES
@end

@implementation MMPreviewHUD

- (void)dealloc
{
    NSLog(@"MMPreviewHUD dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.l= [MMPreviewLabel label];
        [self addSubview:self.l];
        
        self.handleTapFlag = YES;
    }
    return self;
}

+ (instancetype) previewHUD{

    return [[self alloc] init];
}

- (void) addAction:(SEL)action withTarget:(id)target{

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void) configWithText:(NSString *)text{

    NSDictionary * normalStyle = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSDictionary * nameStyle = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.31 green:0.68 blue:0.24 alpha:1.00],
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
    NSDictionary * clearStyle = @{NSForegroundColorAttributeName:[UIColor clearColor]};
    
    NSAttributedString * att = AttBuilderStyle(text, normalStyle).
    configStringAndStyle(@"(?<=\\<)[^\\>]+",nameStyle).
    configStringAndStyle(@"[<>]",clearStyle).
    attributedStr();
    CGSize s = [self.l configAttributedString:att];
    
    CGFloat offset = 5;
    
    CGRect f = (CGRect){
        offset,offset,
        s.width + 2 * offset,s.height + 2 * offset
    };
    self.l.frame = (CGRect){
        offset,offset,
        s
    };
    
    CGRect sf = self.superview.frame;
    self.frame = (CGRect){
        CGRectGetWidth(sf) - CGRectGetWidth(f) - 2 * offset,75,
        f.size
    };
}

+ (MMPreviewHUD *)HUDForView:(UIView *)view {
    Class hudClass = [MMPreviewHUD class];
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:hudClass]) {
            return (MMPreviewHUD *)subview;
        }
    }
    return nil;
}

- (void) addTimer{
    
    [self removeTimer];
    
    self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:kDelayDismissTime
                                                         target:self
                                                       selector:@selector(handleMinShowTimer:)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void) removeTimer{
    
    [self.minShowTimer invalidate];
    self.minShowTimer = nil;
}

- (void) handleMinShowTimer:(NSTimer *)timer{
    
    [self dismiss];
}

- (void) show{

    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(self.superview.frame), self.center.y)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.center];
    
    CABasicAnimation * alpheAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpheAnimation.fromValue = @(0);
    alpheAnimation.toValue = @(1);
    
    CAAnimationGroup * animation = [CAAnimationGroup animation];
    animation.duration = kAnimationDuration;
    animation.animations = @[positionAnimation,alpheAnimation];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self.layer addAnimation:animation forKey:@"showAnimation"];
}

- (void) dismiss{

    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(self.superview.frame), self.center.y)];
    
    CABasicAnimation * alpheAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpheAnimation.fromValue = @(1);
    alpheAnimation.toValue = @(0);
    
    CAAnimationGroup * animation = [CAAnimationGroup animation];
    animation.duration = kAnimationDuration;
    animation.animations = @[positionAnimation,alpheAnimation];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"dismissAnimation"];
}

#pragma mark - CAAnimationDelegate M

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (self.minShowTimer) {
        [self removeTimer];
    }
    [self removeFromSuperview];
}

#pragma mark - UIGestureRecognizerDelegate M

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if (self.handleTapFlag) {
        [self handleMinShowTimer:nil];
        self.handleTapFlag = NO;
        return YES;
    }
    return NO;
}

+ (void) showHUD:(NSString *)text inViewController:(UIViewController *)v action:(SEL)action{

    [self showHUD:text inView:v.view target:v action:action];
}

// text 《昵称:》消息内容
+ (void) showHUD:(NSString *)text inView:(UIView *)view target:(id)target action:(SEL)action{
    
    NSAssert(view, @"请设置有效的 view ");
    
    MMPreviewHUD * previewHUD;
    
    if ([MMPreviewHUD HUDForView:view]) {
        previewHUD = [MMPreviewHUD HUDForView:view];
        [previewHUD configWithText:text];
    }else{
        previewHUD = [MMPreviewHUD previewHUD];
        [view addSubview:previewHUD];
        [previewHUD configWithText:text];
        [previewHUD show];
    }
    [previewHUD addTimer];
    [view bringSubviewToFront:previewHUD];
    if (target && [target respondsToSelector:action]) {
        [previewHUD addAction:action withTarget:target];
    }
}

@end

