//
//  MMAnimatable.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimatable.h"
#import "PKProtocolExtension.h"
#import "MMAnimationConfiguration.h"
#import "MMAnimationPromise.h"
#import "MMAnimator.h"
#import "MMAnimationType.h"
#import "MMAnimationKeyPath.h"

@defs(MMAnimatable)

- (UIView<MMAnimatable> *) _UIView{
    if ([self isKindOfClass:[UIView class]]
        && [self conformsToProtocol:@protocol(MMAnimatable)]) {
        UIView<MMAnimatable> * _self = (UIView<MMAnimatable> *)self;
        return _self;
    }
    return  nil;
}
- (MMAnimationPromise *) animationWith:(MMAnimationType *)animationType configuration:(MMAnimationConfiguration *)config{
    if (self._UIView) {
        MMAnimationPromise * promise = [[MMAnimationPromise alloc] initWithView:self._UIView];
        [promise.delay(config.delayValue) thenAnimation:animationType config:config];
        return promise;
    }
    return nil;
}

- (MMAnimationPromise *) delay:(NSTimeInterval)delay{
    if (self._UIView) {
        MMAnimationPromise * promise = [[MMAnimationPromise alloc] initWithView:self._UIView];
        return promise.delay(delay);
    }
    return nil;
}

- (void) doAnimation:(MMAnimationType *)animationType configuration:(MMAnimationConfiguration *)config promise:(MMAnimationPromise *)promise{
    
    MMAnimatableCompletion completion = ^(){
        [promise animationCompletiond];
    };
    
    [self._UIView doAnimation:animationType
                configuration:config
                   completion:completion];
}

- (void) autoRunAnimation{
    if (self.autoRun) {
        self.autoRun = NO;
    }
}
@end

@interface CALayer (MMAnimatable)
+ (void) animation:(MMAnimatableExecution)animation completion:(MMAnimatableCompletion)completion;
- (CFTimeInterval) currentMediaTime;
@end

@implementation UIView (MMAnimatable)

- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
          completion:(MMAnimatableCompletion)completion{
    
    [self layoutIfNeeded];
    
    if (animationType.type == MMAnimationTypeSlide) {
        [self _slideWithWay:animationType.way
                  direction:animationType.direction
              configuration:config
                 completion:completion];
    }
    if (animationType.type == MMAnimationTypeSlideFade) {
        [self _slideFadeWithWay:animationType.way
                      direction:animationType.direction
                  configuration:config
                     completion:completion];
    }
    if (animationType.type == MMAnimationTypeSqueeze) {
        [self _squeezeWithWay:animationType.way
                    direction:animationType.direction
                configuration:config
                   completion:completion];
    }
    if (animationType.type == MMAnimationTypeSqueezeFade) {
        [self _squeezeFadeWithWay:animationType.way
                        direction:animationType.direction
                    configuration:config
                       completion:completion];
    }
    if (animationType.type == MMAnimationTypeFade) {
        [self _fadeWithWay:animationType.fadeWay
             configuration:config
                completion:completion];
    }
    if (animationType.type == MMAnimationTypeZoom) {
        [self _zoomWithWay:animationType.way
                    invert:NO
             configuration:config
                completion:completion];
    }
    if (animationType.type == MMAnimationTypeZoomInvert) {
        [self _zoomWithWay:animationType.way
                    invert:YES
             configuration:config
                completion:completion];
    }
    if (animationType.type == MMAnimationTypeShake) {
        // todo:shake
    }
    if (animationType.type == MMAnimationTypePop) {
        // todo:pop
    }
    if (animationType.type == MMAnimationTypeSquash) {
        // todo:squash
    }
    if (animationType.type == MMAnimationTypeFlip) {
        // todo:filp
    }
    if (animationType.type == MMAnimationTypeMorph) {
        // todo:morph
    }
    if (animationType.type == MMAnimationTypeFlash) {
        [self _flashWithRepeatCount:animationType.repeatCount
                      configuration:config
                         completion:completion];
    }
    if (animationType.type == MMAnimationTypeWobble) {
        // todo:wobble
    }
    if (animationType.type == MMAnimationTypeSwing) {
        // todo:swing
    }
    if (animationType.type == MMAnimationTypeRotate) {
        [self _rotateWithDirection:animationType.rotationDirection
                       repeatCount:animationType.repeatCount
                     configuration:config
                        completion:completion];
    }
    if (animationType.type == MMAnimationTypeMoveBy) {
        // todo:moveBy
    }
    if (animationType.type == MMAnimationTypeMoveTo) {
        // todo:moveTo
    }
    if (animationType.type == MMAnimationTypeScale) {
        // todo:scale
    }
    if (animationType.type == MMAnimationTypeSpin) {
        // todo:spin
    }
    if (animationType.type == MMAnimationTypeCompound) {
        
    }
}

