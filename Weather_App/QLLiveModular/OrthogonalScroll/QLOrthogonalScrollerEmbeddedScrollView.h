//
//  QLOrthogonalScrollerEmbeddedScrollView.h
//  BanBanLive
//
//  Created by rocky on 2020/7/7.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol QLHomePreviewCellAble;

@interface QLOrthogonalScrollerEmbeddedScrollView : UICollectionView

@end

@interface QLOrthogonalScrollerEmbeddedCCell : UICollectionViewCell//<
//QLHomePreviewCellAble>

@property (nonatomic ,strong ,readonly) QLOrthogonalScrollerEmbeddedScrollView * orthogonalScrollView;

+ (NSString *) reuseIdentifier;
@end

@interface QLOrthogonalScrollerSectionController: NSObject

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) QLOrthogonalScrollerEmbeddedScrollView *scrollView;
@property (nonatomic) NSInteger sectionIndex;

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(QLOrthogonalScrollerEmbeddedScrollView *)scrollView;

- (__kindof UICollectionViewCell *) dequeueReusableCell:(Class)cellClass
                                    withReuseIdentifier:(NSString *)reuseIdentifier
                                            atIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
