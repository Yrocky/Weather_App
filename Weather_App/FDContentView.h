//
//  FDContentView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDContentView : UIView

// 设置内容视图的高度
- (void) modifContentViewHeight:(CGFloat)height;

// 为CollectionView设置数据源和代理
- (void) configCollectionView:(void(^)(UICollectionView *collectionView))handle;
@end
