//
//  NSArray+Unretained.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/9.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "NSArray+Unretained.h"

@implementation NSArray (Unretained)

//+ (instancetype) unreatainedArray {
//    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
//    return (id)CFBridgingRelease(CFArrayCreateMutable(0, 0, &callbacks));
//}
//
//- (void)unretainedAddObj:(NSObject *)obj {
//    NSValue *value = [NSValue valueWithNonretainedObject:obj];
//    [self addObject:value];
//}
//
//- (NSObject *)unretainedObjectAtIndex:(NSUInteger)index {
//    NSValue *value = [self objectAtIndex:index];
//    return [value nonretainedObjectValue];
//}

@end

@implementation NSMutableSet (Unretained)

+ (instancetype) unreatainedMutableSet {
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    return (id)CFBridgingRelease(CFSetCreateMutable(0, 0, &callbacks));
}

- (void)unretainedAddObj:(NSObject *)obj {
    NSValue *value = [NSValue valueWithNonretainedObject:obj];
    [self addObject:value];
}

@end
