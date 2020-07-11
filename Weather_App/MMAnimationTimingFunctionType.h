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

///<Normal
extern CAMediaTimingFunction * MMAnimationTimingFunctionLinear();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseIn();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOut();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOut();
extern CAMediaTimingFunction * MMAnimationTimingFunctionDefault();

// http://easings.net/
///<Sine
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInSine();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutSine();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutSine();

///<Quad
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuad();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuad();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuad();

///<Cubic
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInCubic();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutCubic();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutCubic();

///<Quart
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuart();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuart();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuart();

///<Quint
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuint();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuint();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuint();

///<Expo
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInExpo();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutExpo();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutExpo();

///<Circ
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInCirc();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutCirc();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutCirc();

///<Back
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInBack();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutBack();
extern CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutBack();


NS_ASSUME_NONNULL_END
