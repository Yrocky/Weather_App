//
//  MMAnimationTimingFunctionType.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimationTimingFunctionType.h"

///<Normal
CAMediaTimingFunction * MMAnimationTimingFunctionLinear(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseIn(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOut(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOut(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionDefault(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    return type;
};

// http://easings.net/
///<Sine
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInSine(){
    
   CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.47 :0 :0.745 :0.715];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutSine(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.39 :0.575 :0.565 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutSine(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.445 :0.05 :0.55 :0.95];
    return type;
};

///<Quad
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuad(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.55 :0.085 :0.68 :0.53];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuad(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.46 :0.45 :0.94];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuad(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.455 :0.03 :0.515 :0.955];
    return type;
};

///<Cubic
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInCubic(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.55 :0.055 :0.675 :0.19];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutCubic(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.215 :0.61 :0.355 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutCubic(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.645 :0.045 :0.355 :1];
    return type;
};

///<Quart
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuart(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.895 :0.03 :0.685 :0.22];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuart(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.165 :0.84 :0.44 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuart(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.77 :0 :0.175 :1];
    return type;
};

///<Quint
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInQuint(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.755 :0.05 :0.855 :0.06];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutQuint(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.23 :1 :0.32 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutQuint(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.86 :0 :0.07 :1];
    return type;
};

///<Expo
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInExpo(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.05 :0.795 :0.035];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutExpo(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.19 :1 :0.22 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutExpo(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0 :1];
    return type;
};

///<Circ
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInCirc(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.6 :0.04 :0.98 :0.335];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutCirc(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.075 :0.82 :0.165 :1];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutCirc(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.785 :0.135 :0.15 :0.86];
    return type;
};

///<Back
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInBack(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.6 :-0.28 :0.735 :0.045];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseOutBack(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.175 :0.885 :0.32 :1.275];
    return type;
};
CAMediaTimingFunction * MMAnimationTimingFunctionEaseInOutBack(){
    
    CAMediaTimingFunction * type = [CAMediaTimingFunction functionWithControlPoints:0.68 :-0.55 :0.265 :1.55];
    return type;
};
