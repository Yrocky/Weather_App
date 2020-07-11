//
//  MMHomeSectionModel.h
//  Weather_App
//
//  Created by rocky on 2020/6/9.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IGListDiffable;
@interface MMHomeSectionModel : NSObject<IGListDiffable>

/// 该section中的数据集合
@property (nonatomic ,copy) NSArray * datas;

@end

NS_ASSUME_NONNULL_END
