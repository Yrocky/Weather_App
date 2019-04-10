//
//  MMLinkedList.m
//  Weather_App
//
//  Created by user1 on 2018/4/23.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMLinkedList.h"

@interface MMLinkedList()
@end

@implementation MMLinkedList

- (void)dealloc{
    NSLog(@"linked list %@ dealloc",self);
    _head = nil;
    _tail = nil;
    _current = nil;///<防止循环引用不释放，这里手动释放内存
}

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

- (instancetype) initWithArray:(NSArray *)array{
    if (array && array.count) {
        self = [self initWithHead:array.firstObject];
        for (int x = 1; x < array.count; x ++) {
            [self addToBack:array[x]];
        }
    }
    return self;
}

- (void)addToFront:(id)value{
    
    MMNode * node = [MMNode nodeWithValue:value];
    node.index = 0;
    
    // TODO: 待验证，在removeAll之后，head和tail都没有了
    if (_head == nil) {
        _head = node;
    }
    
    if (nil == self.tail) {
        
        MMNode * lastNode = self.head;
        lastNode.index = self.count;
        for (NSUInteger i = 1; i < _count; i++) {
            lastNode = lastNode.next;
            lastNode.index = i;
        }
        _tail = lastNode;
    }
    
    self.tail.index = self.count;
    
    //
    node.next = self.head;
    
    self.head.pre = node;
    _head = node;
    
    ///<更新node的index O(n)
    MMNode * nextNode = self.head;
    for (NSUInteger index = 0; index < self.count; index ++) {
        nextNode.index = index;
        nextNode = nextNode.next;
    }

    _count ++;
}

- (void)addToBack:(id)value{

    MMNode * node = [MMNode nodeWithValue:value];
    node.index = self.count;
    
    // TODO: 待验证，在removeAll之后，head和tail都没有了
    if (_head == nil) {
        _head = node;
    }
    
    if (nil == self.tail) {
        MMNode * lastNode = self.head;
        for (NSUInteger i = 1; i < _count; i++) {
            lastNode = lastNode.next;
            lastNode.index = i;
        }
        _tail = lastNode;
    }
    
    self.tail.next = node;
    node.pre = self.tail;
    _tail = node;
    
    _count ++;
}

- (void)insertValue:(id)value atIndex:(NSInteger)index{
    
    if (index > _count) {
        NSLog(@"too big then count");
        return;
    }
    if (index == 0) {
        [self addToFront:value];
        return;
    }
    if (index == _count) {
        [self addToBack:value];
        return;
    }
    MMNode * currentNode = self.head;
    MMNode * node = [MMNode nodeWithValue:value];
    node.index = index;
    MMNode * pre = nil;
    MMNode * next = nil;
    
    // 找到index现在所在的node
    for (NSInteger i = 0; i < _count; i ++) {
        if (i == index - 1) {
            pre = currentNode;
        }else if (i == index){
            currentNode.index = i + 1;
            next = currentNode;
        } else if (i > index) {
            currentNode.index = i + 1;
        }
        currentNode = currentNode.next;
    }
    
    if (!pre) {
        [self addToFront:value];
    }else{
        if (nil == next) {
            next = self.tail;
        }
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
    
    // 这里由于是取的node.next，可能为nil，所以不用考虑是否index越界
    return [self nodeAtIndex:index].value;
}

- (MMNode *) nodeAtIndex:(NSUInteger)index{
    MMNode * currentNode = self.head;
    for (int i = 0; i < index; i ++) {
        currentNode = currentNode.next;
    }
    return currentNode;
}

- (MMNode *)current{
    if (nil == _current) {
        return self.head;
    }
    return _current;
}

- (id) objectAtIndexedSubscript:(NSUInteger)idx{
    
    return [self valueAtIndex:idx];
}

- (NSInteger) count{
    return _count;
}

- (NSArray *)findValue:(id)value{
    
    if (value) {
        MMNode * currentNode = self.head;
        NSMutableArray * result = [@[] mutableCopy];
        while (currentNode != self.tail) {
            
            if ([currentNode.value isEqual:value]) {
                [result addObject:currentNode];
            }
            currentNode = currentNode.next;
        }
        return result.copy;
    }
    return nil;
}

- (void) removeAll{
    
    MMNode * node = self.head;
    while (node != self.tail) {
        node.pre = nil;
        node = node.next;
    }
    _head = nil;
    _tail = nil;
    _current = nil;
    
    _count = 0;
}

- (BOOL)removeCurrent{
    
    //FIXME: improve code below
    NSLog(@"-removeCurrent current value %@", [self currentValue]);
    
    BOOL removed = NO;
    if (self.current != nil) {
        MMNode * node = self.current;
        for (NSUInteger i = _current.index; i < _count; i ++) {
            node.index = i - 1;
            node = node.next;
        }
        self.current.pre.next = self.current.next;
        self.current.next.pre = self.current.pre;
        _current = self.head;///<移除当前node之后将游标置为head
        removed = YES;
        _count--;
    }
    else {
        removed = NO;
    }
    
    return removed;
}

- (BOOL)removeValueAtIndex:(NSInteger)index{
    
    if (index < 0 || index > [self count]) {
        NSLog(@"index <%ld> didn't in the range of list",(long)index);
        return NO;
    }
    MMNode * currentNode = self.head;
    
    for (NSUInteger i = 0; i < self.count; i ++) {
        if (currentNode.next == nil) {// 链表中只有一个node的时候
            return NO;
        }
        if (i > index) {
            MMNode * node = [self nodeAtIndex:i];
            node.index = i - 1;
        } else if (i < index) {
            currentNode = currentNode.next;// 向下遍历，直到便利到index所在的node
        }
    }
    
    // 将index所在的node的next指向node.next.next
    MMNode * preNode = currentNode.pre;
    MMNode * nextNode = currentNode.next;
    preNode.next = nextNode;
    nextNode.pre = preNode;
    if (index == 0) {
        _head = nextNode;
    }
    if (index == _count - 1) {
        _tail = preNode;
    }
    _count --;

    return YES;
}

- (void) moveToValue:(id)value{
    if (value) {
        MMNode * currentNode = self.head;
        while (currentNode.next != self.head) {
            if ([currentNode.value isEqual:value]) {
                _current = currentNode;
                break;
            } else {
                currentNode = currentNode.next;
            }
        }
    }
}

- (void) moveToHead{
    _current = self.head;
}

- (void) moveToTail{
    _current = self.tail;
}

- (void) moveToIndex:(NSUInteger)index{
 
    NSAssert(index < self.count, @"index is must be less then linkedList.count");
    
    MMNode * currentNode = self.head;
    for (int i = 0; i < index; i ++) {
        currentNode = currentNode.next;
    }
    
    _current = currentNode;
}

- (void)printList{
    
    MMNode * node = self.head;
    NSLog(@"print linked list start");
    NSString * list = @" - ";
    while (node) {
        list = [list stringByAppendingFormat:@"[pre:%@ node:%@ %lu next:%@] - ",node.pre,node.value,(unsigned long)node.index,node.next];
        node = node.next;
    }
    NSLog(@"%@",list);
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
        _current = next;
    }
    _head = pre;
    
    // for debug
    [self printList];
}

