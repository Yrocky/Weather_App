//
//  ProxyViewController.m
//  Weather_App
//
//  Created by user1 on 2018/4/18.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "ProxyViewController.h"
#import <objc/runtime.h>
#import "YYWeakProxy.h"
#import "MMLinkedList.h"
#import "MMDelegateService.h"

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

@protocol MMMiaoMovie <NSObject>
- (void) watch:(NSString *)movie;
@end

@interface MMMiaoMovie : NSObject<MMMiaoMovie,NSCopying>
@end

@implementation MMMiaoMovie
- (id)copyWithZone:(NSZone *)zone{
    return [[[self class] allocWithZone:zone] init];
}
- (void) watch:(NSString *)movie{
    NSLog(@"use MiaoMovie watch %@",movie);
}
@end

@interface MMMeituan : NSProxy<MMMiaoMovie,MMMobike>{
    MMMiaoMovie * _miaoMovie;
    MMMobike * _mobike;
    NSMutableDictionary * _methodsMap;
}
@end

@implementation MMMeituan

- (instancetype)init{
    _methodsMap = [NSMutableDictionary dictionary];
    _miaoMovie = [[MMMiaoMovie alloc] init];
    _mobike = [[MMMobike alloc] init];
    
    //映射target及其对应方法名
    [self mm_registMethodsWithTarget:_miaoMovie];
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

#pragma mark - KVO
@interface MMKVOClass : NSObject{
    int x;
    int y;
    int z;
}
@property int x;
@property int y;
@property int z;
@end
@implementation MMKVOClass
@synthesize x, y, z;
@end
static NSArray *ClassMethodNames(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++)
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    free(methodList);
    
    return array;
}

static void PrintDescription(NSString *name, id obj)
{
    
    // 获取实例对象的isa类型，也就是元类
    const char *className = object_getClassName(obj);
    Class metaClass = objc_getMetaClass(className);
    
    // 分别打印:
    // 附加信息-name
    // 实例的地址-obj
    // 实例的类名-class_getName([obj class])
    // 实例的isa类名-class_getName(metaClass)
    // 实例的isa实现的方法-[ClassMethodNames(metaClass) componentsJoine...
    NSString *str = [NSString stringWithFormat:
                     @"%@: %@\n\tNSObject class %s\n\tisa class %s\n\timplements methods <%@>",
                     name,
                     obj,
                     class_getName([obj class]),
//                     class_getName(obj->isa),// 现在已经获取不到isa指针了
                     class_getName(metaClass),
                     [ClassMethodNames(metaClass) componentsJoinedByString:@", "]];
    printf("%s\n", [str UTF8String]);
}

@interface MMSuperClass : NSObject
- (void) foo;
@end
@implementation MMSuperClass
+ (void)load{
    NSLog(@"MMSuperClass +load");
}
//+ (void)initialize{
//    NSLog(@"MMSuperClass:%@ +initialize",[self class]);
//}
- (void) foo{
    NSLog(@"MMSuperClass -foo");
}
@end

@interface MMSuperClass(CategoryForLoad)
@end
@implementation MMSuperClass(CategoryForLoad)
+ (void)load{
    NSLog(@"MMSuperClass(CategoryForLoad) +load");
}
+ (void)initialize{
    NSLog(@"MMSuperClass:%@(CategoryForLoad) +initialize",[self class]);
}
@end


@interface MMSubClass : MMSuperClass
@end
@implementation MMSubClass
+ (void)load{
    NSLog(@"MMSubClass +load");
}
//+ (void)initialize{
//NSLog(@"%@ +initialize",[self class]);
//}
- (void) foo{
    NSLog(@"MMSubClass -foo");
}
@end

@interface MMSubClass(CategoryForLoad)
@end
@implementation MMSubClass(CategoryForLoad)
+ (void)load{
    NSLog(@"MMSubClass(CategoryForLoad) +load");
}
//+ (void)initialize{
//    NSLog(@"MMSubClass(CategoryForLoad) +initialize");
//}
@end

@interface MyObject:NSObject
+ (instancetype) factoryMethod_1;
+ (id) factoryMethod_2;
@end

@implementation MyObject
+ (instancetype) factoryMethod_1 {return [[[self class] alloc] init]; }
+ (id) factoryMethod_2 {return [[[self class] alloc] init]; }
@end

@protocol MMDelegateProtocol <NSObject>

- (void) protocolNoneReturnMethod;
- (NSInteger) protocolReturnMethod;
@end

@interface MMTableViewObjective : NSObject

@property (nonatomic ,assign) NSUInteger count;
@property (nonatomic ,weak) id<MMDelegateProtocol>delegate;
- (void) noneReturnMethodInvok;
- (void) returnMethodInvok;
@end

