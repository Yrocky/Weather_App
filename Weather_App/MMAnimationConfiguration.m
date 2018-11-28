//
//  MMAnimationConfiguration.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimationConfiguration.h"

@implementation MMAnimationConfiguration

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.damping(0.7).velocity(0.7).duration(0.7).delay(0).
        force(1);
    }
    return self;
}

- (MMAnimationConfiguration*(^)(CGFloat)) damping{
    return ^MMAnimationConfiguration *(CGFloat damping){
        _dampingValue = damping;
        return self;
    };
}
- (MMAnimationConfiguration*(^)(CGFloat)) velocity{
    return ^MMAnimationConfiguration *(CGFloat velocity){
        _velocityValue = velocity;
        return self;
    };
}
- (MMAnimationConfiguration*(^)(NSTimeInterval)) duration{
    return ^MMAnimationConfiguration *(NSTimeInterval duration){
        _durationValue = duration;
        return self;
    };
}
- (MMAnimationConfiguration*(^)(NSTimeInterval)) delay{
    return ^MMAnimationConfiguration *(NSTimeInterval delay){
        _delayValue = delay;
        return self;
    };
}
- (MMAnimationConfiguration*(^)(CGFloat)) force{
    return ^MMAnimationConfiguration *(CGFloat force){
        _forceValue = force;
        return self;
    };
}
- (MMAnimationConfiguration*(^)(CAMediaTimingFunction *)) timingFunction{
    return ^MMAnimationConfiguration *(CAMediaTimingFunction * timingFunction){
        _timingFunctionValue = timingFunction;
        return self;
    };
}
- (UIViewAnimationOptions) options{
    if (self.timingFunctionValue) {
        return UIViewAnimationOptionAllowUserInteraction &&
        UIViewAnimationCurveEaseIn;
    }
    return UIViewAnimationOptionAllowUserInteraction;
}
//var options: UIView.AnimationOptions {
//    if let curveOption = timingFunction.viewAnimationCurveOption {
//        return [
//                .allowUserInteraction,
//                curveOption,
//                .overrideInheritedCurve,
//                .overrideInheritedOptions,
//                .overrideInheritedDuration]
//    }
//    return [.allowUserInteraction]
//}
@end
