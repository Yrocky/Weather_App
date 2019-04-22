//
//  MMAnimationanimation.m
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "MMAnimationType.h"

@interface MMAnimationType ()

@property (nonatomic ,assign) MMAnimationAxis along;

@property (nonatomic ,assign) MMAnimationRotationDirection rotationDirection;

@property (nonatomic ,assign) CGFloat x;
@property (nonatomic ,assign) CGFloat y;

@property (nonatomic ,assign) struct MMAnimationScale scale;

@property (nonatomic ,copy) NSArray<MMAnimationType *> * animations;
@property (nonatomic ,assign) MMAnimationRun run;
@end

@implementation MMAnimationType

@end

@implementation MMAnimationType (Flip)
@end

@implementation MMAnimationType (Rotate)
@end

@implementation MMAnimationType (Move)
@end

@implementation MMAnimationType (Scale)
+ (instancetype) scaleToX:(CGFloat)x y:(CGFloat)y{
    return MMAnimationTypeMakeScale(MMAnimationScaleMake(1, 1, x, y));
}
+ (instancetype) scaleFromX:(CGFloat)x y:(CGFloat)y{
    return MMAnimationTypeMakeScale(MMAnimationScaleMake(x, y, 1, 1));
}
@end

@implementation MMAnimationType (Compound)
@end

MMAnimationType * MMAnimationTypeMakeSlide(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSlide;
    animation.way = way;
    animation.direction = direction;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSqueeze(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSqueeze;
    animation.way = way;
    animation.direction = direction;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSlideFade(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSlideFade;
    animation.way = way;
    animation.direction = direction;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSqueezeFade(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSqueezeFade;
    animation.way = way;
    animation.direction = direction;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeFade(MMAnimationFadeWay fadeWay){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeFade;
    animation.fadeWay = fadeWay;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeZoom(MMAnimationWay way){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeZoom;
    animation.way = way;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeZoomInvert(MMAnimationWay way){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeZoomInvert;
    animation.way = way;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeShake(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeShake;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakePop(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypePop;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSquash(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSquash;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeFlip(MMAnimationAxis along){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeFlip;
    animation.along = along;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeMorph(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeMorph;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeFlash(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeFlash;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeWobble(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeWobble;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSwing(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSwing;
    animation.repeatCount = repeatCount;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeRotate(MMAnimationRotationDirection rotationDirection){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeRotate;
    animation.rotationDirection = rotationDirection;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeMoveTo(CGFloat x, CGFloat y){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeMoveTo;
    animation.x = x;
    animation.y = y;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeMoveBy(CGFloat x, CGFloat y){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeMoveBy;
    animation.x = x;
    animation.y = y;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeScale(struct MMAnimationScale scale){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeScale;
    animation.scale = scale;
    return animation;
}
MMAnimationType * MMAnimationTypeMakeSpin(NSUInteger repeatCount){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeSpin;
    animation.repeatCount = repeatCount;
    return animation;
}

MMAnimationType * MMAnimationTypeMakeCompound(NSArray<MMAnimationType *> * animations ,MMAnimationRun run){
    MMAnimationType * animation = [MMAnimationType new];
    animation.type = MMAnimationTypeCompound;
    animation.animations = animations;
    animation.run = run;
    return animation;
}
