//
//  KXFaceBeautyModel.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXFaceBeautyModel.h"
#import "FUManager.h"
#import <objc/runtime.h>

@implementation KXFaceBeautyModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)setDefaultModel
{
    self.blurType = 2;
    self.blurLevel = 1.0;
    self.whiteLevel = 0.7;        // 美白
    self.redLevel = 0.6;          // 红润
    self.eyelightingLevel = 0.8;      // 亮眼
    self.beautyToothLevel = 0.5;  // 美牙
    self.faceShape = 4;           // 脸型 (0、1、2) 女神：0，网红：1，自然：2， 自定义：4
    self.enlargingLevel = 0.6;   /**大眼 (0~1)*/
    self.smallLevel = 0.2;         // 小脸
    self.jewLevel = 0.5;         /**下巴 (0~1)*/
    self.foreheadLevel = 0.5;    /**额头 (0~1)*/
    self.noseLevel = 0.5;        /**鼻子 (0~1)*/
    self.mouthLevel = 0.5;      /**嘴型 (0~1)*/
    self.selectedFilter = @"origin"; // 原图滤镜
    self.selectedFilterLevel = 0.5;
    
    self.bailiang1 = 0.5;
    self.fennen1 = 0.5;
    self.lengsediao1 = 0.5;
    self.nuansediao1 = 0.5;
    self.xiaoqingxin1 = 0.5;
    
}


// 使用 runtime 遍历 model 的所有属性
+ (void)goThroughAllProperty:(id)object propertyBlock:(void(^)(NSString *propertyName))propertyBlcok {
  u_int count;
  objc_property_t *propertyList = class_copyPropertyList([object class], &count);
  for (int i = 0; i < count; i++) {
    const char *propertyChar = property_getName(propertyList[i]);
    NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
    if (propertyBlcok) {
      propertyBlcok(propertyName);
    }
  }
  free(propertyList);
}

#pragma mark NSCoding protocol
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
  __weak typeof(self) weakself = self;
  [[self class] goThroughAllProperty:self propertyBlock:^(NSString *propertyName) {
    id value = [weakself valueForKey:propertyName];
    [aCoder encodeObject:value forKey:propertyName];
  }];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    __weak typeof(self) weakself = self;
    [[self class] goThroughAllProperty:self propertyBlock:^(NSString *propertyName) {
       id value = [aDecoder decodeObjectForKey:propertyName];
       if (value != nil) {
            [weakself setValue:value forKey:propertyName];
        }
    }];
  }
  return self;
}

- (void)setBlurLevel:(double)blurLevel
{
    _blurLevel = blurLevel;
    switch ([FUManager shareManager].blurType) {
        case 0:
            [FUManager shareManager].blurLevel_0 = blurLevel;
            break;
        case 1:
            [FUManager shareManager].blurLevel_1 = blurLevel;
            break;
        case 2:
            [FUManager shareManager].blurLevel_2 = blurLevel;
            break;
        default:
            break;
    }
}

- (void)setRedLevel:(double)redLevel
{
    _redLevel = redLevel;
    [FUManager shareManager].redLevel = redLevel;
}

- (void)setWhiteLevel:(double)whiteLevel
{
    _whiteLevel = whiteLevel;
    [FUManager shareManager].whiteLevel = whiteLevel;
}

- (void)setEyelightingLevel:(double)eyelightingLevel
{
    _eyelightingLevel = eyelightingLevel;
    [FUManager shareManager].eyelightingLevel = eyelightingLevel;
}

- (void)setBeautyToothLevel:(double)beautyToothLevel
{
    _beautyToothLevel = beautyToothLevel;
    [FUManager shareManager].beautyToothLevel = beautyToothLevel;
}

- (void)setFaceShape:(NSInteger)faceShape
{
    _faceShape = faceShape;
    [FUManager shareManager].faceShape = faceShape;
}

- (void)setEnlargingLevel:(double)enlargingLevel
{
    _enlargingLevel = enlargingLevel;
    [FUManager shareManager].enlargingLevel = enlargingLevel;
}

- (void)setThinningLevel:(double)thinningLevel
{
    _thinningLevel = thinningLevel;
    [FUManager shareManager].thinningLevel = thinningLevel;
}

- (void)setSmallLevel:(double)smallLevel
{
    _smallLevel = smallLevel;
    [FUManager shareManager].smallLevel = smallLevel;
}


- (void)setJewLevel:(double)jewLevel
{
    _jewLevel = jewLevel;
    [FUManager shareManager].jewLevel = jewLevel;
}

- (void)setForeheadLevel:(double)foreheadLevel
{
    _foreheadLevel = foreheadLevel;
    [FUManager shareManager].foreheadLevel = foreheadLevel;
}

- (void)setNoseLevel:(double)noseLevel
{
    _noseLevel = noseLevel;
    [FUManager shareManager].noseLevel = noseLevel;
}

- (void)setMouthLevel:(double)mouthLevel
{
    _mouthLevel = mouthLevel;
    [FUManager shareManager].mouthLevel = mouthLevel;
}

- (void)setSelectedFilter:(NSString *)selectedFilter
{
    _selectedFilter = selectedFilter;
    [FUManager shareManager].selectedFilter = selectedFilter;
}

- (void)setSelectedFilterLevel:(double)selectedFilterLevel
{
    _selectedFilterLevel = selectedFilterLevel;
    [FUManager shareManager].selectedFilterLevel = selectedFilterLevel;
    NSString *filter = [FUManager shareManager].selectedFilter;
    if (filter && ![filter isEqualToString:@"origin"]) {
        [self setValue:@(selectedFilterLevel) forKey:filter];
    }
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
