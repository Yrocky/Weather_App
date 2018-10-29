//
//  MMAObject.h
//  Weather_App
//
//  Created by user1 on 2018/7/27.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAObject : NSObject

- (void) doSomthing:(int)foo;
@end

@interface MMOtherObject : NSObject
- (id) getAObject;
- (id) getBObject;
@end

@interface MM_Number : NSObject{
    NSUInteger _number;
}
@property (nonatomic ,assign ,readonly) NSUInteger number;

+ (instancetype) number:(NSUInteger)number;
- (MM_Number *(^)(NSUInteger number))add;
+ (MM_Number *(^)(NSUInteger number))number;
@end

@interface NSNumber (MM_Math)
- (NSNumber *(^)(NSUInteger number))add;
- (NSNumber *(^)(NSUInteger number))minus;
@end
