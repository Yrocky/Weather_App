//
//  QLLiveModelEnvironment.h
//  Weather_App
//
//  Created by rocky on 2020/7/14.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLiveModelEnvironment_Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLLiveModelEnvironment : NSObject<QLLiveModelEnvironment>

@property (nonatomic, weak, readwrite) UIViewController * viewController;
@property (nonatomic, weak, readwrite) UICollectionView * collectionView;

@end

NS_ASSUME_NONNULL_END
