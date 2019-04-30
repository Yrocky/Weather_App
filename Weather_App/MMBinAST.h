//
//  MMBinAST.h
//  Weather_App
//
//  Created by 洛奇 on 2019/4/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "MMAST.h"

NS_ASSUME_NONNULL_BEGIN

@class MMToken;
@interface MMBinAST : MMAST

@property (nonatomic ,strong ,readonly) MMAST * left;
@property (nonatomic ,strong ,readonly) MMToken * op;///<操作符
@property (nonatomic ,strong ,readonly) MMAST * right;

+ (instancetype) binAST:(MMAST *)left op:(MMToken *)op right:(MMAST *)right;
@end

NS_ASSUME_NONNULL_END
