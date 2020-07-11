//
//  MMAnimatableProperty.h
//  Weather_App
//
//  Created by Rocky Young on 2018/11/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAnimatableProperty : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic ,copy ,readonly) NSString * name;
+ (instancetype) propertyWithName:(nullable NSString *)name;
@end

@interface MMMutableAnimatableProperty : MMAnimatableProperty

@property (nonatomic ,copy ,readwrite) NSString * name;
@end
