//
//  QLLiveModelEnvironment_Protocol.h
//  Weather_App
//
//  Created by rocky on 2020/7/14.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QLLiveModelEnvironment <NSObject>
@property (nonatomic, readonly) UIViewController * viewController;
@property (nonatomic, readonly) UICollectionView * collectionView;

- (CGSize) effectiveContentSizeWithInsets:(UIEdgeInsets)insets;
@end

NS_ASSUME_NONNULL_END
