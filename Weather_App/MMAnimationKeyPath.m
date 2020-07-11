//
//  MMAnimationKeyPath.m
//  Weather_App
//
//  Created by meme-rocky on 2019/1/10.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMAnimationKeyPath.h"

@implementation MMAnimationKeyPath
__STRING_PROP__(postion)
__STRING_PROP__(transform)
__STRING_PROP__(strokeEnd)
__STRING_PROP__(strokeStart)
__STRING_PROP__(opacity)
__STRING_PROP__(path)
__STRING_PROP__(lineWidth)

+ (NSString *)postionX {
    return @"position.x";
}
+ (NSString *)postionY {
    return @"position.y";
}

+ (NSString *)rotation {
    return @"transform.rotation";
}
+ (NSString *)rotationX {
    return @"transform.rotation.x";
}
+ (NSString *)rotationY {
    return @"transform.rotation.y";
}
+ (NSString *)rotationZ {
    return @"transform.rotation.z";
}
+ (NSString *)scale {
    return @"transform.scale";
}
+ (NSString *)scaleX {
    return @"transform.scale.x";
}
+ (NSString *)scaleY {
    return @"transform.scale.y";
}
+ (NSString *)scaleZ {
    return @"transform.scale.z";
}
+ (NSString *)translation {
    return @"transform.translation";
}
+ (NSString *)translationX {
    return @"transform.translation.x";
}
+ (NSString *)translationY {
    return @"transform.translation.y";
}
+ (NSString *)translationZ {
    return @"transform.translation.z";
}
@end