#pragma mark - Animation methods

- (void) _slideWithWay:(MMAnimationWay)way
             direction:(MMAnimationDirection)direction
         configuration:(MMAnimationConfiguration *)config
            completion:(MMAnimatableCompletion)completion{
    
    MMAnimationScale animationValues = [self _computeValues:way
                                                  direction:direction
                                              configuration:config
                                                shouleScale:NO];
    if (way == MMAnimationWayIn) {
        [self _animationInWith:animationValues alpha:1 configuration:config completion:completion];
    }
    if (way == MMAnimationWayOut) {
        [self _animationOutWith:animationValues alpha:1 configuration:config completion:completion];
    }
}

- (void) _slideFadeWithWay:(MMAnimationWay)way
                 direction:(MMAnimationDirection)direction
             configuration:(MMAnimationConfiguration *)config
                completion:(MMAnimatableCompletion)completion{
    
    MMAnimationScale animationValues = [self _computeValues:way
                                                  direction:direction
                                              configuration:config
                                                shouleScale:NO];
    if (way == MMAnimationWayIn) {
        self.alpha = 0;
        [self _animationInWith:animationValues alpha:1 configuration:config completion:completion];
    }
    if (way == MMAnimationWayOut) {
        [self _animationOutWith:animationValues alpha:0 configuration:config completion:completion];
    }
}

- (void) _squeezeWithWay:(MMAnimationWay)way
               direction:(MMAnimationDirection)direction
           configuration:(MMAnimationConfiguration *)config
              completion:(MMAnimatableCompletion)completion{
    
    MMAnimationScale animationValues = [self _computeValues:way
                                                  direction:direction
                                              configuration:config
                                                shouleScale:YES];
    if (way == MMAnimationWayIn) {
        [self _animationInWith:animationValues alpha:1 configuration:config completion:completion];
    }
    if (way == MMAnimationWayOut) {
        [self _animationOutWith:animationValues alpha:1 configuration:config completion:completion];
    }
}

- (void) _squeezeFadeWithWay:(MMAnimationWay)way
                   direction:(MMAnimationDirection)direction
               configuration:(MMAnimationConfiguration *)config
                  completion:(MMAnimatableCompletion)completion{
    
    MMAnimationScale animationValues = [self _computeValues:way
                                                  direction:direction
                                              configuration:config
                                                shouleScale:YES];
    if (way == MMAnimationWayIn) {
        self.alpha = 0;
        [self _animationInWith:animationValues alpha:1 configuration:config completion:completion];
    }
    if (way == MMAnimationWayOut) {
        [self _animationOutWith:animationValues alpha:0 configuration:config completion:completion];
    }
}

- (void) _fadeWithWay:(MMAnimationFadeWay)fadeWay
        configuration:(MMAnimationConfiguration *)config
           completion:(MMAnimatableCompletion)completion{
    
    if (fadeWay == MMAnimationFadeWayIn) {
        self.alpha = 0;
        [self _animationInWith:MMAnimationScaleMake(0, 0, 1, 1)
                         alpha:1 configuration:config completion:completion];
    }
    if (fadeWay == MMAnimationFadeWayOut) {
        self.alpha = 1;
        [self _animationInWith:MMAnimationScaleMake(0, 0, 1, 1)
                         alpha:0 configuration:config completion:completion];
    }
    if (fadeWay == MMAnimationFadeWayOutIn) {
        self.alpha = 0;
        [self _fadeOutInWith:config completion:completion];
    }
    if (fadeWay == MMAnimationFadeWayInOut) {
        [self _fadeInOutWith:config completion:completion];
    }
}

