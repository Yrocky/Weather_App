//
//  QLLiveModuleDataSourceAble.h
//  BanBanLive
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QLLiveComponent;

@protocol QLLiveModuleDataSourceAble <NSObject>

- (__kindof UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass
                                                 forComponent:(__kindof QLLiveComponent *)component
                                                      atIndex:(NSInteger)index;

- (__kindof UICollectionViewCell *)dequeueReusablePlaceholdCellOfClass:(Class)cellClass
                                                          forComponent:(__kindof QLLiveComponent *)component;

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                                 forComponent:(__kindof QLLiveComponent *)component
                                                                        clazz:(Class)viewClass
                                                                      atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
