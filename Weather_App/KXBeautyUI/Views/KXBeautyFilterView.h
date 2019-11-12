//
//  KXBeautyFilterView.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KXFilterCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyFilterView : UIView

@property (nonatomic, copy) void(^seletedFilterBlock)(KXFilterCellModel *model);

- (void)reloadData:(NSArray <KXFilterCellModel *> *)array;

@end

NS_ASSUME_NONNULL_END