@implementation MMTableViewObjective

- (void) noneReturnMethodInvok{
    if(self.delegate && [self.delegate respondsToSelector:@selector(protocolNoneReturnMethod)]){
        [self.delegate protocolNoneReturnMethod];
    }
}
- (void) returnMethodInvok{
    if(self.delegate && [self.delegate respondsToSelector:@selector(protocolReturnMethod)]){
        self.count = [self.delegate protocolReturnMethod];
    }
    NSLog(@"[proxy] count:%lu",(unsigned long)self.count);
}

@end

@interface MMDelegateA : NSObject<MMDelegateProtocol>
@end
@implementation MMDelegateA

- (void)protocolNoneReturnMethod{
    NSLog(@"[proxy] delegate - a invok");
}
- (NSInteger) protocolReturnMethod{
    return 11;
}
- (NSUInteger) a:(NSInteger)a addB:(NSInteger)b addC:(NSInteger)c{
    return a + b + c;
}

@end
@interface MMDelegateB : NSObject<MMDelegateProtocol>
@end
@implementation MMDelegateB

- (void)protocolNoneReturnMethod{
    NSLog(@"[proxy] delegate - b invok");
}
- (NSInteger) protocolReturnMethod{
    return 22;
}
@end

@interface ProxyViewController ()
@property (nonatomic ,strong) MMTarget * targetObject;
@property (nonatomic ,strong) CADisplayLink * link;

@property (nonatomic ,strong) NSTimer * timer1;
//@property (nonatomic ,strong) NSTimer * timer2;
@property (nonatomic ,weak) NSTimer * timer2;

@property (nonatomic ,strong) NSThread * thread1;
@property (nonatomic ,strong) NSMutableArray * array;
@property (nonatomic ,strong) MMTableViewObjective * obj;
@property (nonatomic ,strong) MMDelegateService * delegateSercive;
@property (nonatomic ,strong) MMDelegateA * a;
@property (nonatomic ,strong) MMDelegateB * b;
@end


@implementation ProxyViewController

- (void)dealloc
{
    [_timer1 invalidate];
    _timer1 = nil;
    
    [_link removeFromRunLoop:[NSRunLoop currentRunLoop]
                     forMode:NSRunLoopCommonModes];
    [_link invalidate];
    NSLog(@"ProxyViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Proxy";
    self.view.backgroundColor = [UIColor whiteColor];

    self.array = [[NSMutableArray alloc] init];
    
    [self mutableDelegate];
//
    if (1) {
        
        MMCycleLinkedList<NSNumber *>* cls = [[MMCycleLinkedList alloc] initWithArray:@[@(0),@(1),@(2)]];
//        [cls insertValue:@(22) atIndex:0];
//        [cls insertValue:@(4) atIndex:4];
//        [cls insertValue:@(88) atIndex:2];
//        [cls insertValue:@(99) atIndex:cls.current.index + 1];
//        NSLog(@"after insert %@",cls);
//        [cls addToBack:@(33)];
//        NSLog(@"after remove all %@",cls);
//        [cls addToFront:@(44)];
//        NSLog(@"after remove all %@",cls);
        //    [cls removeValueAtIndex:4];
        //    NSLog(@"after remove all %@",cls);
//        [cls removeValueAtIndex:5];
//        NSLog(@"after index 0 %@",cls);
        
//        [cls moveToValue:@(1)];
//        [cls moveToIndex:4];
        [cls removeCurrent];
        [cls removeCurrent];
        [cls removeCurrent];
        NSLog(@"++++++++");
    }
    
    MMLinkedList<NSNumber *> * list = [MMLinkedList linkedListWithHead:@0];
    for (NSInteger index = 1; index < 5; index ++) {
        [list addToBack:@(index)];
//        [list addToFront:@(index)];
    }
//    [list removeCurrent];
//    [list removeCurrent];
    return;
    /// 0,1,2,3,4
    [list insertValue:@(11) atIndex:5];
    /// 0,1,2,11,3,4
//    [list printList];
//    NSLog(@"value at index:%@",[list valueAtIndex:3]);
//    [list removeValueAtIndex:2];
    NSLog(@"after remove at 2:%@",list);
//    [list removeValueAtIndex:0];
    NSLog(@"after remove at 0:%@",list);
//    [list removeValueAtIndex:[list count] - 1];
    NSLog(@"after remove at last:%@",list);
    
//    [list addToBack:@(10)];
    NSLog(@"current node:%@",list.currentValue);
    [list moveToIndex:2];
//    [list moveToValue:@(0)];
    [list moveToValue:@(4)];
    NSLog(@"list:%@",list);
    
    if (0) {
        NSLog(@"current:%@",[list currentValue]);// 4
        NSLog(@"next:%@",[list nextValue]);// 3
        NSLog(@"next:%@",[list nextValue]);// 2
        NSLog(@"next:%@",[list nextValue]);// 1
        NSLog(@"next:%@",[list nextValue]);// 0
        NSLog(@"next:%@",[list nextValue]);// nil
    }
    if (0){
        NSLog(@"index 2:%@",[list valueAtIndex:2]);// 2
        NSLog(@"next:%@",[list nextValue]);// 1
        [list removeAll];
    }
    if (0) {
        MMCycleLinkedList<NSNumber *>* cls = [[MMCycleLinkedList alloc] initWithArray:@[@(0),@(1),@(2)]];
        [cls insertValue:@(22) atIndex:2];
        NSLog(@"after remove all %@",cls);
        [cls addToBack:@(33)];
        NSLog(@"after remove all %@",cls);
        [cls addToFront:@(44)];
        NSLog(@"after remove all %@",cls);
    }
    
    NSLog(@"+_+_+");
//
////    [list reverseList];
//    [list insertValue:@(4) atIndex:3];
//    [list printList];
//    NSLog(@"find:%@",[list findValue:@(4)]);
//    id value = [list valueAtIndex:0];
//    value = list[9];// NSFastEnumeration
//
//    for (NSInteger index = 0; index < [list count]; index ++) {
//        NSLog(@"value:%@",[list valueAtIndex:index]);
//    }
//    NSInteger * a,b;
//    a = [[MyObject factoryMethod_1] count];
//    b = [[MyObject factoryMethod_2] count];
    
    
//    [self perfromSelectorInMainThread];
//    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(perfromSelectorInUnMainThread) object:nil];
//    [self.thread1 start];
//    [self timer];
//    [self backgroundTimer];
//    [self loadAndInitialize];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mm_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//    NSLog(@"ProxyViewController %s",__func__);
    
//    [self funcWithCopy];
    [self invocationFunc];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.obj noneReturnMethodInvok];
//    [self.obj returnMethodInvok];
    NSLog(@"obj.count:%ld",self.obj.count);
}

