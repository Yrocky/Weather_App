//
//  KXFaceBeautyModel.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KXFaceBeautyModel;
NS_ASSUME_NONNULL_BEGIN

@interface KXFaceBeautyModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger blurType;      // 0清晰磨皮 1重度磨皮 2精细磨皮
@property (nonatomic, assign) double blurLevel;         // 磨皮(0.0 - 6.0)
@property (nonatomic, assign) double whiteLevel;        // 美白
@property (nonatomic, assign) double redLevel;          // 红润
@property (nonatomic, assign) double eyelightingLevel;  // 亮眼
@property (nonatomic, assign) double beautyToothLevel;  // 美牙

@property (nonatomic, assign) NSInteger faceShape;        // 脸型 (0、1、2) 女神：0，网红：1，自然：2， 自定义：4
@property (nonatomic, assign) double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, assign) double thinningLevel;       /**瘦脸 (0~1)*/
/* 小脸 (0~1) */
@property (nonatomic, assign) double smallLevel;

@property (nonatomic, assign) double jewLevel;            /**下巴 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;       /**额头 (0~1)*/
@property (nonatomic, assign) double noseLevel;           /**鼻子 (0~1)*/
@property (nonatomic, assign) double mouthLevel;          /**嘴型 (0~1)*/

@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign) double selectedFilterLevel; /* 选中滤镜的 level*/

@property (nonatomic, assign) CGFloat bailiang1;
@property (nonatomic, assign) CGFloat fennen1;
@property (nonatomic, assign) CGFloat lengsediao1;
@property (nonatomic, assign) CGFloat nuansediao1;
@property (nonatomic, assign) CGFloat xiaoqingxin1;

- (void)setDefaultModel;

@end

NS_ASSUME_NONNULL_END
