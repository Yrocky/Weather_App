//
//  KXBeautyFilterCell.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXFilterCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyFilterCell : UICollectionViewCell

@property (nonatomic, strong) KXFilterCellModel *cellModel;

+ (CGSize)cellSize;

@end

NS_ASSUME_NONNULL_END
