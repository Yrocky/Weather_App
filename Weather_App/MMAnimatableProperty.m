//
//  MMAnimatableProperty.m
//  Weather_App
//
//  Created by Rocky Young on 2018/11/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMAnimatableProperty.h"

//#define POP_ARRAY_COUNT(x) sizeof(x) / sizeof(x[0])

//static NSUInteger staticIndexWithName(NSString *aName){
//
//    NSUInteger idx = 0;
//
//    while (idx < POP_ARRAY_COUNT(_staticStates)) {
//        if ([_staticStates[idx].name isEqualToString:aName])
//            return idx;
//        idx++;
//    }
//
//    return NSNotFound;
//}

// 单例占位符对象，提供类簇的功能
@interface MMPlaceholdAnimatableProperty : MMAnimatableProperty
@end
@implementation MMPlaceholdAnimatableProperty
@synthesize name;
@end

// 具体的静态类
@interface MMStaticAnimatableProperty : MMAnimatableProperty

@end
@implementation MMStaticAnimatableProperty
@end

// 具体的不可变类，主要用在copy
@interface MMConcreteAnimatableProperty : MMAnimatableProperty
- (instancetype) initWithName:(nullable NSString *)aName;
@end
@implementation MMConcreteAnimatableProperty
@synthesize name;

- (instancetype) initWithName:(nullable NSString *)aName{
    self = [super init];
    if (self) {
        name = [aName copy];
    }
    return self;
}
@end

@implementation MMAnimatableProperty
@synthesize name;

static MMAnimatableProperty * placeholder = nil;
+ (void)initialize{
    if ([self isKindOfClass:[MMAnimatableProperty class]]) {
        placeholder = [[MMPlaceholdAnimatableProperty alloc] init];
    }
}

// alloc方法会走到这，使用单例对象返回，不重复创建对象
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if ([self isKindOfClass:[MMAnimatableProperty class]]) {
        if (nil == placeholder) {// 这里一般来说不会为nil
            placeholder = [super allocWithZone:zone];
        }
        return placeholder;
    }
    return [super allocWithZone:zone];
}

- (id)copyWithZone:(NSZone *)zone{
    
    // 只有 MMMutableAnimatableProperty 执行copy的时候才进行操作
    if ([self isKindOfClass:[MMMutableAnimatableProperty class]]) {
        // 通过init方法将 MMMutableAnimatableProperty 类调用copy的时候将实际上的不可变对象返回
        MMConcreteAnimatableProperty * copyProperty = [[MMConcreteAnimatableProperty alloc] initWithName:self.name];
        return copyProperty;
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    MMMutableAnimatableProperty * copyProperty = [[MMMutableAnimatableProperty alloc] init];
    copyProperty.name = self.name;
    return copyProperty;
}

+ (instancetype) propertyWithName:(nullable NSString *)aName{
    
    MMAnimatableProperty *prop = nil;
    
    static NSMutableDictionary *_propertyDict = nil;
    if (nil == _propertyDict) {
        _propertyDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    prop = _propertyDict[aName];
    if (nil != prop) {// 如果 静态字典 _propertyDict 中有该名字下的property实例对象，直接返回
        return prop;
    }
    
    NSUInteger staticIdx = 0;//= staticIndexWithName(aName);
    
    if (NSNotFound != staticIdx) {
        MMStaticAnimatableProperty *staticProp = [[MMStaticAnimatableProperty alloc] init];
//        staticProp->_state = &_staticStates[staticIdx];
        _propertyDict[aName] = staticProp;
        prop = staticProp;
    } else {
        MMMutableAnimatableProperty *mutableProp = [[MMMutableAnimatableProperty alloc] init];
        mutableProp.name = aName;
        prop = [mutableProp copy];
    }
    
    return prop;
}

@end

@implementation MMMutableAnimatableProperty


@end
