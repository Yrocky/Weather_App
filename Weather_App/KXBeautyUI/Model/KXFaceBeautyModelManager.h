//
//  KXFaceBeautyModelManager.h
//  KXLive
//
//  Created by ydd on 2019/11/6.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KXFaceBeautyModel.h"
@class KXBeautyCellModel;
@class KXFilterCellModel;

NS_ASSUME_NONNULL_BEGIN

#define KXBeautyManager [KXFaceBeautyModelManager shareFaceBeautyModelManager]

@interface KXFaceBeautyModelManager : NSObject

@property (nonatomic, strong) KXFaceBeautyModel *beautyModel;

@property (nonatomic, strong, nullable) NSMutableArray <KXBeautyCellModel *>* beautyArray;

@property (nonatomic, strong, nullable) NSMutableArray <KXFilterCellModel *>* filterArray;

@property (nonatomic, weak) KXFilterCellModel *curfilterModel;

+(KXFaceBeautyModelManager *)shareFaceBeautyModelManager;


- (void)saveCustomModel;

@end

NS_ASSUME_NONNULL_END
