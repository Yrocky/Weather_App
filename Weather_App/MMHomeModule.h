//
//  MMHomeModule.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMHomeComponent.h"
#import "MMHomeSectionComponent.h"

NS_ASSUME_NONNULL_BEGIN

@class YTKRequest;
@protocol MMHomeModuleDelegate;

@interface MMHomeModule : NSObject{
    BOOL _isRefresh;
    NSInteger _index;
    NSInteger _pageSize;
    NSMutableArray<id<MMHomeComponentAble>> *_innerComponents;
}

@property (nonatomic ,copy ,readonly) NSString * name;
/// 能否加载更多，默认为YES
@property (nonatomic ,assign) BOOL shouldLoadMore;

@property (nonatomic ,assign ,readonly) BOOL empty;

@property (nonatomic ,weak) id<MMHomeModuleDelegate> delegate;

@property (readonly, weak, nonatomic, nullable) UICollectionView *collectionView;

- (instancetype) initWithName:(NSString *)name;

- (instancetype) initWithName:(NSString *)name viewController:(nullable __kindof UIViewController *)viewController;

- (void) setupCollectionView:(UICollectionView *)collectionView;

- (void) refresh;///<刷新数据
- (void) loadMore;///<加载下一页

- (void) clear;///<清空已有的全部comp数据

- (void) addComponent:(id<MMHomeComponentAble>)component;
- (void) addComponents:(NSArray<id<MMHomeComponentAble>> *)components;

- (void) replaceComponent:(id<MMHomeComponentAble>)component atIndex:(NSInteger)index;

- (id<MMHomeComponentAble>) componentAtIndex:(NSInteger)index;

- (NSArray<id<MMHomeComponentAble>> *) components;

@end

// 子类重写方法用于业务的处理：请求、解析数据、空态等等
@interface MMHomeModule (SubclassingOverride)

- (__kindof YTKRequest *) fetchModuleRequest;

- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;

- (UIView *) blankPageView;

@end

@protocol MMHomeModuleDelegate <NSObject>

- (void) homeModuleDidSuccessUpdateComponent:(MMHomeModule *)module;
- (void) homeModule:(MMHomeModule *)module didFailUpdateComponent:(NSString *)errorMessage;

@optional

@end

@interface MMCompositeHomeModule : MMHomeModule{
@protected
    NSMutableArray<MMHomeModule *> *_innerModules;
}

- (void) addModule:(MMHomeModule *)module;
- (NSArray<MMHomeModule *> *) modules;

@end

NS_ASSUME_NONNULL_END
