//
//  QLHomeDataSource.h
//  BanBanLive
//
//  Created by rocky on 2020/6/28.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QLLiveComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QLLiveModuleDataSourceAble;

@interface QLLiveModuleDataSource : NSObject<
UICollectionViewDataSource,
UICollectionViewDelegate,
QLLiveModuleDataSourceAble>{
    
    NSMutableArray<__kindof QLLiveComponent *> *_innerComponents;
}

@property (nonatomic, weak, nullable) UIViewController *viewController;
@property (nonatomic, nullable, weak) UICollectionView *collectionView;

@end

@interface QLLiveModuleDataSource (ComponentsHandle)

- (void) clear;///<清空已有的全部comp数据

- (void) addComponent:(__kindof QLLiveComponent *)component;
- (void) addComponents:(NSArray<__kindof QLLiveComponent *> *)components;

- (void) insertComponent:(__kindof QLLiveComponent *)component atIndex:(NSInteger)index;
- (void) replaceComponent:(__kindof QLLiveComponent *)component atIndex:(NSInteger)index;

- (void) removeComponent:(__kindof QLLiveComponent *)component;
- (void) removeComponentAtIndex:(NSInteger)index;

- (__kindof QLLiveComponent *) componentAtIndex:(NSInteger)index;
- (NSInteger) indexOfComponent:(__kindof QLLiveComponent *)comp;

- (NSArray<__kindof QLLiveComponent *> *) components;

- (NSInteger) count;

- (BOOL)empty;
@end

NS_ASSUME_NONNULL_END
