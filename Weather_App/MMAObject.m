//
//  MMAObject.m
//  Weather_App
//
//  Created by user1 on 2018/7/27.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMAObject.h"
#import "MMBObject.h"

@implementation MMAObject
- (void) doSomthing:(int)foo{
    NSLog(@"A doSomthing %d",foo);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![self isKindOfClass:[other class]]) {
        return NO;
    }
    return NO;
}
@end

@implementation MMOtherObject
- (id) getAObject{
    return [MMAObject new];
}
- (id) getBObject{
    return [MMBObject new];
}
@end
@implementation MM_Number

+ (instancetype) number:(NSUInteger)number{
    return [[self alloc] initWithNumber:number];
}

- (instancetype) initWithNumber:(NSUInteger)number{
    self = [super init];
    if (self) {
        _number = number;
    }
    return self;
}
+ (MM_Number *(^)(NSUInteger number))number{
    return ^MM_Number*(NSUInteger number){
        MM_Number * numberObj = [MM_Number number:number];
        return numberObj;
    };
}
- (MM_Number *(^)(NSUInteger number))add{
    return ^MM_Number*(NSUInteger number){
        _number =+ number;
        return self;
    };
}

@end

@implementation NSNumber (MM_Math)

- (NSNumber *(^)(NSUInteger number))add{
    return ^NSNumber*(NSUInteger number){
        return @(self.integerValue + number);
    };
}
- (NSNumber *(^)(NSUInteger number))minus{
    return ^NSNumber*(NSUInteger number){
        return @(self.integerValue - number);
    };
}

@end
