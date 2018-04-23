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

@interface MMMiaoMovie : NSObject<MMMiaoMovie>
@end

@implementation MMMiaoMovie
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

@interface ProxyViewController ()
@property (nonatomic ,strong) MMTarget * targetObject;
@property (nonatomic ,strong) CADisplayLink * link;

@property (nonatomic ,strong) NSTimer * timer1;
//@property (nonatomic ,strong) NSTimer * timer2;
@property (nonatomic ,weak) NSTimer * timer2;

@property (nonatomic ,strong) NSThread * thread1;
@property (nonatomic ,strong) NSMutableArray * array;

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
    
//    [self perfromSelectorInMainThread];
//    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(perfromSelectorInUnMainThread) object:nil];
//    [self.thread1 start];
//    [self timer];
    [self backgroundTimer];
    [self loadAndInitialize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mm_didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    NSLog(@"ProxyViewController %s",__func__);
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
