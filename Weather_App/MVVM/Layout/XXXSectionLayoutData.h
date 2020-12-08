//
//  XXXSectionLayoutData.h
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXCellLayoutData.h"

NS_ASSUME_NONNULL_BEGIN

typedef __kindof XXXCellLayoutData XXXKinfOfLayoutData;

@interface XXXSectionLayoutData : NSObject

@property (nonatomic ,readonly) NSArray<XXXKinfOfLayoutData *> * layoutDatas;

@end

NS_ASSUME_NONNULL_END
