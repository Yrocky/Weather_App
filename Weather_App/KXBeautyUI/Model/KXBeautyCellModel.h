//
//  KXBeautyCellModel.h
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KXBeautyType.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KXBeautyCellModel : NSObject

@property (nonatomic, copy) KXBeautyType *type;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isMidelSlider;


@end

NS_ASSUME_NONNULL_END
