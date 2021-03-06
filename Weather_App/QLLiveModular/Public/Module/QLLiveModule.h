//
//  QLLiveModule.h
//  BanBanLive
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLiveModuleDataSource.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QLLivePureListModuleType) {
    QLLivePureListModuleReplace,/// 直接替换原有的数据
    QLLivePureListModuleAppend/// 在原有的数据后追加数据
};

@class YTKRequest;
@protocol QLLiveModuleDelegate;

@interface QLLiveModule : NSObject{
    BOOL _isRefresh;
    NSInteger _index;
    NSInteger _pageSize;
    
    QLLiveModuleDataSource *_dataSource;
}

@property (nonatomic ,copy ,readonly) NSString * name;

/// 能否加载更多，默认为YES
@property (nonatomic ,assign) BOOL shouldLoadMore;

@property (nonatomic ,assign ,readonly) BOOL empty;

@property (nonatomic ,weak) id<QLLiveModuleDelegate> delegate;

- (instancetype) initWithName:(NSString *)name;

@property (nonatomic, readonly) UIViewController * viewController;
@property (nonatomic, readonly) UICollectionView * collectionView;

@property (nonatomic ,strong ,readonly) QLLiveModuleDataSource * dataSource;

- (void) refresh;///< 刷新数据
- (void) loadMore;///< 加载下一页

- (void) setupViewController:(UIViewController *)viewController
              collectionView:(UICollectionView *)collectionView;
@end

@interface QLLiveModule (SubclassingOverride)

- (__kindof YTKRequest *) fetchModuleRequest;
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;

- (UIView *) blankPageView;

@end

@interface QLLiveCompositeModule : QLLiveModule

- (void) addModule:(__kindof QLLiveModule *)module;
- (NSArray<__kindof QLLiveModule *> *) modules;

@end

@interface QLLivePureListModule : QLLiveModule

/// 指明类型，替换和追加
- (QLLivePureListModuleType) pureListModuleType;

/// 指明comp的类型
- (Class) pureListComponentClass;

/// 将请求的数据通过该方法过滤，获取comp
- (__kindof QLLiveComponent *) setupPureComponentWithDatas:(NSArray *)datas;
@end

@protocol QLLiveModuleDelegate <NSObject>

- (void) liveModuleDidSuccessUpdateComponent:(QLLiveModule *)module;
- (void) liveModule:(QLLiveModule *)module didFailUpdateComponent:(NSError *)error;
@end


NS_ASSUME_NONNULL_END
