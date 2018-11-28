//
//  MMAnimationTimingFunctionType.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimationTimingFunctionType.h"

@implementation MMAnimationTimingFunctionType
@end

///<Normal
MMAnimationTimingFunctionType * MMAnimationTimingFunctionLinear(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithName:kCAMediaTimingFunctionLinear];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseIn(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithName:kCAMediaTimingFunctionEaseIn];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOut(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithName:kCAMediaTimingFunctionEaseOut];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOut(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionDefault(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithName:kCAMediaTimingFunctionDefault];
    return type;
};

// http://easings.net/
///<Sine
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInSine(){
    
   MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.47 :0 :0.745 :0.715];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutSine(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.39 :0.575 :0.565 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutSine(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.445 :0.05 :0.55 :0.95];
    return type;
};

///<Quad
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInQuad(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.55 :0.085 :0.68 :0.53];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutQuad(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.25 :0.46 :0.45 :0.94];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutQuad(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.455 :0.03 :0.515 :0.955];
    return type;
};

///<Cubic
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInCubic(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.55 :0.055 :0.675 :0.19];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutCubic(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.215 :0.61 :0.355 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutCubic(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.645 :0.045 :0.355 :1];
    return type;
};

///<Quart
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInQuart(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.895 :0.03 :0.685 :0.22];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutQuart(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.165 :0.84 :0.44 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutQuart(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.77 :0 :0.175 :1];
    return type;
};

///<Quint
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInQuint(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.755 :0.05 :0.855 :0.06];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutQuint(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.23 :1 :0.32 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutQuint(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.86 :0 :0.07 :1];
    return type;
};

///<Expo
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInExpo(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.95 :0.05 :0.795 :0.035];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutExpo(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.19 :1 :0.22 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutExpo(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:1 :0 :0 :1];
    return type;
};

///<Circ
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInCirc(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.6 :0.04 :0.98 :0.335];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutCirc(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.075 :0.82 :0.165 :1];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutCirc(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.785 :0.135 :0.15 :0.86];
    return type;
};

///<Back
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInBack(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.6 :-0.28 :0.735 :0.045];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseOutBack(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.175 :0.885 :0.32 :1.275];
    return type;
};
MMAnimationTimingFunctionType * MMAnimationTimingFunctionEaseInOutBack(){
    
    MMAnimationTimingFunctionType * type = [MMAnimationTimingFunctionType functionWithControlPoints:0.68 :-0.55 :0.265 :1.55];
    return type;
};
