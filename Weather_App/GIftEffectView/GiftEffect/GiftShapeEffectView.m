//
//  GiftShapeEffectView.m
//  test1
//
//  Created by pengbo.sui on 16/1/18.
//  Copyright © 2016年 pengbo.sui. All rights reserved.
//

#import "GiftShapeEffectView.h"
#import "XMLReader.h"

#define DEFAULT_FPS 4
#define ORIGIN_WIDTH 720
#define FRAME_COUNT 100
#define ALPHA_FRAME_COUNT (FRAME_COUNT / 2)

static NSString * const kAnimationDelayDismissKey = @"kAnimationDelayDismissKey";

@interface Shape : NSObject
@property (nonatomic) float currentX;
@property (nonatomic) float currentY;
@property (nonatomic) float endX;
@property (nonatomic) float endY;
@property (nonatomic) float sx;
@property (nonatomic) float sy;
@end

@implementation Shape

@end

@interface GiftShapeEffectView ()
{
    BOOL requestStop;
}
@property (nonatomic, strong) NSDictionary *effectMap;
@property (nonatomic, strong) NSMutableArray *shapeList;
@property (nonatomic, strong) NSMutableArray *viewList;
@property (nonatomic) BOOL isRunning;
@end

@implementation GiftShapeEffectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initPoints:(EFFECT_TYPE)type{
    self.shapeList = [[NSMutableArray alloc] init];
    NSArray *keyArr = @[@"EFFECT_TYPE_NONE",@"EFFECT_TYPE_50",@"EFFECT_TYPE_100",@"EFFECT_TYPE_300",@"EFFECT_TYPE_520",@"EFFECT_TYPE_1000",@"EFFECT_TYPE_1314",@"EFFECT_TYPE_3344",@"EFFECT_TYPE_9999"];
    __block BOOL hasExist = NO;
    NSString *keyStr = keyArr[type];
    
//    [self.dataManager.dictMShape enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obj, BOOL * _Nonnull stop) {
//        if ([key isEqualToString:keyStr]) {
//            [self.shapeList addObjectsFromArray:obj];
//            hasExist = YES;
//            *stop = hasExist;
//        }
//    }];
    
    if (!hasExist) {
        NSString *name = [self.effectMap objectForKey:[NSNumber numberWithInt:type]];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error = [[NSError alloc] init];
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        NSDictionary *pointsDict = [[dict objectForKey:@"gift_shape"] objectForKey:@"points"];
        NSString *left = [pointsDict objectForKey:@"left"];
        NSString *ratio = [pointsDict objectForKey:@"ratio"];
        NSArray *points = [pointsDict objectForKey:@"point"];
        
        CGPoint viewCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        int minX = -1;
        int minY = -1;
        int maxX = -1;
        int maxY = -1;
        
        float widthRatio = (float)CGRectGetWidth(self.frame) / ORIGIN_WIDTH;
        float fps = ((float)CGRectGetWidth(self.frame) / 375) * DEFAULT_FPS;
        @autoreleasepool{
            for (NSDictionary *point in points) {
                Shape *shape = [[Shape alloc] init];
                
                NSString *endX = [point objectForKey:@"x"];
                NSString *endY = [point objectForKey:@"y"];
                shape.endX = endX.intValue * ratio.floatValue * widthRatio + left.intValue;
                shape.endY = endY.intValue * ratio.floatValue * widthRatio;
                
                
                if (minX == -1) {
                    minX = shape.endX;
                }
                
                minX = MIN(minX, shape.endX);
                maxX = MAX(maxX, shape.endX);
                
                if (minY == -1) {
                    minY = shape.endY;
                }
                minY = MIN(minY, shape.endY);
                maxY = MAX(maxY, shape.endY);
                
                [self.shapeList addObject:shape];
            }
        }
        
        int pointX = (minX + maxX) / 2;
        int pointY = (minY + maxY) / 2;
        @autoreleasepool{
            for (Shape *shape in self.shapeList) {
                shape.currentX = pointX;
                shape.currentY = pointY;
                float dx = shape.endX - pointX;
                float dy = shape.endY - pointY;
                
                float half = 180;
                
                float degrees = (float)(atan2(dy, dx))*half / M_PI;
                shape.sx = (float)(fps * cos(degrees*M_PI/half));
                shape.sy = (float)(fps * sin(degrees*M_PI/half));
                
                shape.endX += viewCenter.x - pointX;
                shape.endY += viewCenter.y - pointY;
                shape.currentX = viewCenter.x;
                shape.currentY = viewCenter.y;
            }
        }
//        [self.dataManager.dictMShape setObject:self.shapeList.copy forKey:keyStr];
    }
}

