//
//  XXXCellLayoutData.h
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "XXXModelAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXCellLayoutData : NSObject

@property (nonatomic ,assign) CGFloat cellWidth;
@property (nonatomic ,assign) CGFloat cellheight;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic ,weak) id<XXXModelAble> metaData;

@end

NS_ASSUME_NONNULL_END
