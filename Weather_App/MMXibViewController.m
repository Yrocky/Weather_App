//
//  MMXibViewController.m
//  Weather_App
//
//  Created by user1 on 2017/12/11.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMXibViewController.h"
#import "MMXibCustomView.h"
#import "Masonry.h"
#import "PKProtocolExtension.h"

@protocol MMMoveable <NSObject>
@optional
- (void) move;
@required
- (NSString *) name;
@end

@defs(MMMoveable)

- (void) move{
    NSLog(@"%@ can moveable",self.name);
}
- (NSString *) name{
    return @"default name";
}
@end

@protocol XXXMoveable <MMMoveable>

- (void) run;
@end

@defs(XXXMoveable)

- (void)run{
    NSLog(@"%@ run",self.name);
}
- (NSString *)name {
    return @"XXXMoveable";
}

@end

@protocol OtherProtocol <NSObject>

- (void) exp;
@end

@defs(OtherProtocol)
- (void)exp{
    NSLog(@"exp");
}
@end
@interface MMRocky : NSObject<MMMoveable>

@end

//PKAnnotation(MMRocky)

@implementation MMRocky
- (void) move{
    NSLog(@"imp %@ can moveable",self.name);
}

- (NSString *)name{
    return @"rocky";
}
@end

@interface MMRunloopObserver : NSObject
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end

@implementation MMRunloopObserver

- (void)dealloc{
    [self stop];
}

- (void) stop{
    if (observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
        CFRelease(observer);
        observer = NULL;
    }
}
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"%@",(__bridge MMRunloopObserver*)info);
    
//    PerformanceMonitor *moniotr = (__bridge PerformanceMonitor*)info;
    
//    moniotr->activity = activity;
    
//    dispatch_semaphore_t semaphore = moniotr->semaphore;
//    dispatch_semaphore_signal(semaphore);
}
/*
typedef struct {
    CFIndex    version;
    void *    info;
    const void *(*retain)(const void *info);
    void    (*release)(const void *info);
    CFStringRef    (*copyDescription)(const void *info);
} CFRunLoopObserverContext;
*/
- (void) start{
    
    // context 用来在runloop中进行传递的数据
    // 这里对 CFRunLoopObserverContext 结构体进行创建，将 MMRunloopObserver 的实例传递过去
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
}
@end

@interface MMXibViewController ()
@property (nonatomic ,strong) MMRunloopObserver * observer;
@end

@implementation MMXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    MMXibCustomOneView * oneView = [MMXibCustomOneView xibView];
    [self.view addSubview:oneView];
    
    MMXibCustomTwoView * twoView = [MMXibCustomTwoView xibView];
    [self.view addSubview:twoView];
    
    MMXibCustomThreeView * threeView = [MMXibCustomThreeView xibView];
    [self.view addSubview:threeView];
    
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.height.mas_equalTo(55);
    }];
    
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView);
        make.top.mas_equalTo(oneView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(oneView);
        make.height.mas_equalTo(oneView);
    }];
    
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView);
        make.top.mas_equalTo(twoView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(oneView);
        make.height.mas_equalTo(oneView);
    }];
    
    MMRocky * rocky = [MMRocky new];
    [rocky move];
    NSObject * obj = [NSObject new];
    NSString * str = @"string";
    NSArray * array = @[rocky, obj,str];
    
    for (NSInteger i = 0; i < array.count; i ++) {
        NSObject * o = array[i];
        Class class = o.class;
        if (!class_conformsToProtocol(class, NSProtocolFromString(@"MMMoveable"))) {
            continue;
        }
        NSLog(@"class:%@",o);
    }
    
    self.observer = [MMRunloopObserver new];
    [self.observer start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
