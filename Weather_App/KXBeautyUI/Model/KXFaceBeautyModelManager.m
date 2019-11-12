//
//  KXFaceBeautyModelManager.m
//  KXLive
//
//  Created by ydd on 2019/11/6.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXFaceBeautyModelManager.h"
#import "KXBeautyCellModel.h"
#import "KXFilterCellModel.h"

#define KXSaveFaceBeautyModelKey @"KXSaveFaceBeautyModel"

static KXFaceBeautyModelManager *_beautyManager;

@implementation KXFaceBeautyModelManager

+(KXFaceBeautyModelManager *)shareFaceBeautyModelManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _beautyManager = [[KXFaceBeautyModelManager alloc] init];
    });
    return _beautyManager;
}


- (KXFaceBeautyModel *)beautyModel
{
    if (!_beautyModel) {
        id modelId = [[NSUserDefaults standardUserDefaults] objectForKey:KXSaveFaceBeautyModelKey];
        if (modelId && [modelId isKindOfClass:[NSData class]]) {
          id model = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)modelId];
          if (model && [model isKindOfClass:[KXFaceBeautyModel class]]) {
            _beautyModel = (KXFaceBeautyModel *)model;
          }
        }
        if (!_beautyModel) {
            _beautyModel = [[KXFaceBeautyModel alloc] init];
            [_beautyModel setDefaultModel];
        }
    }
    return _beautyModel;
}

- (void)saveCustomModel
{
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beautyModel];
  if (data) {
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KXSaveFaceBeautyModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (NSMutableArray<KXBeautyCellModel *> *)beautyArray
{
    if (!_beautyArray) {
        _beautyArray = [NSMutableArray array];
        NSArray *array = @[@"blurLevel", @"smallLevel", @"enlargingLevel", @"whiteLevel", @"jewLevel", @"foreheadLevel", @"noseLevel", @"mouthLevel", @"eyelightingLevel", @"beautyToothLevel"];
        for (int i = 0; i < array.count; i++) {
            KXBeautyCellModel *model = [[KXBeautyCellModel alloc] init];
            model.type = array[i];
            model.value = [[self.beautyModel valueForKey:array[i]] floatValue];
            [_beautyArray addObject:model];
        }
    }
    return _beautyArray;
}

- (NSMutableArray<KXFilterCellModel *> *)filterArray
{
    if (!_filterArray) {
        _filterArray = [NSMutableArray array];
        NSArray <NSString *>*array = @[@"origin", /*@"fennen3", @"lengsediao4", @"xiaoqingxin3", @"xiaoqingxin6",*/ @"bailiang1", @"fennen1", @"lengsediao1",@"nuansediao1",@"xiaoqingxin1"];
        for (int i = 0; i < array.count; i++) {
            KXFilterCellModel *model = [[KXFilterCellModel alloc] init];
            model.type = KXBeautyType_filter;
            model.filter = array[i];
            [_filterArray addObject:model];
            if (model.isSelected) {
                self.curfilterModel = model;
            }
        }
    }
    return _filterArray;
}


@end
