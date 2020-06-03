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
#import <objc/runtime.h>

// defs是xcode默认保留的关键字，这里作为一个宏`_pk_extension`的别名
// For a magic reserved keyword color, use @defs(your_protocol_name)
#define defs _pk_extension

// _pk_extension 宏接受一个参数，也就是协议名，使用$来支持参数的使用，再展开为一个`_pk_extension_imp`的宏，这个宏接受两个参数
// Interface
#define _pk_extension($protocol) _pk_extension_imp($protocol, _pk_get_container_class($protocol))

/**
 @protocol ProtocolName;
 @interface ClassName : NSObject<ProtocolName>
 @end
 @implementation ClassName
 
 +(void) load{
    _pk_extension_load(@protocol(ProtocolName),ClassName)
 }
 */
// Implementation
#define _pk_extension_imp($protocol, $container_class) \
protocol $protocol; \
@interface $container_class : NSObject <$protocol> @end \
@implementation $container_class \
+ (void)load { \
_pk_extension_load(@protocol($protocol), $container_class.class); \
} \

// 这里`_pk_get_container_class`宏的作用是根据协议来获取对应的类，接受两个参数，一个是协议名，一个是计数器，每调用一次就增加1
// 这里的关键是根据协议找到对应的类！！！
// Get container class name by counter
#define _pk_get_container_class($protocol) _pk_get_container_class_imp($protocol, __COUNTER__)

#define _pk_get_container_class_imp($protocol, $counter) _pk_get_container_class_imp_concat(__PKContainer_, $protocol, $counter)

// 这个宏的作用是，使用`##`将三个参数进行连接，结果为:`ab_c`
// 这里的a、b、c分别为：__PKContainer_、ProtocolName、__COUNTER__，
#define _pk_get_container_class_imp_concat($a, $b, $c) $a ## $b ## _ ## $c
// 最主要的宏是 `_pk_get_container_class_imp` ，根据协议名来获取

void _pk_extension_load(Protocol *protocol, Class containerClass);

//#define PKAnnotationDATA __attribute((used, section("__DATA,protocol_extension")))
//
//#define PKAnnotation(__className__) \
//char * kPKAnnotation_##__className__ PKAnnotationDATA = "CLS:"#__className__"";