- (void) invocationFunc{
    int a = 1;
    int b = 2;
    int c = 3;
    SEL myMethod = @selector(myLog:param:parm:);
    SEL myMethod2 = @selector(myLog);
    
    self.a = [MMDelegateA new];
    SEL methodForDelegateA = @selector(protocolNoneReturnMethod);
    SEL methodForDelegateASum = @selector(a:addB:addC:);
    if(0){
        // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
        NSMethodSignature *sig = [self.a methodSignatureForSelector:methodForDelegateA];
        // 通过签名初始化
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:self.a];
        [invocation setSelector:methodForDelegateA];
        [invocation invoke];
    }
    // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *sig = [self.a methodSignatureForSelector:methodForDelegateASum];
    // 通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self.a];// argument index is 0
    [invocation setSelector:methodForDelegateASum];// argument index is 1
    [invocation setArgument:&a atIndex:2];
    [invocation setArgument:&b atIndex:3];
    [invocation setArgument:&c atIndex:4];
    [invocation invoke];
    NSUInteger d;
    // 取这个返回值
    [invocation getReturnValue:&d];
    NSLog(@"return value :%lu",(unsigned long)d);
    
    return;
    // 2.FirstViewController *view = self;
    // 2.[invocation setArgument:&view atIndex:0];
    // 2.[invocation setArgument:&myMethod2 atIndex:1];
    // 设置target
    // 1.[invocation setTarget:self];
    // 设置selector
    [invocation setSelector:myMethod];
    // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
    [invocation setArgument:&a atIndex:2];
    [invocation setArgument:&b atIndex:3];
    [invocation setArgument:&c atIndex:4];
    // [invocation retainArguments];
    // 我们将c的值设置为返回值
    [invocation setReturnValue:&c];
//    int d;
    // 取这个返回值
    [invocation getReturnValue:&d];
    NSLog(@"d:%d", d);
}
- (void) mutableDelegate{

    self.a = [MMDelegateA new];
    self.b = [MMDelegateB new];
    self.delegateSercive = [[MMDelegateService alloc] initWithDelegates:@[self.a,self.b]];
    
    self.obj = [[MMTableViewObjective alloc] init];
    self.obj.delegate = self.delegateSercive;
    [self.obj noneReturnMethodInvok];
    [self.obj returnMethodInvok];
}

