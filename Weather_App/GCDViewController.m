//
//  GCDViewController.m
//  Weather_App
//
//  Created by rocky on 2021/2/24.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import "GCDViewController.h"

int global_val = 10;

//int golbal_val = 10;
//static int static_golbal_val = 10;
//static int static_val = 10;

@interface Cup : NSObject
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) void(^callback)(void);
@property (nonatomic ,assign) int countter;
@end

@implementation Cup

- (instancetype)init
{
    self = [super init];
    if (self) {
//        GCDMaxCount = 10;
    }
    return self;
}
- (void) zop{
//    static int static_val = 10;
//    int normal_val = self.countter;
//    NSLog(@"static_val:%p",&static_val);
//    NSLog(@"normal_val:%p",&normal_val);
//    self.countter ++;
//    static_val ++;
    /*:
     全局变量和静态全局变量
     
     全局变量，可以跨文件访问，存储在【全局区】，多个地方使用可以通过extern，
     A.m中定义全局变量: global_val，
     * 外部引用A.h，这个时候需要在A.h中使用extern将global_val暴露出去，TableDemoViewController
     * 外部不引用A.h，需要使用extern将全局变量标识起来，MMGiftEffectViewController
     
     静态变量，仅仅可以在声明的文件中使用，作用域会全局变量小，但是他们都是存储在【全局区】
     
     局部变量，也叫自动变量，仅仅在函数执行时存在，所以只允许在函数内访问
     */
}

- (void) test_block{

    int val = 10;
    
    // 全局
    void(^blk_1)() = ^{
        NSLog(@"没有任何引用");
    };
    NSLog(@"blk_1:%@", blk_1);
    
    // 全局
    int(^blk_2)() = ^{
        NSLog(@"有返回值");
        return 10;
    };
    NSLog(@"blk_2:%@", blk_2);

    // 全局，编译器会把栈上的copy到全局
    void(^blk_3)() = ^{
        NSLog(@"引用变量%d", val);
    };
    NSLog(@"blk_3:%@",blk_3);
    
    __weak int weak_val = 10;
    NSLog(@"weak_val:%d",weak_val);
    __weak NSString * weak_string_val = NSString.new;
    NSLog(@"weak_string_val:%@",weak_string_val);
    
    __weak void(^blk_4)() = ^{};
    NSLog(@"blk_4:%@",blk_4);
    
    NSLog(@"stack block:%@",^{});
}

- (void) in_stack {

    __weak void(^blk)();
    blk = ^{
        // 没有任何引用， global
    };
    blk();
    NSLog(@"in global:%@",blk);
    
    int val = 10;
    __weak void(^blk_2)();
    blk_2 = ^{
        // 有引用， stack
        NSLog(@"val:%d",val);
    };
    blk_2();
    NSLog(@"in stack:%@",blk_2);
    
    __weak int(^blk_3)();
    blk_3 = ^int{
        // 有返回值，无引用，global
        return 10;
    };
    blk_3();
    NSLog(@"in global:%@",blk_3);
}

- (void) demo{
    [self test_block];
    [self in_stack];
    [self createStackBlock];
//    NSLog(@"static_golbal_val:%p", &static_golbal_val);
//    static_golbal_val += 1;
//    NSLog(@"static_golbal_val:%p", &static_golbal_val);
}

- (void) createStackBlock{
    
    int val = 10;
    void(^blk1)();
    
    blk1 = ^{};
    
    NSLog(@"stack blk 1:%@",blk1);// global
 
    NSLog(@"引用变量 %@", ^{NSLog(@"val:%d",val);});// stack
    NSLog(@"不引用 %@", ^{});// global
    NSLog(@"引用变量 copy %@", [^{NSLog(@"val:%d",val);} copy]);// malloc
    NSLog(@"不引用 copy %@", [^{} copy]);// global
    
    void(^blk2)();
    blk2 = ^{
        NSLog(@"val:%d",val);
    };
    NSLog(@"stack blk 2:%@",blk2);//malloc
    
    void(^blk3)() = ^{
        NSLog(@"val:%d",val);
    };
    NSLog(@"stack blk 3:%@",blk3);// malloc
}

@end

@interface DoTaggedPointer : NSObject

@property (nonatomic ,strong) NSString * string_strong;
@property (nonatomic ,copy) NSString * string_copy;
@end

