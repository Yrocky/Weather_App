//
//  MMAnimationType.m
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
+ (instancetype) scleTo:(CGFloat)x y:(CGFloat)y{
    return MMAnimationTypeMakeScale(MMAnimationScaleMake(1, 1, x, y));
}
+ (instancetype) scleFrom:(CGFloat)x y:(CGFloat)y{
    return MMAnimationTypeMakeScale(MMAnimationScaleMake(x, y, 1, 1));
}
@end

@implementation MMAnimationType (Compound)
@end

MMAnimationType * MMAnimationTypeMakeSlide(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    type.direction = direction;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSqueeze(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    type.direction = direction;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSlideFade(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    type.direction = direction;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSqueezeFade(MMAnimationWay way, MMAnimationDirection direction){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    type.direction = direction;
    return type;
}
MMAnimationType * MMAnimationTypeMakeFade(MMAnimationFadeWay fadeWay){
    MMAnimationType * type = [MMAnimationType new];
    type.fadeWay = fadeWay;
    return type;
}
MMAnimationType * MMAnimationTypeMakeZoom(MMAnimationWay way){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    return type;
}
MMAnimationType * MMAnimationTypeMakeZoomInvert(MMAnimationWay way){
    MMAnimationType * type = [MMAnimationType new];
    type.way = way;
    return type;
}
MMAnimationType * MMAnimationTypeMakeShake(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakePop(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSquash(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeFlip(MMAnimationAxis along){
    MMAnimationType * type = [MMAnimationType new];
    type.along = along;
    return type;
}
MMAnimationType * MMAnimationTypeMakeMorph(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeFlash(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeWobble(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSwing(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}
MMAnimationType * MMAnimationTypeMakeRotate(MMAnimationRotationDirection rotationDirection){
    MMAnimationType * type = [MMAnimationType new];
    type.rotationDirection = rotationDirection;
    return type;
}
MMAnimationType * MMAnimationTypeMakeMoveTo(CGFloat x, CGFloat y){
    MMAnimationType * type = [MMAnimationType new];
    type.x = x;
    type.y = y;
    return type;
}
MMAnimationType * MMAnimationTypeMakeMoveBy(CGFloat x, CGFloat y){
    MMAnimationType * type = [MMAnimationType new];
    type.x = x;
    type.y = y;
    return type;
}
MMAnimationType * MMAnimationTypeMakeScale(struct MMAnimationScale scale){
    MMAnimationType * type = [MMAnimationType new];
    type.scale = scale;
    return type;
}
MMAnimationType * MMAnimationTypeMakeSpin(NSUInteger repeatCount){
    MMAnimationType * type = [MMAnimationType new];
    type.repeatCount = repeatCount;
    return type;
}

MMAnimationType * MMAnimationTypeCompound(NSArray<MMAnimationType *> * animations ,MMAnimationRun run){
    MMAnimationType * type = [MMAnimationType new];
    type.animations = animations;
    type.run = run;
    return type;
}