- (void) funcWithCopy{
    
    NSArray * array = [NSArray arrayWithObjects:[MMMiaoMovie new],[MMMiaoMovie new],[MMMiaoMovie new], nil];
    
    NSMutableArray * mutableArray = [array mutableCopy];
    
    NSArray * array_1 = [mutableArray copy];
    
    NSMutableArray * mutableArray_1 = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
    
    NSArray * array_2 = [array copy];
    
    NSMutableArray * array_3 = [mutableArray mutableCopy];
    

}
- (void) testAlloc{
    
    id obj_1 = [NSArray alloc];
    id obj_2 = [obj_1 init];
    
    id obj_3 = [NSMutableArray alloc];
    id obj_4 = [obj_3 init];
    
    
    
    id obj_5 = [MyObject alloc];
    id obj_6 = [obj_5 init];
}
- (void) backgroundTimer{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addObjectToArray) userInfo:nil repeats:YES];
    self.timer2 = timer;
}
- (void) addObjectToArray{
    for (int i = 1000000; i > 0; i --) {
        [self.array addObject:[MMSuperClass new]];
    }
    NSLog(@"aray.count:%d",self.array.count);
}
- (void) viewDidUnload{
    
    [super viewDidUnload];
    NSLog(@"ProxyViewController %s",__func__);
}

- (void) loadView{
    [super loadView];
    NSLog(@"ProxyViewController %s",__func__);
}


- (void) mm_didReceiveMemoryWarning{
    [self.array removeAllObjects];
    NSLog(@"ProxyViewController warning");
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"ProxyViewController override warning");
}

- (void) loadAndInitialize{
    
    MMSuperClass * superClass = [[MMSuperClass alloc] init];
    [superClass foo];
    MMSubClass * subClass = [[MMSubClass alloc] init];
    [subClass foo];
    
}
- (void) perfromSelectorInMainThread{
    NSLog(@"in Main-thread invoke -performSelector:");
    NSLog(@"before performSelector:%@",[NSRunLoop currentRunLoop]);
    [self performSelector:@selector(log) withObject:nil afterDelay:2];
    NSLog(@"after performSelector:%@",[NSRunLoop currentRunLoop]);
}

- (void) perfromSelectorInUnMainThread{
    NSLog(@"in unMain-thread invoke -performSelector:");
    NSLog(@"before performSelector:%@",[NSRunLoop currentRunLoop]);
    [self performSelector:@selector(log) withObject:nil afterDelay:2];
    NSLog(@"after performSelector:%@",[NSRunLoop currentRunLoop]);
    [[NSRunLoop currentRunLoop] run];
}

- (void) proxyAndObject{
    
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
    
}
- (void)  MultiTableInheritance{
    
    MMMeituan * meituan = [[MMMeituan alloc] init];
    [meituan rideBikeTo:@"shanghai"];
    [meituan watch:@"Ready Player One"];
    
}
- (void) KVO{
    
    MMKVOClass * a = [MMKVOClass new];
    MMKVOClass * b = [MMKVOClass new];
    MMKVOClass * c = [MMKVOClass new];
    
    [a addObserver:a forKeyPath:@"x" options:0 context:nil];
    [b addObserver:b forKeyPath:@"y" options:0 context:nil];
    
    PrintDescription(@"KVO-a", a);
    PrintDescription(@"KVO-b", b);
    PrintDescription(@"KVO-c", c);
}

- (void) timer{
    
    
    //    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(log)];
    //    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
//    self.timer1 = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer1");
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSDefaultRunLoopMode];
    
//    __weak typeof(self) weakSelf = self;
//    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(log) userInfo:nil repeats:YES];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(log) userInfo:nil repeats:YES];
    self.timer2 = timer;
    
//    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(performTask) object:nil];
//    [self.thread1 start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (int i = 1000000; i > 0; i --) {
        [self.array addObject:[MMSuperClass new]];
    }
    NSLog(@"aray.count:%d",self.array.count);
//    [self.thread1 cancel];
//    [self.timer1 invalidate];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
// 非main-thread中
- (void)performTask {
    // 使用下面的方式创建定时器虽然会自动加入到当前线程的RunLoop中，但是除了主线程外其他线程的RunLoop默认是不会运行的，必须手动调用
    __weak typeof(self) weakSelf = self;
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([NSThread currentThread].isCancelled) {
            [weakSelf.timer1 invalidate];
        }
        NSLog(@"timer1...");
    }];
    
    // 非主线程RunLoop必须手动调用 run ,当前线程为：self.thread1
    [[NSRunLoop currentRunLoop] run];
    
    // 这个log只有在当前线程的runloop执行完成之后才会进行打印，这就是说，runloop就是一个do-while循环
    NSLog(@"注意：如果RunLoop不退出（运行中），这里的代码并不会执行，RunLoop本身就是一个循环");
}

- (void) log{
    NSLog(@"%@",[NSThread currentThread]);
}
- (void) targetObjectDidTouch{
    NSLog(@"targetObjectDidTouch");
}

@end