- (void) _zoomWithWay:(MMAnimationWay)way
               invert:(BOOL)invert
        configuration:(MMAnimationConfiguration *)config
           completion:(MMAnimatableCompletion)completion{
    
    CGFloat toAlpha = 0;
    if (way == MMAnimationWayIn) {
        if (invert) {
            CGFloat scale = config.forceValue;
            self.alpha = 0;
            toAlpha = 1.0;
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            MMAnimationScale animationScale = MMAnimationScaleMake(0, 0, scale*0.5, scale*0.5);
            [self _animationInWith:animationScale
                             alpha:toAlpha
                     configuration:config
                        completion:completion];
        } else {
            CGFloat scale = config.forceValue * 2.0;
            self.alpha = 0;
            toAlpha = 1.0;
            MMAnimationScale animationScale = MMAnimationScaleMake(0, 0, scale, scale);
            [self _animationInWith:animationScale
                             alpha:toAlpha
                     configuration:config
                        completion:completion];
        }
    }
    if (way == MMAnimationWayOut) {
        CGFloat scale = config.forceValue * (invert ? 0.1 : 2.0);
        toAlpha = 1.0;
        MMAnimationScale animationScale = MMAnimationScaleMake(0, 0, scale, scale);
        [self _animationInWith:animationScale
                         alpha:toAlpha
                 configuration:config
                    completion:completion];
    }
}

- (void) _rotateWithDirection:(MMAnimationRotationDirection)direction
                  repeatCount:(NSUInteger)repeatCount
                configuration:(MMAnimationConfiguration *)config
                   completion:(MMAnimatableCompletion)completion{
    
    [CALayer animation:^{
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.fromValue = direction == MMAnimationWayRotationDirectionCW ? @(0) : @(3.14*2);
        animation.toValue = direction == MMAnimationWayRotationDirectionCW ? @(3.14*2) : @(0);
        animation.duration = config.durationValue;
        animation.repeatCount = repeatCount;
        animation.autoreverses = NO;
        animation.beginTime = self.layer.currentMediaTime + config.delayValue;
        [self.layer addAnimation:animation forKey:@"rotate"];
    } completion:completion];
}

- (void) _flashWithRepeatCount:(NSUInteger)repeatCount
                 configuration:(MMAnimationConfiguration *)config
                    completion:(MMAnimatableCompletion)completion {
    [CALayer animation:^{
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.fromValue = @(1);
        animation.toValue = @(0);
        animation.duration = config.durationValue;
        animation.repeatCount = repeatCount * 2.0;
        animation.autoreverses = YES;
        animation.beginTime = self.layer.currentMediaTime + config.delayValue;
        [self.layer addAnimation:animation forKey:@"flash"];
    } completion:completion];
}

- (void) _morphWithRepeatCount:(NSUInteger)repeatCount
                 configuration:(MMAnimationConfiguration *)config
                    completion:(MMAnimatableCompletion)completion {
    [CALayer animation:^{
        
        CAKeyframeAnimation * morphX = [CAKeyframeAnimation animationWithKeyPath:MMAnimationKeyPath.scaleX];
        morphX.values = @[@(1),@(1.3*config.forceValue),@(0.7),@(1.3*config.forceValue),@(1)];
        morphX.keyTimes = @[@(0),@(0.2),@(0.4),@(0.6),@(0.8),@(1)];
        morphX.timingFunction = config.timingFunctionValue;
        
        CAKeyframeAnimation * morphY = [CAKeyframeAnimation animationWithKeyPath:MMAnimationKeyPath.scaleX];
        morphY.values = @[@(1),@(0.7),@(1.3*config.forceValue),@(0.7),@(1)];
        morphY.keyTimes = @[@(0),@(0.2),@(0.4),@(0.6),@(0.8),@(1)];
        morphY.timingFunction = config.timingFunctionValue;
        
        CAAnimationGroup * group = [CAAnimationGroup animation];
        group.duration = config.durationValue;
        group.animations = @[morphX, morphY];
        group.repeatCount = repeatCount;
        group.beginTime = self.layer.currentMediaTime + config.delayValue;
        [self.layer addAnimation:group forKey:@"morph"];
    } completion:completion];
}

#pragma mark -

- (void) _fadeOutInWith:(MMAnimationConfiguration *)config completion:(MMAnimatableCompletion)completion{
    
    [CALayer animation:^{
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(1);
        animation.toValue = @(0);
        animation.timingFunction = config.timingFunctionValue;
        animation.duration = config.durationValue;
        animation.beginTime = self.layer.currentMediaTime + config.delayValue;
        animation.autoreverses = YES;
        [self.layer addAnimation:animation forKey:@"fade"];
    } completion:completion];
}

