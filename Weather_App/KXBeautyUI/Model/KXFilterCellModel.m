//
//  KXFilterCellModel.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXFilterCellModel.h"
#import "KXFaceBeautyModelManager.h"

@implementation KXFilterCellModel

- (void)setFilter:(NSString *)filter
{
    _filter = filter;
    if ([filter isEqualToString:@"origin"]) {
        self.name = @"原画";
        self.icon = @"meiyan_lv_yt";
        return;
    }
    if ([filter isEqualToString:@"fennen3"]) {
        self.name = @"人面桃花";
        self.icon = @"";
        return;
    }
    if ([filter isEqualToString:@"lengsediao4"]) {
        self.name = @"清新西柚";
        return;
    }
    if ([filter isEqualToString:@"xiaoqingxin3"]) {
        self.name = @"海街";
        return;
    }
    if ([filter isEqualToString:@"xiaoqingxin6"]) {
        self.name = @"爱丽丝";
        return;
    }
    if ([filter isEqualToString:@"bailiang1"]) {
        self.name = @"你的样子";
        self.icon = @"meiyan_lv_ndyz";
        return;
    }
    if ([filter isEqualToString:@"fennen1"]) {
        self.name = @"粉嫩少女";
        self.icon = @"meiyan_lv_fnsn";
        return;
    }
    if ([filter isEqualToString:@"lengsediao1"]) {
        self.name = @"高冷月光";
        self.icon = @"meiyan_lv_glyg";
        return;
    }
    if ([filter isEqualToString:@"nuansediao1"]) {
        self.name = @"春日的风";
        self.icon = @"meiyan_lv_crdf";
        return;
    }
    
    if ([filter isEqualToString:@"xiaoqingxin1"]) {
        self.name = @"小清新";
        self.icon = @"meiyan_lv_xqx";
        return;
    }
}

- (BOOL)isSelected
{
    return [self.filter isEqualToString:KXBeautyManager.beautyModel.selectedFilter];
}

- (CGFloat)value
{
    if (self.filter) {
        id value = [KXBeautyManager.beautyModel valueForKey:self.filter];
        if (value) {
            return [value floatValue];
        }
    }
    return KXBeautyManager.beautyModel.selectedFilterLevel;
}

@end
