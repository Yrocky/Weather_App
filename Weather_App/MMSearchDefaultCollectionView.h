//
//  MMSearchDefaultCollectionView.h
//  memezhibo
//
//  Created by user1 on 2017/7/12.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSearchHistoryDatasIdentifier;

@interface MM_SearchDefaultRowLayoutAttribute : NSObject

@property (nonatomic ,strong) id rowData;
@property (nonatomic ,getter=isRegularSizeForItem) BOOL regularSizeForItem;

@property (nonatomic) UIEdgeInsets insetForSection;// 用于计算最大宽度

@property (nonatomic) CGSize sizeForItem;

@property (nonatomic) NSUInteger linenumber;// 在显示的时候是第几行

/**
 *  根据数据动态的改变sizeForItem
 */
- (void) regularSizeForItem;
@end

/**
 *  用来表征不同section下的CCell的显示效果
 包括itemSize、insetForSection、minimumLineSpacing、minimumInteritemSpacing、sizeForHeader、sizeForFooter
 */
@interface MM_SearchDefaultSectionLayoutAttribute : NSObject{
    
    NSMutableArray * _defaultRowAttributes;
    NSArray * _allRowAttributes;
}

@property (nonatomic ,strong ,readonly) NSArray * rowAttributes;

@property (nonatomic) UIEdgeInsets insetForSection;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize sizeForHeader;
@property (nonatomic) CGSize sizeForFooter;

@property (nonatomic) BOOL open;// 为了可以折叠section而加的
@property (nonatomic ,assign) NSUInteger normalLinenumber;// 折叠的时候显示的行数

@property (nonatomic ,getter=isRegularSizeForItem) BOOL regularSizeForItem;

- (void) configSectionLayoutWith:(NSArray *)array;
- (void) modifySectionLayoutAttributesBeforeReloadData;
@end

/**
 *  CollectionView的布局代理，根据attribute来决定展示效果
 */
@interface MM_SearchDefaultLayoutDelegate : NSObject<UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong ,readonly) NSArray * layoutAttributes;
@property (nonatomic ,copy) void(^bCollectionViewDidSelectAt)(NSIndexPath *indexPath);

// 布局
- (void) addSectionAttributes:(NSArray <MM_SearchDefaultSectionLayoutAttribute *>*)attributes;
- (void) addSectionAttribute:(MM_SearchDefaultSectionLayoutAttribute *)attribute;
- (void) removeSectionAttributeAt:(NSInteger)index;

@end

@class MM_SearchDefaultCollectionView;

@protocol MMSearchDefaultCollectionViewDelegate <NSObject>
// 清空搜索历史
- (void) searchDefaultCollectionViewDidCleanSearchHistory:(MM_SearchDefaultCollectionView *)collectionView;
// 点击某一个cell
- (void) searchDefaultCollectionView:(MM_SearchDefaultCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewLeftAlignedLayout : UICollectionViewFlowLayout

@end

/**
 *  Just a convenience protocol to keep things consistent.
 *  Someone could find it confusing for a delegate object to conform to UICollectionViewDelegateFlowLayout
 *  while using UICollectionViewLeftAlignedLayout.
 */
@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end

@interface MM_SearchDefaultCollectionView : UICollectionView<UICollectionViewDataSource>

@property (nonatomic ,weak) id<MMSearchDefaultCollectionViewDelegate>handleDelegate;

@property (nonatomic ,strong ,readonly) MM_SearchDefaultLayoutDelegate * layoutDelegate;

@property (nonatomic, strong) NSArray <NSString *>*historyArray;// 搜索历史
@property (nonatomic, strong) NSArray <NSString *>*labelArray;// 标签
@property (nonatomic, strong) NSArray *recommandArray; //热门推荐

@end