- (NSString *)description
{
    NSMutableString * string = [@"" mutableCopy];
    for (NSInteger index = 0; index < [self count]; index ++) {
        NSLog(@"index-%ld : %@",(long)index,[self nodeAtIndex:index]);
        [string appendFormat:@"%@ -- ",[self valueAtIndex:index]];
    }
    NSLog(@"\n+++++++++++++++++++\nself.head:%@  self.tail:%@",self.head,self.tail);
    return [NSString stringWithFormat:@"%@", string];
}
@end

@implementation MMCycleLinkedList

- (void) cycle{
    self.tail.index = self.count - 1;
    self.tail.next = self.head;
    
    self.head.index = 0;
    self.head.pre = self.tail;
}

///<重写父类的这两个方法，将tail和head进行相连
- (id)preValue{
    if (nil == self.tail) {
        MMNode * lastNode = self.head;
        for (NSUInteger i = 1; i < self.count; i++) {
            lastNode = lastNode.next;
            lastNode.index = i;
        }
        _tail = lastNode;
    }
    [self cycle];
    return [super preValue];
}

- (id)nextValue{
    if (nil == self.tail) {
        MMNode * lastNode = self.head;
        for (NSUInteger i = 1; i < self.count; i++) {
            lastNode = lastNode.next;
            lastNode.index = i;
        }
        _tail = lastNode;
    }
    [self cycle];
    return [super nextValue];
}
- (void)addToFront:(id)value{
    
    [super addToFront:value];
    [self cycle];
}

- (void)addToBack:(id)value{

    [super addToBack:value];
    [self cycle];
}

- (BOOL)removeCurrent{
    
    BOOL removed = [super removeCurrent];
    
    return removed;
}

///<access test
- (BOOL)removeValueAtIndex:(NSInteger)index{
    
    BOOL removed = [super removeValueAtIndex:index];
    [self cycle];
    return removed;
}

- (void)insertValue:(id)value atIndex:(NSInteger)index{
    if (index == _count) {///<加到最后，这个处理的不是很优雅
        MMNode * node = [MMNode nodeWithValue:value];
        node.index = index;
        node.pre = self.tail;
        node.next = self.head;
        
        self.tail.next = node;
        self.head.pre = node;
        
        _tail = node;
        _count ++;
    } else {
        [super insertValue:value atIndex:index];
        [self cycle];
    }
}

- (NSArray *)findValue:(id)value{
    
    NSMutableArray * result = [[super findValue:value] mutableCopy];
    if (value) {
        if ([self.tail.value isEqual:value]) {
            [result addObject:self.tail];
        }
        return result.copy;
    }
    return nil;
}

- (void) moveToValue:(id)value{
    [super moveToValue:value];
    if (value) {
        if ([self.tail.value isEqual:value]) {
            _current = self.tail;
        }
    }
}

- (void)printList{
    for (int i = 0; i < self.count; i ++) {
        NSLog(@"index: %d %@",i,[self nodeAtIndex:i]);
    }
}

- (void)reverseList{
    NSLog(@"循环链表没有翻转方法");
}
@end
