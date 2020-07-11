//
//  MMNumAST.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMAST.h"

NS_ASSUME_NONNULL_BEGIN

@class MMToken;
@interface MMNumAST : MMAST

@property (nonatomic ,strong ,readonly) MMToken * num;

+ (instancetype) numAST:(MMToken *)num;
@end

NS_ASSUME_NONNULL_END
