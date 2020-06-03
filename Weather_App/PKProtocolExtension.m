// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <Foundation/Foundation.h>
#import "PKProtocolExtension.h"
#import <pthread.h>
#include <dlfcn.h>

#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>

// 声明一个结构体，里面有协议、实例方法、实例方法的个数、类方法、类方法个数
typedef struct {
    Protocol *__unsafe_unretained protocol;
    Method *instanceMethods;// 私有类已经实现的实例方法对象
    unsigned instanceMethodCount;
    Method *classMethods;// 私有类已经实现的类方法对象
    unsigned classMethodCount;
} PKExtendedProtocol;

// 三个全局静态变量
static PKExtendedProtocol *allExtendedProtocols = NULL;// 用来保存工程中所有的使用了@defs的协议
static pthread_mutex_t protocolsLoadingLock = PTHREAD_MUTEX_INITIALIZER;// 锁
static size_t extendedProtcolCount = 0, extendedProtcolCapacity = 0;// 两个全局变量，分别用来记录拓展协议的个数和

Method *_pk_extension_create_merged(Method *existMethods, unsigned existMethodCount, Method *appendingMethods, unsigned appendingMethodCount) {
    
    if (existMethodCount == 0) {
        return appendingMethods;
    }
    unsigned mergedMethodCount = existMethodCount + appendingMethodCount;
    // 初始化Method，然后对私有类的Method*进行copy，拷贝内存
    Method *mergedMethods = malloc(mergedMethodCount * sizeof(Method));
    memcpy(mergedMethods, existMethods, existMethodCount * sizeof(Method));
    memcpy(mergedMethods + existMethodCount, appendingMethods, appendingMethodCount * sizeof(Method));
    return mergedMethods;
}
// 向创建的私有类追加实例方法和类方法
void _pk_extension_merge(PKExtendedProtocol *extendedProtocol, Class containerClass) {
    
    // Instance methods 实例方法
    unsigned appendingInstanceMethodCount = 0;
    // 获取私有类的所有实例方法
    Method *appendingInstanceMethods = class_copyMethodList(containerClass, &appendingInstanceMethodCount);
    // 将私有类的实例方法本身（Method*）以及方法个数转交给PKExtendedProtocol结构体
    Method *mergedInstanceMethods = _pk_extension_create_merged(extendedProtocol->instanceMethods,
                                                                extendedProtocol->instanceMethodCount,
                                                                appendingInstanceMethods,
                                                                appendingInstanceMethodCount);
    free(extendedProtocol->instanceMethods);
    extendedProtocol->instanceMethods = mergedInstanceMethods;
    extendedProtocol->instanceMethodCount += appendingInstanceMethodCount;
    
    // Class methods 类方法
    unsigned appendingClassMethodCount = 0;
    // 获取私有类的所有类方法以及类方法的个数
    Method *appendingClassMethods = class_copyMethodList(object_getClass(containerClass), &appendingClassMethodCount);
    Method *mergedClassMethods = _pk_extension_create_merged(extendedProtocol->classMethods,
                                                             extendedProtocol->classMethodCount,
                                                             appendingClassMethods,
                                                             appendingClassMethodCount);
    free(extendedProtocol->classMethods);
    extendedProtocol->classMethods = mergedClassMethods;
    extendedProtocol->classMethodCount += appendingClassMethodCount;
}

// 重写 私有类的 load 方法，内部只有一个方法 _pk_extension_load ，
void _pk_extension_load(Protocol *protocol, Class containerClass) {
    
    pthread_mutex_lock(&protocolsLoadingLock);// 加锁
    
    // 如果 拓展协议的数量，能力？
    
    if (extendedProtcolCount >= extendedProtcolCapacity) {
        size_t newCapacity = 0;
        // 加载第一个def的时候肯定是0
        if (extendedProtcolCapacity == 0) {
            newCapacity = 1;
        } else {
            newCapacity = extendedProtcolCapacity << 1;// 乘以2，使用二进制的位运算，更高效
        }
        allExtendedProtocols = realloc(allExtendedProtocols, sizeof(*allExtendedProtocols) * newCapacity);
        extendedProtcolCapacity = newCapacity;
    }
    
    size_t resultIndex = SIZE_T_MAX;
    for (size_t index = 0; index < extendedProtcolCount; ++index) {
        
        if (allExtendedProtocols[index].protocol == protocol) {
            resultIndex = index;
            break;
        }
    }
    
    // 如果第一次走遵守该协议的类的私有类的时候，
    // 会通过该协议初始化一个PKExtendedProtocol结构体实例
    if (resultIndex == SIZE_T_MAX) {
        // 为 allExtendedProtocols 添加对应的 PKExtendedProtocol 枚举实例
        // 当调用了一个使用@defs修饰的协议之后，extendedProtcolCount 就会自增一次，这样保证记录了项目中所有使用了@defs的协议
        allExtendedProtocols[extendedProtcolCount] = (PKExtendedProtocol){
            .protocol = protocol,
            .instanceMethods = NULL,
            .instanceMethodCount = 0,// 所有已经存在的方法都为0
            .classMethods = NULL,
            .classMethodCount = 0,
        };
        resultIndex = extendedProtcolCount;
        extendedProtcolCount++;
    }
    
    // 这里将私有类以及私有结构体进行操作
    _pk_extension_merge(&(allExtendedProtocols[resultIndex]), containerClass);
    
    pthread_mutex_unlock(&protocolsLoadingLock);
}

