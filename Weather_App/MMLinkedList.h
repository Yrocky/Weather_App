//
//  MMLinkedList.h
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMNode.h"

// 双向链表：head、tail、current，并且使用链表存储的数据都是相同类型的，因此可以使用泛型类
// Lightweight Generics 轻量级泛型，轻量是因为这是个纯编译器的语法支持（llvm 7.0），和 Nullability 一样，没有借助任何 objc runtime 的升级，也就是说，这个新语法在 Xcode 7 上可以使用且完全向下兼容（更低的 iOS 版本）
// http://blog.sunnyxx.com/2015/06/12/objc-new-features-in-2015/

// 为链表增加一些快速遍历的特性，具备类似于NSArray 的功能
// https://developer.apple.com/library/content/samplecode/FastEnumerationSample/Listings/EnumerableClass_h.html#//apple_ref/doc/uid/DTS40009411-EnumerableClass_h-DontLinkElementID_3
// https://www.jianshu.com/p/2ec49d525871

// 但是什么情况下才会去使用链表呢？为什么不使用NSArray呢？
// 在知乎上看到一些答案，还是比较合理的：https://www.zhihu.com/question/31082722?sort=created
// 在so上的一个答案：https://stackoverflow.com/questions/166884/array-versus-linked-list
// 链表的优点除了「插入删除不需要移动其他元素」之外，还在于它是一个局部化结构。就是说当你拿到链表的一个 node 之后，不需要太多其它数据，就可以完成插入，删除的操作。
// 而其它的数据结构不行。比如说 array，你只拿到一个 item 是断不敢做插入删除的。

// autoreleasePool的实现是双向链表，内部节点是具备分页的，也就是节点是一个具备栈结构的对象，整体上是将栈和双向链表的结合数据结构
// 看一下维基对链表的解释：https://en.wikipedia.org/wiki/Linked_list
// 链接列表的一个缺点是访问时间是线性的，链表的访问是从head开始使用next指针依次遍历

@interface MMLinkedList<__covariant T> : NSObject<NSFastEnumeration>{
    MMNode<T> *_current;
    MMNode<T> *_head;
    MMNode<T> *_tail;
    NSUInteger _count;
}
@property (nonatomic ,strong ,readonly) MMNode<T> * current;
@property (nonatomic ,strong ,readonly) MMNode<T> * head;
@property (nonatomic ,strong ,readonly) MMNode<T> * tail;

#pragma mark - init
+ (instancetype) linkedListWithHead:(T)value;
- (instancetype) initWithHead:(T)value;
- (instancetype) initWithArray:(NSArray<T> *)array;

#pragma mark - add
- (void) addToFront:(T)value;
- (void) addToBack:(T)value;

- (void) insertValue:(T)value atIndex:(NSInteger)index;

#pragma mark - search
- (T) firstValue;// 链表头部的数据
- (T) currentValue;
- (T) preValue;
- (T) nextValue;

// 获取列表的最后一个节点（假设最后一个节点没有作为列表结构中的单独节点引用来维护），valueAtIndex:(NSInteger)index
// 或者找到包含给定数据的节点，findValue:(T)value
// 或者找到应该插入新节点，insertValue:(T)value atIndex:(NSInteger)index
// - 可能需要顺序扫描大部分或全部列表元素，效率不是很高，这一点上是不如数组的
- (T) valueAtIndex:(NSInteger)index;
- (T) objectAtIndexedSubscript:(NSUInteger)idx;// for NSFastEnumeration
- (NSInteger) count;
- (NSArray *) findValue:(T)value;

//- (void) enumerateValuesUsingBlock:(void (^)(T obj, NSUInteger idx, BOOL *stop))block;// TODO: for NSFastEnumeration
//- (NSEnumerator*)objectEnumerator;// TODO: for NSFastEnumeration

#pragma mark - delete
- (BOOL) removeHead;///<移除之后，其后面的节点将会替代它
- (BOOL) removeTail;
- (BOOL) removeCurrent;
- (BOOL) removeValue:(T)value;
- (BOOL) removeValueAtIndex:(NSInteger)index;
- (void) removeAll;

#pragma mark - move
- (void) moveToHead;
- (void) moveToTail;
- (void) moveToIndex:(NSUInteger)index;
- (void) moveToValue:(T)value;

#pragma mark - handle
- (void) printList;// 打印链表
- (void) reverseList;// 反转链表

@end

///<双向循环链表
@interface MMCycleLinkedList<T> : MMLinkedList<T>

@end
