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

@implementation UIView (MMAnimatable)

- (void) doAnimation:(MMAnimationType *)animationType
       configuration:(MMAnimationConfiguration *)config
          completion:(MMAnimatableCompletion)completion{
    
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

//func computeValues(way: AnimationType.Way,
//                   direction: AnimationType.Direction,
//                   configuration: AnimationConfiguration,
//                   shouldScale: Bool) -> AnimationValues {
//    let scale = 3 * configuration.force
//    var scaleX: CGFloat = 1
//    var scaleY: CGFloat = 1
//
//    var frame: CGRect
//    if let window = window {
//        frame = window.convert(self.frame, to: window)
//    } else {
//        frame = self.frame
//    }
//
//    var x: CGFloat = 0
//    var y: CGFloat = 0
//    switch (way, direction) {
//        case (.in, .left), (.out, .right):
//            x = screenSize.width - frame.minX
//        case (.in, .right), (.out, .left):
//            x = -frame.maxX
//        case (.in, .up), (.out, .down):
//            y = screenSize.height - frame.minY
//        case (.in, .down), (.out, .up):
//            y = -frame.maxY
//    }
//
//    x *= configuration.force
//    y *= configuration.force
//    if shouldScale && direction.isVertical() {
//        scaleY = scale
//    } else if shouldScale {
//        scaleX = scale
//    }
//
//    return (x: x, y: y, scaleX: scaleX, scaleY: scaleY)
//}
- (void) _animationIn:(NSInteger)animationValues alpha:(CGFloat)alpha configuration:(MMAnimationConfiguration *)config completion:(MMAnimationConfiguration *)completion{
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform translateAndScale = CGAffineTransformConcat(translate, scale);
    self.transform = translateAndScale;
    
    [[UIView.animator.duration(3) animations:^{
        self.alpha = alpha;
        self.transform = CGAffineTransformIdentity;
    }] completion:^(BOOL finished) {
        
    }];
//
//    func animateIn(animationValues: AnimationValues, alpha: CGFloat, configuration: AnimationConfiguration, completion: AnimatableCompletion? = nil) {
//        let translate = CGAffineTransform(translationX: animationValues.x, y: animationValues.y)
//        let scale = CGAffineTransform(scaleX: animationValues.scaleX, y: animationValues.scaleY)
//        let translateAndScale = translate.concatenating(scale)
//        transform = translateAndScale
//
//        UIView.animate(with: configuration, animations: {
//            self.transform = .identity
//            self.alpha = alpha
//        }, completion: { completed in
//            if completed {
//                completion?()
//            }
//        })
}
- (void) _animationOut:(NSInteger)animationValues alpha:(CGFloat)alpha configuration:(MMAnimationConfiguration *)config completion:(MMAnimationConfiguration *)completion{
    
}

//func animateOut(animationValues: AnimationValues, alpha: CGFloat, configuration: AnimationConfiguration, completion: AnimatableCompletion? = nil) {
//    let translate = CGAffineTransform(translationX: animationValues.x, y: animationValues.y)
//    let scale = CGAffineTransform(scaleX: animationValues.scaleX, y: animationValues.scaleY)
//    let translateAndScale = translate.concatenating(scale)
//
//    UIView.animate(with: configuration, animations: {
//        self.transform = translateAndScale
//        self.alpha = alpha
//    }, completion: { completed in
//        if completed {
//            completion?()
//        }
//    })
//}
@end