- (void) _fadeInOutWith:(MMAnimationConfiguration *)config completion:(MMAnimatableCompletion)completion{
    
    [CALayer animation:^{
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.timingFunction = config.timingFunctionValue;
        animation.duration = config.durationValue;
        animation.beginTime = self.layer.currentMediaTime + config.delayValue;
        animation.autoreverses = YES;
        animation.removedOnCompletion = NO;
        [self.layer addAnimation:animation forKey:@"fade"];
    } completion:^{
        self.alpha = 0;
        if (completion) {
            completion();
        }
    }];
}

- (MMAnimationScale) _computeValues:(MMAnimationWay)way direction:(MMAnimationDirection)direction configuration:(MMAnimationConfiguration *)config shouleScale:(BOOL)shouldScale{
    
    CGFloat scale = 3 * config.forceValue;
    CGFloat scaleX = 1;
    CGFloat scaleY = 1;
    
    CGRect frame;
    frame = self.frame;
    if (self.window) {
        frame = [self.window convertRect:self.frame toView:self.window];
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat x = 0;
    CGFloat y = 0;
    if ((way == MMAnimationWayIn && direction == MMAnimationWayDirectionLeft) ||
        (way == MMAnimationWayOut && direction == MMAnimationWayDirectionRight)) {
        x = screenSize.width - CGRectGetMinX(frame);
    }
    if ((way == MMAnimationWayIn && direction == MMAnimationWayDirectionRight) ||
        (way == MMAnimationWayOut && direction == MMAnimationWayDirectionLeft)) {
        x = -CGRectGetMaxX(frame);
    }
    if ((way == MMAnimationWayIn && direction == MMAnimationWayDirectionUp) ||
        (way == MMAnimationWayOut && direction == MMAnimationWayDirectionDown)) {
        y = screenSize.height - CGRectGetMinY(frame);
    }
    if ((way == MMAnimationWayIn && direction == MMAnimationWayDirectionDown) ||
        (way == MMAnimationWayOut && direction == MMAnimationWayDirectionUp)) {
        y = -CGRectGetMaxY(frame);
    }
    
    x *= config.forceValue;
    y *= config.forceValue;
    
    BOOL isVertical = (direction == MMAnimationWayDirectionDown) ||
    (direction == MMAnimationWayDirectionDown);
    
    if (shouldScale && isVertical) {
        scaleY = scale;
    } else if (shouldScale) {
        scaleX = scale;
    }
    return MMAnimationScaleMake(x, y, scaleX, scaleY);
}

- (void) _animationInWith:(MMAnimationScale)animationValues
                    alpha:(CGFloat)alpha
            configuration:(MMAnimationConfiguration *)config
               completion:(MMAnimatableCompletion)completion{
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(animationValues.fromX,
                                                                   animationValues.fromY);
    CGAffineTransform scale = CGAffineTransformMakeScale(animationValues.toX,
                                                         animationValues.toY);
    CGAffineTransform translateAndScale = CGAffineTransformConcat(translate, scale);
    self.transform = translateAndScale;
    
    [[UIView.animator.duration(3) animations:^{
        self.alpha = alpha;
        self.transform = CGAffineTransformIdentity;
    }] completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void) _animationOutWith:(MMAnimationScale)animationValues
                     alpha:(CGFloat)alpha
             configuration:(MMAnimationConfiguration *)config
                completion:(MMAnimatableCompletion)completion{
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(animationValues.fromX,
                                                                   animationValues.fromY);
    CGAffineTransform scale = CGAffineTransformMakeScale(animationValues.toX,
                                                         animationValues.toY);
    CGAffineTransform translateAndScale = CGAffineTransformConcat(translate, scale);
    
    [[UIView.animator.duration(3) animations:^{
        self.alpha = alpha;
        self.transform = translateAndScale;
    }] completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end

@implementation CALayer (MMAnimatable)

+ (void)animation:(MMAnimatableExecution)animation completion:(MMAnimatableCompletion)completion{
    [CATransaction begin];
    if (completion) {
        [CATransaction setCompletionBlock:^{
            completion();
        }];
    }
    if (animation) {
        animation();
    }
    [CATransaction commit];
}

- (CFTimeInterval) currentMediaTime{
    return [self convertTime:CACurrentMediaTime() fromLayer:nil];
}
@end
