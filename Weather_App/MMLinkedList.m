//
//  MMLinkedList.m
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMLinkedList.h"
#import "MMNode.h"

@interface MMLinkedList(){
    NSUInteger _count;
}
@property (nonatomic ,strong) MMNode * current;
@property (nonatomic ,strong) MMNode * head;
@property (nonatomic ,strong) MMNode * tail;
@end

@implementation MMLinkedList

+ (instancetype)linkedListWithHead:(id)value{
    return [[[self class] alloc] initWithHead:value];
}

- (instancetype)initWithHead:(id)value{

    self = [super init];
    if (self) {
        _head = [MMNode nodeWithValue:value];
        _count = 1;
    }
    return self;
}

- (void)addToFront:(id)value{
    
    MMNode * node = [MMNode nodeWithValue:value];
    
    if (nil == self.tail) {
        
        MMNode * lastNode = self.head;
        for (NSUInteger i = 1; i < _count; i++) {
            lastNode = lastNode.next;
        }
        _tail = lastNode;
    }
    
    //
    node.next = self.head;
    self.head.pre = node;
    _head = node;
    
    _count ++;
}

- (void)addToBack:(id)value{

    MMNode * node = [MMNode nodeWithValue:value];

    if (nil == self.tail) {
        MMNode * lastNode = self.head;
        for (NSUInteger i = 1; i < _count; i++) {
            lastNode = lastNode.next;
        }
        _tail = lastNode;
    }
    self.tail.next = node;
    node.pre = self.tail;
    _tail = node;
    
    _count ++;
}

- (void)insertValue:(id)value atIndex:(NSInteger)index{
    
    if (index >= _count) {
        NSLog(@"too big then count");
        return;
    }
    
    MMNode * currentNode = self.head;
    MMNode * node = [MMNode nodeWithValue:value];
    MMNode * pre = nil;
    MMNode * next = nil;
    
    // 找到index现在所在的node
    for (NSInteger i = 1; i <= index; i ++) {
        currentNode = currentNode.next;
        if (i == index - 1) {
            pre = currentNode;
        }else if (i == index){
            next = currentNode;
        }
    }
    
    if (!pre) {
        [self addToFront:node];
    }else{
        pre.next = node;
        node.pre = pre;
        
        next.pre = node;
        node.next = next;
    }
    _count ++;
}

- (id) firstValue{
    return self.head.value;
}

- (id) currentValue{
    return self.current.value;
}

- (id) preValue{
    _current = self.current.pre;
    return self.current.value;
}

- (id) nextValue{
    _current = self.current.next;
    return self.current.value;
}

// O(n)
- (id) valueAtIndex:(NSInteger)index{
    
    MMNode * currentNode = self.head;
    for (int i = 1; i < index; i ++) {
        currentNode = currentNode.next;
    }
    return currentNode.value;
}

- (NSInteger) count{
    return _count;
}

- (void)printList{
    
    MMNode * node = self.head;
    NSLog(@"print linked list start");
    while (node) {
        NSLog(@"node:%@",node.value);
        node = node.next;
    }
    NSLog(@"print linked list end");
}
// 翻转链表
- (void)reverseList{
    
    // for debug
    [self printList];
    
    _current = self.head;
    
    MMNode * pre = nil;
    MMNode * next = nil;
    
    while (self.current) {
        
        next = self.current.next;// temp
        self.current.next = pre;// 如果是head，将本次的next设置为nil
        
        pre = self.current;
        self.current = next;
    }
    _head = pre;
    
    // for debug
    [self printList];
}
@end
