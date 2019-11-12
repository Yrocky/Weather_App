//
//  KXBeautyCell.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXBeautyCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyCell : UICollectionViewCell

@property (nonatomic, strong) KXBeautyCellModel *beautyModel;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