-(NSDictionary *)effectMap {
    if (_effectMap == nil) {
        _effectMap = @{
                       // 10个的效果
                       [NSNumber numberWithInt:EFFECT_TYPE_50]:@"smile_face",
                       [NSNumber numberWithInt:EFFECT_TYPE_100]:@"heart",
                       [NSNumber numberWithInt:EFFECT_TYPE_300]:@"double_heart",
                       [NSNumber numberWithInt:EFFECT_TYPE_520]:@"love",
                       [NSNumber numberWithInt:EFFECT_TYPE_1000]:@"v",
                       [NSNumber numberWithInt:EFFECT_TYPE_1314]:@"v1314",
                       [NSNumber numberWithInt:EFFECT_TYPE_3344]:@"v3344",
                       [NSNumber numberWithInt:EFFECT_TYPE_9999]:@"v520",
                       };
    }
    
    return _effectMap;
}

-(void)start:(EFFECT_TYPE)type image:(UIImage *)image {
    
    CGPoint viewCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    [[MMGCDTimerManager sharedInstance] cancelTimerWithName:kAnimationDelayDismissKey];
    [self stop:viewCenter image:image];
    [self initPoints:type];
    if (!self.viewList) {
        self.viewList = [NSMutableArray array];
    }
    if (self.viewList.count < self.shapeList.count) {
        NSInteger newImgViewCount = self.shapeList.count - self.viewList.count;
        @autoreleasepool{
            for (int i = 0; i < newImgViewCount; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [self.viewList addObject:imageView];
                [self addSubview:imageView];
                imageView.image = image;
                imageView.frame = CGRectMake(0, 0, 20, 20);
                imageView.center = viewCenter;
            }
        }
    }
    CGFloat lastTime = 0.0;
    @autoreleasepool{
        for (int i = 0; i < self.shapeList.count; i++) {
            UIImageView *view = self.viewList[i];
            view.alpha = 1.f;
            Shape *shape = self.shapeList[i];
            CGPoint point = CGPointMake(shape.endX, shape.endY);
            CGFloat des = 23;//sqrt((view.centerX - point.x) * (view.centerX - point.x) + (view.centerY - point.y) * (view.centerY - point.y))/60.0;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.duration = des;
            animation.removedOnCompletion = NO;
            animation.repeatCount = 1;
            animation.fillMode = kCAFillModeForwards;
            animation.toValue = [NSValue valueWithCGPoint:point];

            [view.layer addAnimation:animation forKey:@"animation"];
            lastTime = MAX(des, lastTime);
        }
    }
    
//    [[MMGCDTimerManager sharedInstance] scheduledDispatchTimerWithName:kAnimationDelayDismissKey timeInterval:(lastTime + 1.f) queue:nil repeats:AbandonPreviousAction actionOption:AbandonPreviousAction action:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            @autoreleasepool{
//                for (int i = 0; i < self.viewList.count; i++) {
//                    UIImageView *view = self.viewList[i];
//                    if (i < self.shapeList.count) {
//                        [UIView animateWithDuration:2.f animations:^{
//                            view.alpha = 0.0f;
//                        }];
//                    }else{
//                        view.alpha = 0.0f;
//                    }
//                }
//            }
//        });
//    }];
}

-(void)stop:(CGPoint)center image:(UIImage *)image{
    @autoreleasepool{
        for (UIImageView *view in self.viewList) {
            view.center = center;
            view.image = image;
            view.alpha = 0;
            [view.layer removeAllAnimations];
        }
    }
    [self.shapeList removeAllObjects];
    self.shapeList = nil;
}

@end
