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

@defs(MMAnimatable)

- (UIView<MMAnimatable> *) _UIView{
    if ([self isKindOfClass:[UIView class]]
        && [self conformsToProtocol:@protocol(MMAnimatable)]) {
        UIView<MMAnimatable> * _self = (UIView<MMAnimatable> *)self;
        return _self;
    }
    return  nil;
}

- (MMAnimationPromise *) animateWith:(MMAnimationConfiguration *)config{
    
    if (self._UIView) {
        MMAnimationPromise * promise = [[MMAnimationPromise alloc] initWithView:self._UIView];
        [promise.delay(config.delayValue) thenAnimationWith:config];
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
    
    if (animationType.type == MMAnimationTypeSlide) {
        [self _slideWithWay:animationType.way
                  direction:animationType.direction
              configuration:config
                 completion:completion];
    }
    /*
     switch animation {
     case let .slide(way, direction):
     slide(way, direction: direction, configuration: configuration, completion: completion)
     case let .squeeze(way, direction):
     squeeze(way, direction: direction, configuration: configuration, completion: completion)
     case let .squeezeFade(way, direction):
     squeezeFade(way, direction: direction, configuration: configuration, completion: completion)
     case let .slideFade(way, direction):
     slideFade(way, direction: direction, configuration: configuration, completion: completion)
     case let .fade(way):
     fade(way, configuration: configuration, completion: completion)
     case let .zoom(way):
     zoom(way, configuration: configuration, completion: completion)
     case let .zoomInvert(way):
     zoom(way, invert: true, configuration: configuration, completion: completion)
     case let .shake(repeatCount):
     shake(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .pop(repeatCount):
     pop(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .squash(repeatCount):
     squash(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .flip(axis):
     flip(axis: axis, configuration: configuration, completion: completion)
     case let .morph(repeatCount):
     morph(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .flash(repeatCount):
     flash(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .wobble(repeatCount):
     wobble(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .swing(repeatCount):
     swing(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .rotate(direction, repeatCount):
     rotate(direction: direction, repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .moveBy(x, y):
     moveBy(x: x, y: y, configuration: configuration, completion: completion)
     case let .moveTo(x, y):
     moveTo(x: x, y: y, configuration: configuration, completion: completion)
     case let .scale(fromX, fromY, toX, toY):
     scale(fromX: fromX, fromY: fromY, toX: toX, toY: toY, configuration: configuration, completion: completion)
     case let .spin(repeatCount):
     spin(repeatCount: repeatCount, configuration: configuration, completion: completion)
     case let .compound(animations, run):
     let animations = animations.filter {
     if case .none = $0 {
     return false
     }
     return true
     }
     guard !animations.isEmpty else {
     completion()
     return
     }
     switch run {
     case .sequential:
     let launch = animations.reversed().reduce(completion) { result, animation in
     return {
     self.doAnimation(animation, configuration: configuration, completion: result)
     }
     }
     launch()
     case .parallel:
     var finalized = 0
     let finalCompletion: () -> Void = {
     finalized += 1
     if finalized == animations.count {
     completion()
     }
     }
     for animation in animations {
     self.doAnimation(animation, configuration: configuration, completion: finalCompletion)
     }
     }
     case .none:
     break
     }
     */
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
    
}

//func zoom(_ way: AnimationType.Way, invert: Bool = false, configuration: AnimationConfiguration, completion: AnimatableCompletion? = nil) {
//    let toAlpha: CGFloat
//
//    switch way {
//    case .in where invert:
//        let scale = configuration.force
//        alpha = 0
//        toAlpha = 1
//        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        animateIn(animationValues: AnimationValues(x: 0, y: 0, scaleX: scale / 2, scaleY: scale / 2),
//                  alpha: toAlpha,
//                  configuration: configuration,
//                  completion: completion)
//    case .in:
//        let scale = 2 * configuration.force
//        alpha = 0
//        toAlpha = 1
//        animateIn(animationValues: AnimationValues(x: 0, y: 0, scaleX: scale, scaleY: scale),
//                  alpha: toAlpha,
//                  configuration: configuration,
//                  completion: completion)
//    case .out:
//        let scale = (invert ? 0.1 :  2) * configuration.force
//        toAlpha = 0
//        animateOut(animationValues: AnimationValues(x: 0, y: 0, scaleX: scale, scaleY: scale),
//                   alpha: toAlpha,
//                   configuration: configuration,
//                   completion: completion)
//    }
//}

- (void) _rotateWithDirection:(MMAnimationRotationDirection)direction
                  repeatCount:(NSUInteger)repeatCount
                configuration:(MMAnimationConfiguration *)config
                   completion:(MMAnimatableCompletion)completion{
    
    [CALayer animation:^{
        
    } completion:completion];
}

//func rotate(direction: AnimationType.RotationDirection,
//            repeatCount: Int,
//            configuration: AnimationConfiguration,
//            completion: AnimatableCompletion? = nil) {
//    CALayer.animate({
//        let animation = CABasicAnimation(keyPath: .rotation)
//        animation.fromValue = direction == .cw ? 0 : CGFloat.pi * 2
//        animation.toValue = direction == .cw  ? CGFloat.pi * 2 : 0
//        animation.duration = configuration.duration
//        animation.repeatCount = Float(repeatCount)
//        animation.autoreverses = false
//        animation.beginTime = self.layer.currentMediaTime + configuration.delay
//        self.layer.add(animation, forKey: "rotate")
//    }, completion: completion)
//}

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