@implementation DoTaggedPointer
- (void) demo{
    [self createString];
    [self testStrong_Copy];
    [self stringWithCopyAndMutableCopy];
    [self arrayWithCopyAndMutableCopy];
    [self forEachWithString];
}
- (void) testStrong_Copy{
    
    self.string_strong = @"abc";
    NSString * other_strong = self.string_strong;
    self.string_strong = @"def";
    
    // other_strong: abc
    
    self.string_copy = @"123";
    NSString * other_copy = self.string_copy;
    self.string_copy = @"456";
    
    // other_copy: 123
    
    /*:
     
     */
}
- (void) createString{
    
    NSString * string = @"不需要去堆中开辟内存，直接使用指针拥有的空间来存储";// malloc-1 <-string
    NSString * stringa = string;// malloc-1 <-stringa
    
    NSString * stringb = [[NSString alloc] initWithString:string];// malloc-1.5 <-stringb
    NSString * stringd = [[NSString alloc] initWithString:@"不需要去堆中开辟内存，直接使用指针拥有的空间来存储"];// malloc-1.5 <-stringb
    
    string = @"456";// malloc-2 <-string、stringa->malloc-1、stringb->malloc1.5
    
    NSLog(@"s %p:%p %@", &string, string, string);
    NSLog(@"a %p:%p %@", &stringa, stringa, stringa);
    NSLog(@"b %p:%p %@", &stringb, stringb, stringb);
    NSLog(@"d %p:%p %@", &stringd, stringd, stringd);

    
    NSString * string1 = @"1";// 0x10069ff88 1
    NSString * string2 = @"1";// 0x10069ff88 2
    NSString * string3 = [NSString stringWithString:@"1"];// 0x10069ff88 3
    NSString * string4 = [NSString stringWithFormat:@"1"];
    
    NSString * string5 = [string1 copy];// 0x10069ff88 4
    NSString * string6 = [string1 mutableCopy];// new 0x60000346ed30
    
    NSString * string7 = [[NSString alloc] initWithString:@"1"];// 0x600001972580
    NSString * string8 = [[NSString alloc] initWithFormat:@"1"];// 0x600001972580
    
    /*:
     +stringWithFormat
     -initWithFormat
     
     MRC:
     +不需要手动释放内存
     -需要手动释放
     
     ARC:
     没有区别
     */
    NSLog(@"1 %p:%p %@", &string1, string1, string1);
    NSLog(@"2 %p:%p %@", &string2, string2, string2);
    NSLog(@"3 %p:%p %@", &string3, string3, string3);
    /*:
     不需要去堆中开辟内存，直接使用指针拥有的空间来存储
     */
    NSLog(@"4 %p:%p %@", &string4, string4, string4);
    NSLog(@"5 %p:%p %@", &string5, string5, string5);
    NSLog(@"6 %p:%p %@", &string6, string6, string6);
    NSLog(@"7 %p:%p %@", &string7, string7, string7);
    NSLog(@"8 %p:%p %@", &string8, string8, string8);
    
    /*:
     -initWithStirng:
     -initWithFormat:
     
     前者或生成全局变量，存储在全局区，并且引用计数很大，不需要我们去管理释放问题
     后者是我们主动申请到的内存地址，在堆区，引用计数为1，需要我们去管理释放
     
     前者不安全，不建议使用
     */
}

- (void) stringWithCopyAndMutableCopy{
    
    /*:
     
     ### 不可变 - NSString
     copy 浅拷贝，引用计数+1
     mutableCopy 深拷贝，申请一份新的内存
     
     ### 可变 - NSSMutableString
     copy 深拷贝，创建一份新的内存
     mutableCopy 深拷贝，创建一份新的内存
     */
    
    NSString * string = @"123";
    id copedString = [string copy];
    id mutabledCopyString = [string mutableCopy];
    
    NSLog(@"string %p:%p %@", &string, string, string);
    NSLog(@"copy %p:%p %@", &copedString, copedString, copedString);
    NSLog(@"mutbaleCopy %p:%p %@", &mutabledCopyString, mutabledCopyString, mutabledCopyString);
    /*:
     string和copedString的内存地址是一样的，这很好理解，因为不可变对象的copy是浅拷贝，只会对内存地址的引用计数+1
     mutbaleCopy是通过对一个不可变对象进行可变复制，会重新申请一块内存空间，并且存放在堆上
     */
    
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:@"abc"];
    id copedMutableString = [mutableString copy];
    id mutabledCopyMutableString = [mutableString mutableCopy];
    
    NSLog(@"mutableString %p:%p %@", &mutableString, mutableString, mutableString);
    NSLog(@"copedMutableString %p:%p %@", &copedMutableString, copedMutableString, copedMutableString);
    NSLog(@"mutabledCopyMutableString %p:%p %@", &mutabledCopyMutableString, mutabledCopyMutableString, mutabledCopyMutableString);
    /*:
     可变对象的copy、mutableCopy都是深拷贝，都会重新在堆上创建内存空间
     简单字面量的类型在copy之后开会开启TaggedPointer
     
     在retain的时候会先判断是否是TaggedPointer对象，如果不是才会进行retain
     
     那么《怎么判断是TaggedPointer对象呢》？
     
     */
}
- (void) arrayWithCopyAndMutableCopy{
    NSArray * array = @[@"a",@"b"];
    id copedArray = [array copy];
    id mutabedCopedArray = [array mutableCopy];
    
    NSLog(@"array %p:%p %@", &array, array, array);
    NSLog(@"copedArray %p:%p %@", &copedArray, copedArray, copedArray);
    NSLog(@"mutabedCopedArray %p:%p %@", &mutabedCopedArray, mutabedCopedArray, mutabedCopedArray);
}

- (void) forEachWithString{
    for (int i = 0; i < 1000; i ++) {
        NSString * string = @"abc".mutableCopy;
        NSLog(@"string %p:%p %@", &string, string, string);
    }
}
@end

@interface GCDViewController ()
@property (nonatomic ,strong) Cup * teaCup;
@property (nonatomic ,strong) DoTaggedPointer * taggedPointer;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self syncMainTask];
//    [self sd];
    self.teaCup = Cup.new;
    [self testWeak_Strong];
    
    self.taggedPointer = [DoTaggedPointer new];
//    GCDMaxCount = 20;
//    GCD_Max_Count = 30;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
//    [self.teaCup demo];
    [self.taggedPointer demo];
}

- (void)syncMainTask {
    dispatch_queue_main_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        NSLog(@"main queue task");
    });
}

- (void) sd {
    __block int a = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    while (a < 2) {
        dispatch_async(queue, ^{
            a++;
        });
    }
    NSLog(@"a = %d", a);
}

- (void) testWeak_Strong{
    __weak Cup * cup = Cup.new;
    
    cup.callback = ^{
        NSLog(@"self.view: %@",self.view);
        cup.name = @"coffeeCup";
    };
    
//    self.teaCup = Cup.new;
//    self.teaCup.callback = ^{
//        NSLog(@"self.view: %@", self.view);
//    };
}

- (void)dealloc
{
    NSLog(@"GCD dealloc");
}

@end
