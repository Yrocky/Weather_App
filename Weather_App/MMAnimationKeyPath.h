//
//  MMAnimationKeyPath.h
//  Weather_App
//
//  Created by meme-rocky on 2019/1/10.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define __STRING_PROP__(name) + (NSString *)name{\
    return NSStringFromSelector(_cmd);\
}

@interface MMAnimationKeyPath : NSObject

// position
@property (class ,readonly) NSString * postion;
@property (class ,readonly) NSString * postionX;
@property (class ,readonly) NSString * postionY;

// Transforms
@property (class ,readonly) NSString * transform;
@property (class ,readonly) NSString * rotation;
@property (class ,readonly) NSString * rotationX;
@property (class ,readonly) NSString * rotationY;
@property (class ,readonly) NSString * rotationZ;
@property (class ,readonly) NSString * scale;
@property (class ,readonly) NSString * scaleX;
@property (class ,readonly) NSString * scaleY;
@property (class ,readonly) NSString * scaleZ;
@property (class ,readonly) NSString * translation;
@property (class ,readonly) NSString * translationX;
@property (class ,readonly) NSString * translationY;
@property (class ,readonly) NSString * translationZ;

// Stroke
@property (class ,readonly) NSString * strokeEnd;
@property (class ,readonly) NSString * strokeStart;

// Other properties
@property (class ,readonly) NSString * opacity;
@property (class ,readonly) NSString * path;
@property (class ,readonly) NSString * lineWidth;

@end

@interface CABasicAnimation (MMAnimationKeyPath)

@end

@interface CAKeyframeAnimation (MMAnimationKeyPath)

@end
NS_ASSUME_NONNULL_END
