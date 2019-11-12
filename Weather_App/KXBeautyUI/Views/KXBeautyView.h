//
//  KXBeautyView.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KXBeautyCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyView : UIView

- (void)reloadData:(NSArray <KXBeautyCellModel*>*)dataArr;

@end

NS_ASSUME_NONNULL_END
