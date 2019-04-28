//
//  MMDelegateService.m
//  Weather_App
//
//  Created by user1 on 2018/8/13.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMDelegateService.h"

@interface NSInvocation(ReturnType)
@end

@implementation NSInvocation (ReturnType)

- (BOOL)methodReturnTypeIsVoid
{
    return (([self.methodSignature methodReturnLength] == 0) ? YES : NO);
}

@end

@interface MMDelegateService()

/*A PointerArray acts like a traditional array that slides elements on insertion or deletion.
Unlike traditional arrays, it holds NULLs, which can be inserted or extracted (and contribute to count).
Also unlike traditional arrays, the 'count' of the array may be set directly.
Using NSPointerFunctionsWeakMemory object references will turn to NULL on last release.

The copying and archiving protocols are applicable only when NSPointerArray is configured for Object uses.
The fast enumeration protocol (supporting the for..in statement) will yield NULLs if present.  It is defined for all types of pointers although the language syntax doesn't directly support this.
 
 和传统的数组一样，在插入和删除元素的时候才会移动，不同的是，他可以持有null，并且他可以直接设置count属性，
 使用 NSPointerFunctionsWeakMemory 初始化的对象可以对数据进行弱引用，
 使用 strongObjectsPointerArray 初始化的对象可以对数据进行强引用，和NSArray差不多*/

@property (nonatomic, strong) NSPointerArray *mutableDelegates;
@end

@implementation MMDelegateService

- (instancetype)initWithDelegates:(NSArray *)delegates{
    
    _mutableDelegates = [NSPointerArray weakObjectsPointerArray];
    [delegates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_mutableDelegates addPointer:(void *)obj];
    }];
    
    return self;
}

- (void)addDelegate:(id)delegate{
    
    NSParameterAssert(delegate);
    [self.mutableDelegates addPointer:(void *)delegate];
}

- (void)removeDelegate:(id)delegate{
    
    NSParameterAssert(delegate);
    NSUInteger index = 0;
    for (id aDelegate in self.mutableDelegates) {
        if (aDelegate == delegate){
            [self.mutableDelegates removePointerAtIndex:index];
//            break;
        }
        index ++;
    }
}

- (NSArray *)delegates{
    return [self.mutableDelegates allObjects];
}

#pragma mark - NSProxy

// `-forwardInvocation:`
// `-performSelector:withObject:`
- (void)forwardInvocation:(NSInvocation *)invocation
{
    // If the invoked method return void I can safely call all the delegates
    // otherwise I just invoke it on the first delegate that
    // respond to the given selector
    // 如果是有返回值的方法，就选第一个对象进行返回
    // 否则就遍历所有的代理，统一调用代理协议
    if ([invocation methodReturnTypeIsVoid]) {
        for (id delegate in self.mutableDelegates) {
            if ([delegate respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:delegate];
            }
        }
    } else {
        // 主要是为了解决菱形问题
        id firstResponder = [self p_firstResponderToSelector:invocation.selector];
        [invocation invokeWithTarget:firstResponder];
    }
}

// 记录方法的`返回值`和`参数的类型`信息
// 如果一个类中有3个方法，那么他就会有三个方法签名，通过方法(SEL)就可以得到对应的签名(Signature)
// `-methodSignatureForSelector:`
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    id firstResponder = [self p_firstResponderToSelector:sel];
    if (firstResponder) {
        return [firstResponder methodSignatureForSelector:sel];
    }
    return nil;
}

#pragma mark - NSObject

- (BOOL)respondsToSelector:(SEL)aSelector
{
    id firstResponder = [self p_firstResponderToSelector:aSelector];
    return (firstResponder ? YES : NO);
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    id firstConformed = [self p_firstConformedToProtocol:aProtocol];
    return (firstConformed ? YES : NO);
}

#pragma mark - Private

- (id)p_firstResponderToSelector:(SEL)aSelector
{
    for (id delegate in self.mutableDelegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return delegate;
        }
    }
    return nil;
}

- (id)p_firstConformedToProtocol:(Protocol *)protocol
{
    for (id delegate in self.mutableDelegates) {
        if ([delegate conformsToProtocol:protocol]) {
            return delegate;
        }
    }
    return nil;
}
@end
