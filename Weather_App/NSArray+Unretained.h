//
//  NSArray+Unretained.h
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Unretained)

+ (instancetype) unreatainedArray;

@end

@interface NSMutableSet (Unretained)

+ (instancetype) unreatainedMutableSet;

- (void) unretainedAddObj:(NSObject *)obj;
@end
NS_ASSUME_NONNULL_END
