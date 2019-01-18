//
//  MMAnimationType.h
//  Weather_App
//
//  Created by meme-rocky on 2018/11/28.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger , MMAnimationTypes) {
    MMAnimationTypeNone,
    MMAnimationTypeSlide,
    MMAnimationTypeSqueeze,
    MMAnimationTypeSlideFade,
    MMAnimationTypeSqueezeFade,
    MMAnimationTypeFade,
    MMAnimationTypeZoom,
    MMAnimationTypeZoomInvert,
    MMAnimationTypeShake,
    MMAnimationTypePop,
    MMAnimationTypeSquash,
    MMAnimationTypeFlip,
    MMAnimationTypeMorph,
    MMAnimationTypeFlash,
    MMAnimationTypeWobble,
    MMAnimationTypeSwing,
    MMAnimationTypeRotate,
    MMAnimationTypeMoveTo,
    MMAnimationTypeMoveBy,
    MMAnimationTypeScale,
    MMAnimationTypeSpin,
    MMAnimationTypeCompound
};

typedef NS_ENUM(NSUInteger , MMAnimationFadeWay) {
    MMAnimationFadeWayIn,
    MMAnimationFadeWayOut,
    MMAnimationFadeWayInOut,
    MMAnimationFadeWayOutIn
};

typedef NS_ENUM(NSUInteger , MMAnimationWay) {
    MMAnimationWayIn,
    MMAnimationWayOut
};

typedef NS_ENUM(NSUInteger , MMAnimationAxis) {
    MMAnimationWayAxisX,
    MMAnimationWayAxisY
};

typedef NS_ENUM(NSUInteger , MMAnimationDirection) {
    MMAnimationWayDirectionLeft,
    MMAnimationWayDirectionRight,
    MMAnimationWayDirectionUp,
    MMAnimationWayDirectionDown
};

typedef NS_ENUM(NSUInteger , MMAnimationRotationDirection) {
    MMAnimationWayRotationDirectionCW,
    MMAnimationWayRotationDirectionCCW,
};

typedef NS_ENUM(NSUInteger , MMAnimationRun) {
    MMAnimationWayRunSequential,///<顺序执行
    MMAnimationWayRunParallel,///<并行执行
};

struct MMAnimationScale {
    CGFloat fromX;
    CGFloat fromY;
    CGFloat toX;
    CGFloat toY;
};
typedef struct MMAnimationScale MMAnimationScale;

NS_INLINE struct MMAnimationScale
MMAnimationScaleMake(CGFloat fromX ,CGFloat fromY ,CGFloat toX ,CGFloat toY){
    struct MMAnimationScale scale;
    scale.fromX = fromX; scale.fromY = fromY;
    scale.toX = toX; scale.toY = toY;
    return scale;
}

@interface MMAnimationType : NSObject

@property (nonatomic ,assign) MMAnimationTypes type;

@property (nonatomic ,assign) MMAnimationWay way;
@property (nonatomic ,assign) MMAnimationFadeWay fadeWay;
@property (nonatomic ,assign) MMAnimationDirection direction;
@property (nonatomic ,assign) NSUInteger repeatCount;
@end

@interface MMAnimationType (Flip)
@property (nonatomic ,assign) MMAnimationAxis along;
@end

@interface MMAnimationType (Rotate)
@property (nonatomic ,assign) MMAnimationRotationDirection rotationDirection;
@end

@interface MMAnimationType (Move)
@property (nonatomic ,assign) CGFloat x;
@property (nonatomic ,assign) CGFloat y;
@end

@interface MMAnimationType (Scale)
@property (nonatomic ,assign) struct MMAnimationScale scale;
+ (instancetype) scaleToX:(CGFloat)x y:(CGFloat)y;
+ (instancetype) scaleFromX:(CGFloat)x y:(CGFloat)y;
@end

@interface MMAnimationType (Compound)
@property (nonatomic ,copy) NSArray<MMAnimationType *> * animations;
@property (nonatomic ,assign) MMAnimationRun run;
@end

extern MMAnimationType * MMAnimationTypeMakeSlide(MMAnimationWay way, MMAnimationDirection direction);
extern MMAnimationType * MMAnimationTypeMakeSqueeze(MMAnimationWay way, MMAnimationDirection direction);
extern MMAnimationType * MMAnimationTypeMakeSlideFade(MMAnimationWay way, MMAnimationDirection direction);
extern MMAnimationType * MMAnimationTypeMakeSqueezeFade(MMAnimationWay way, MMAnimationDirection direction);
extern MMAnimationType * MMAnimationTypeMakeFade(MMAnimationFadeWay fadeWay);
extern MMAnimationType * MMAnimationTypeMakeZoom(MMAnimationWay way);
extern MMAnimationType * MMAnimationTypeMakeZoomInvert(MMAnimationWay way);
extern MMAnimationType * MMAnimationTypeMakeShake(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakePop(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeSquash(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeFlip(MMAnimationAxis along);
extern MMAnimationType * MMAnimationTypeMakeMorph(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeFlash(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeWobble(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeSwing(NSUInteger repeatCount);
extern MMAnimationType * MMAnimationTypeMakeRotate(MMAnimationRotationDirection rotationDirection);
extern MMAnimationType * MMAnimationTypeMakeMoveTo(CGFloat x, CGFloat y);
extern MMAnimationType * MMAnimationTypeMakeMoveBy(CGFloat x, CGFloat y);
extern MMAnimationType * MMAnimationTypeMakeScale(struct MMAnimationScale scale);
extern MMAnimationType * MMAnimationTypeMakeSpin(NSUInteger repeatCount);

extern MMAnimationType * MMAnimationTypeMakeCompound(NSArray<MMAnimationType *> * animations ,MMAnimationRun run);

NS_ASSUME_NONNULL_END
