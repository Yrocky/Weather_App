//
//  MMAnimationTimingFunctionType.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMAnimationTimingFunctionType : CAMediaTimingFunction
@end

///<Normal
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionLinear();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyIn();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOut();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOut();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionDefault();

// http://easings.net/
///<Sine
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInSine();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutSine();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutSine();

///<Quad
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInQuad();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutQuad();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutQuad();

///<Cubic
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInCubic();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutCubic();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutCubic();

///<Quart
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInQuart();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutQuart();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutQuart();

///<Quint
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInQuint();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutQuint();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutQuint();

///<Expo
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInExpo();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutExpo();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutExpo();

///<Circ
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInCirc();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutCirc();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutCirc();

///<Back
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInBack();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyOutBack();
extern MMAnimationTimingFunctionType * MMAnimationTimingFunctionEasyInOutBack();


NS_ASSUME_NONNULL_END
