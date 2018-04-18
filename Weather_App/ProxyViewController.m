//
//  ProxyViewController.m
//  Weather_App
//
//  Created by user1 on 2018/4/18.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "ProxyViewController.h"
#import <objc/runtime.h>

@interface MMProxyA : NSProxy
@property (nonatomic, strong) id target;
- (nullable id)valueForKey:(NSString *)key;
@end
@implementation MMProxyA
- (id)initWithObject:(id)object {
    self.target = object;
    return self;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}
- (nullable id)valueForKey:(NSString *)key{
    return [self.target valueForKey:key];
}
@end

@interface MMProxyB : NSObject
@property (nonatomic, strong) id target;
@end
@implementation MMProxyB
- (id)initWithObject:(id)object {
    self = [super init];
    if (self) {
        self.target = object;
    }
    return self;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}
@end

@interface MMTarget : UIButton
@end
@implementation MMTarget
- (void)dealloc
{
    NSLog(@"MMTarget is dealloc");
}
@end


#pragma mark - 多继承

@protocol MMMobike <NSObject>
- (void) rideBikeTo:(NSString *)destination;
@end

@interface MMMobike : NSObject<MMMobike>
@end

@implementation MMMobike
- (void) rideBikeTo:(NSString *)destination{
    NSLog(@"use Mobike to %@",destination);
}
@end

@protocol MMMeituanFood <NSObject>
- (void) eat:(NSString *)food;
@end

@interface MMMeituanFood : NSObject<MMMeituanFood>
@end

@implementation MMMeituanFood
- (void) eat:(NSString *)food{
    NSLog(@"use Meituan eat %@",food);
}
@end

@interface MMMeituan : NSProxy<MMMeituanFood,MMMobike>{
    MMMeituanFood * _meituan;
    MMMobike * _mobike;
    NSMutableDictionary * _methodsMap;
}
@end

@implementation MMMeituan

- (instancetype)init{
    _methodsMap = [NSMutableDictionary dictionary];
    _meituan = [[MMMeituanFood alloc] init];
    _mobike = [[MMMobike alloc] init];
    
    //映射target及其对应方法名
    [self mm_registMethodsWithTarget:_meituan];
    [self mm_registMethodsWithTarget:_mobike];
    
    return self;
}

- (void) mm_registMethodsWithTarget:(id)target{
    
    unsigned int numberOfMethods = 0;
    
    //获取target的所有方法列表，因为target都遵守了对应的协议，实现了对应的方法，所以这里可以获取到这些Method
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    
    for (int i = 0; i < numberOfMethods; i ++) {
        //获取方法名
        Method temp_method = method_list[i];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        // 将方法名称作为 key ，目标对象作为 value 使用字典进行存储
        [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    
    free(method_list);
}

#pragma mark - 消息转发机制

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    //获取选择子方法名，由于本类遵守了两个协议，所以这里返回的是：rideBikeTo: 和eat:
    NSString *methodName = NSStringFromSelector(sel);
    
    //在字典中查找对应的target
    id target = _methodsMap[methodName];
    
    //检查target
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    //获取当前选择子
    SEL sel = invocation.selector;
    
    //获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    
    //在字典中查找对应的target
    id target = _methodsMap[methodName];
    
    //检查target
    if (target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }
}
@end

@interface ProxyViewController ()
@property (nonatomic ,strong) MMTarget * targetObject;

@end

@implementation ProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Proxy";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * str = @"this is string";
    MMProxyA * proxy = [[MMProxyA alloc] initWithObject:str];
    MMProxyB * object = [[MMProxyB alloc] initWithObject:str];
    
    NSLog(@"proxy.responds.lenght:%d",[proxy respondsToSelector:@selector(length)]);
    NSLog(@"object.responds.lenght:%d",[object respondsToSelector:@selector(length)]);
    
    NSLog(@"proxy.kind.class:%d",[proxy isKindOfClass:[NSString class]]);
    NSLog(@"object.kind.class:%d",[object isKindOfClass:[NSString class]]);
    
    NSLog(@"proxy.length:%@",[proxy valueForKey:@"length"]);
    //    NSLog(@"object.length:%@",[object valueForKey:@"length"]);
    
    self.targetObject = [[MMTarget alloc] init];
    [self.targetObject addTarget:[[MMProxyA alloc] initWithObject:self] action:@selector(targetObjectDidTouch) forControlEvents:UIControlEventTouchUpInside];
    self.targetObject.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:self.targetObject];
    
    MMMeituan * meituan = [[MMMeituan alloc] init];
    [meituan rideBikeTo:@"shanghai"];
    [meituan eat:@"FKC"];
}


- (void) targetObjectDidTouch{
    NSLog(@"targetObjectDidTouch");
}

@end
