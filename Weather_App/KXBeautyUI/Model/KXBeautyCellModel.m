//
//  KXBeautyCellModel.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyCellModel.h"
#import "FUManager.h"
#import "KXFaceBeautyModelManager.h"

@implementation KXBeautyCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = @"";
        _name = @"";
        _icon = @"";
    }
    return self;
}


- (void)setType:(KXBeautyType *)type
{
    _type = type;
    if ([_type isEqualToString:KXBeautyType_blurLevel]) {
        _name = @"磨皮";
        _icon = @"meiyan_sz_mp";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_whiteLevel]) {
        _name = @"美白";
        _icon = @"meiyan_sz_mb";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_redLevel]) {
        _name = @"红润";
        return;
    }
    if ([type isEqualToString:KXBeautyType_eyelightingLevel]) {
        _name = @"亮眼";
        _icon = @"meiyan_sz_ly";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_beautyToothLevel]) {
        _name = @"美牙";
        _icon = @"meiyan_sz_my";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_enlargingLevel]) {
        _name = @"大眼";
        _icon = @"meiyan_sz_dy";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_smallLevel]) {
        _name = @"小脸";
        _icon = @"meiyan_sz_xl";
        return;
    }
    
    if ([type isEqualToString:KXBeautyType_jewLevel]) {
        _name = @"下巴";
        _icon = @"meiyan_sz_xb";
        _isMidelSlider = YES;
        return;
    }
    if ([type isEqualToString:KXBeautyType_foreheadLevel]) {
        _name = @"额头";
        _icon = @"meiyan_sz_et";
        _isMidelSlider = YES;
        return;
    }
    if ([type isEqualToString:KXBeautyType_noseLevel]) {
        _name = @"瘦鼻";
        _icon = @"meiyan_sz_sb";
        return;
    }
    if ([type isEqualToString:KXBeautyType_mouthLevel]) {
        _name = @"嘴型";
        _icon = @"meiyan_sz_zx";
        _isMidelSlider = YES;
        return;
    }
}


- (void)setValue:(CGFloat)value
{
    _value = value;
       
    if ([_type isEqualToString:KXBeautyType_blurLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.blurLevel = value;
        return;
    }
       
    if ([_type isEqualToString:KXBeautyType_whiteLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.whiteLevel = value;
        return;
    }
       
    if ([_type isEqualToString:KXBeautyType_redLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.redLevel = value;
        return;
    }
    if ([_type isEqualToString:KXBeautyType_eyelightingLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.eyelightingLevel = value;
        return;
    }
       
    if ([_type isEqualToString:KXBeautyType_beautyToothLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.beautyToothLevel = value;
        return;
    }
       
    if ([_type isEqualToString:KXBeautyType_enlargingLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.enlargingLevel = value;
        return;
    }
       
    if ([_type isEqualToString:KXBeautyType_thinningLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.thinningLevel = value;
        return;
    }
    
    if ([_type isEqualToString:KXBeautyType_smallLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.smallLevel = value;
        return;
    }
    
       
    if ([_type isEqualToString:KXBeautyType_jewLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.jewLevel = value;
        return;
    }
    if ([_type isEqualToString:KXBeautyType_foreheadLevel]) {
          [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.foreheadLevel = value;
           return;
       }
    if ([_type isEqualToString:KXBeautyType_noseLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.noseLevel = value;
        return;
    }
    if ([_type isEqualToString:KXBeautyType_mouthLevel]) {
        [KXFaceBeautyModelManager shareFaceBeautyModelManager].beautyModel.mouthLevel = value;
        return;
    }
    if ([_type isEqualToString:KXBeautyType_filter]) {
        KXBeautyManager.beautyModel.selectedFilterLevel = value;
    }
}




@end
