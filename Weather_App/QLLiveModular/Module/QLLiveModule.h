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

- (instancetype)initWithName:(NSString *)name
              viewController:(nullable UIViewController *)viewController;

@property (nonatomic, weak, nullable) UIViewController *viewController;
@property (nonatomic, weak, nullable) UICollectionView *collectionView;

@property (nonatomic ,strong ,readonly) QLLiveModuleDataSource * dataSource;

- (void) refresh;///< 刷新数据
- (void) loadMore;///< 加载下一页

@end

@interface QLLiveModule (SubclassingOverride)


- (__kindof YTKRequest *) fetchModuleRequest;
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;

- (UIView *) blankPageView;

@end

@interface QLLiveCompositeModule : QLLiveModule{
@protected
    NSMutableArray<__kindof QLLiveModule *> *_innerModules;
}

- (void) addModule:(__kindof QLLiveModule *)module;
- (NSArray<__kindof QLLiveModule *> *) modules;

@end

@protocol QLLiveModuleDelegate <NSObject>

- (void) liveModuleDidSuccessUpdateComponent:(QLLiveModule *)module;
- (void) liveModule:(QLLiveModule *)module didFailUpdateComponent:(NSError *)error;
@end


NS_ASSUME_NONNULL_END
