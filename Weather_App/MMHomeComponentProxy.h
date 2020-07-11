//
//  MMHomeComponentDelegate.h
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MMHomeComponent;
/// 内部用来实现UICollectionViewDelegateFlowLayout、
/// UICollectionViewDataSource相关协议方法的类
/// NOTE: 外部不应该使用该类
@interface MMHomeComponentProxy : NSProxy<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property (nonatomic ,weak ,readonly) MMHomeComponent * currentComponent;

- (instancetype) initWithComponent:(MMHomeComponent *)comp;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
