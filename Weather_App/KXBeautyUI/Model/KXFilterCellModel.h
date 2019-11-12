//
//  KXFilterCellModel.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KXFilterCellModel : KXBeautyCellModel

@property (nonatomic, copy) NSString *filter;

@property (nonatomic, assign) BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