static void _pk_extension_inject_class(Class targetClass, PKExtendedProtocol extendedProtocol) {
    
    // 对目标类进行实例方法的添加
    for (unsigned methodIndex = 0; methodIndex < extendedProtocol.instanceMethodCount; ++methodIndex) {
        Method method = extendedProtocol.instanceMethods[methodIndex];
        SEL selector = method_getName(method);
        
        if (class_getInstanceMethod(targetClass, selector)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        // 动态的为目标类添加一个Method，这个Method就是私有类中已经实现的方法，在目标类主类中如果又实现了就会覆盖该Method
        class_addMethod(targetClass, selector, imp, types);
    }
    
    // 找到类方法列表，为目标类进行添加
    Class targetMetaClass = object_getClass(targetClass);
    for (unsigned methodIndex = 0; methodIndex < extendedProtocol.classMethodCount; ++methodIndex) {
        Method method = extendedProtocol.classMethods[methodIndex];
        SEL selector = method_getName(method);
        
        // 不替换load、initialize方法
        if (selector == @selector(load) || selector == @selector(initialize)) {
            continue;
        }
        // 不替换实例方法
        if (class_getInstanceMethod(targetMetaClass, selector)) {
            continue;
        }
        
        IMP imp = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        class_addMethod(targetMetaClass, selector, imp, types);
    }
}


NSArray<NSString *>* PKConfigFromSection(const char *sectionName){
    
#ifndef __LP64__
    const struct mach_header *mhp = NULL;
#else
    const struct mach_header_64 *mhp = NULL;
#endif
    
    NSMutableArray *configs = [NSMutableArray array];
    Dl_info info;
    if (mhp == NULL) {
        dladdr(PKConfigFromSection, &info);
#ifndef __LP64__
        mhp = (struct mach_header*)info.dli_fbase;
#else
        mhp = (struct mach_header_64*)info.dli_fbase;
#endif
    }
    
#ifndef __LP64__
    unsigned long size = 0;
    uint32_t *memory = (uint32_t*)getsectiondata(mhp, SEG_DATA, sectionName, & size);
#else /* defined(__LP64__) */
    unsigned long size = 0;
    uint64_t *memory = (uint64_t*)getsectiondata(mhp, SEG_DATA, sectionName, & size);
#endif /* defined(__LP64__) */
    
    for(int idx = 0; idx < size/sizeof(void*); ++idx){
        char *string = (char*)memory[idx];
        
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        if(str) [configs addObject:str];
    }
    
    return configs;
}

// 这个 _pk_extension_inject_entry 方法

__attribute__((constructor)) static void _pk_extension_inject_entry(void) {
    
    pthread_mutex_lock(&protocolsLoadingLock);
    
    /* 有人想出来了一个优化的点
    1.开始我们仍然在 +load 方法中做准备工作，和原有的实现一样，把所有的协议都存到链表中。
    2.在 __attribute__((constructor)) 中仍然做是否能执行注入的检查。
    3.现在我们 hook NSObject 的 +resolveInstanceMethod: 和  +resolveClassMethod: 。
    4.在 hook 中进行检查，如果该类有遵守了我们实现了注入的协议，那么就给该类注入容器中的方法。

    代码和 demo 如下
    https://github.com/newyjp/BLMethodInjecting
    */
    /*
     或者为目标类添加一个编译标记，使用一个本地数组进行记录，就像module-service中那样，将数据写到包里面，
     只需要去遍历这个数组就行了
     */
//    NSArray<NSString *> *dataListInSection = PKConfigFromSection("protocol_extension");
//    for (NSString *item in dataListInSection) {
//        NSArray *components = [item componentsSeparatedByString:@":"];
//        if (components.count >= 1) {
//            NSString *type = components[1];
//            if ([type isEqualToString:@"CLS"]) {
//                NSString *modName = components[1];
//                Class modCls = NSClassFromString(modName);
//                if (modCls) {
////                    [self registerModule:modCls];
//                }
//            }
//        }
//    }
    
    unsigned classCount = 0;
    // 读取所有class，这里效率不是很高，由于这个方法会在main之前执行，所以如果类过多就会导致启动很慢
    Class *allClasses = objc_copyClassList(&classCount);
    
    // 这也是这里作者使用自动释放池的原因
    @autoreleasepool {
        for (unsigned protocolIndex = 0; protocolIndex < extendedProtcolCount; ++protocolIndex) {
            PKExtendedProtocol extendedProtcol = allExtendedProtocols[protocolIndex];
            for (unsigned classIndex = 0; classIndex < classCount; ++classIndex) {
                Class class = allClasses[classIndex];
                // 如果该类自己实现了该协议就继续，执行inject方法
                if (!class_conformsToProtocol(class, extendedProtcol.protocol)) {
                    continue;
                }
                _pk_extension_inject_class(class, extendedProtcol);
            }
        }
    }
    pthread_mutex_unlock(&protocolsLoadingLock);
    
    free(allClasses);
    free(allExtendedProtocols);
    extendedProtcolCount = 0, extendedProtcolCapacity = 0;
}

