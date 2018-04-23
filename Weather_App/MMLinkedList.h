//
//  MMLinkedList.h
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

// 双向链表：head、tail、current，并且使用链表存储的数据都是相同类型的，因此可以使用泛型类
// Lightweight Generics 轻量级泛型，轻量是因为这是个纯编译器的语法支持（llvm 7.0），和 Nullability 一样，没有借助任何 objc runtime 的升级，也就是说，这个新语法在 Xcode 7 上可以使用且完全向下兼容（更低的 iOS 版本）
// http://blog.sunnyxx.com/2015/06/12/objc-new-features-in-2015/

@interface MMLinkedList<T> : NSObject

#pragma mark - init
+ (instancetype) linkedListWithHead:(T)value;
- (instancetype) initWithHead:(T)value;

#pragma mark - add
// 针对当前节点来说
- (void) addToFront:(T)value;
- (void) addToBack:(T)value;

- (void) insertValue:(T)value atIndex:(NSInteger)index;

#pragma mark - search
- (T) firstValue;// 链表头部的数据
- (T) currentValue;
- (T) preValue;
- (T) nextValue;

- (T) valueAtIndex:(NSInteger)index;
- (NSInteger) count;

- (NSArray<T> *) findValue:(T)value;

#pragma mark - delete
- (BOOL) removeCurrent;
- (BOOL) removeValueAtIndex:(NSInteger)index;

#pragma mark - handle
- (void) printList;// 打印链表
- (void) reverseList;// 反转链表

@end
