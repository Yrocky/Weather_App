//
//  FDCollectionView.h
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,FDCollectionViewMoveDirection) {
    FDCollectionViewMoveNone        = 0,
    FDCollectionViewMoveUp         = 1 << 0,
    FDCollectionViewMoveLeft        = 1 << 1,
    FDCollectionViewMoveDown      = 1 << 2,
    FDCollectionViewMoveRight      = 1 << 3,
};

@protocol FDCollectionViewMoveDirectionDelegate;

@interface FDCollectionView : UICollectionView

@property (nonatomic ,assign ,readonly) FDCollectionViewMoveDirection moveDirection;
@property (nonatomic ,weak) id<FDCollectionViewMoveDirectionDelegate>fd_delegate;
@end


@protocol FDCollectionViewMoveDirectionDelegate <NSObject>

// 向右移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToLeftContentOffset:(CGFloat)offset;
// 向左移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToRightContentOffset:(CGFloat)offset;

// 向上移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToUpContentOffset:(CGFloat)offset;
// 向下移动
- (void) collectionView:(FDCollectionView *)collectionView didMoveToDownContentOffset:(CGFloat)offset;

- (void) collectionViewDidEndMove:(FDCollectionView *)collectionView;
@end
