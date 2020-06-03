//
//  XXXMakeItEaseViewController.m
//  Weather_App
//
//  Created by skynet on 2020/5/11.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXMakeItEaseViewController.h"
#import "MMLinkedList.h"
#import "MMStack.h"

#define MakeItEasyBegin NSLog(@"begin %@\n",NSStringFromSelector(_cmd));

#define MakeItEasyEnd NSLog(@"+++++++++end %@",NSStringFromSelector(_cmd));

@interface XXXQueue : NSObject{
    MMStack *_stack1;// 用来存放插入节点
    MMStack *_stack2;// 用来存放删除节点
}

- (void) log;

// 尾部插入节点
- (void) appendTail:(id)value;
// 头部删除节点
- (id) deleteHead;
@end

@interface XXXMakeItEaseViewController ()

@end

@implementation XXXMakeItEaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self replaceSpace];
    [self printLinkFromTailToHead];
    [self makeQueueWithTwoStack];
    [self throughRotateArrayFindMinValue];
    [self makeFibonacci];
    [self exchange];
}

// NO.4
- (void) replaceSpace{
    MakeItEasyBegin
    
    NSString * text = @"What are you doing.";
    // 替换字符串中的空格为%20，如果从前往后，are需要1次，you需要移动2次，doing.需要移动3次
    // What are you doing.
    // What%20are you doing. 1、1、1
    // What%20are%20you doing. 1、2、2
    // What%20are%20you%20doing. 1、2、3
    // 换个思路，从后往前移动
    
    // O(n) 不改变原来字符串
    NSLog(@"text:%@",text);
    NSString * result = @"";
    for(NSInteger index1 = text.length - 1; index1 >= 0; index1--){
        
        NSString * onChar = [text substringWithRange:NSMakeRange(index1, 1)];
        if ([onChar isEqualToString:@" "]) {
            result = [@"%20" stringByAppendingString:result];
        } else {
            result = [onChar stringByAppendingString:result];
        }
    }
    NSLog(@"result 1:%@",result);
    
    // O(n) 改变原来字符串
    NSLog(@"text:%@",text);
    for(NSInteger index1 = text.length - 1; index1 >= 0; index1--){
        
        NSString * onChar = [text substringWithRange:NSMakeRange(index1, 1)];
        if ([onChar isEqualToString:@" "]) {
            text = [text stringByReplacingCharactersInRange:NSMakeRange(index1, 1) withString:@"%20"];
        }
    }
    NSLog(@"result 2:%@",text);
    MakeItEasyEnd
}

// NO.5
- (void) printLinkFromTailToHead{
    
    MakeItEasyBegin
    // 链表只能从头依次遍历
    MMLinkedList * link = [[MMLinkedList alloc] initWithArray:@[@1,@2,@3,@4,@5]];
    //        NSLog(@"%@",[link description]);
    // 从尾部开始遍历一个链表的操作更像是访问一个栈，而递归在本质上就是一个栈结构
    // 使用递归，在每次访问一个节点的时候都先递归输出她后面的节点，然后再输出该节点
    [self printNode:link.head];
    MakeItEasyEnd
}
- (void) printNode:(MMNode *)node{
    if (node.next) {
        [self printNode:node.next];
    }
    NSLog(@"current node:%@",node.value);
}

// NO.7
- (void) makeQueueWithTwoStack{
    MakeItEasyBegin
    XXXQueue * queue = [XXXQueue new];
    [queue appendTail:@"a"];
    [queue appendTail:@"b"];
    [queue appendTail:@"c"];
    
    [queue log];
    // 内部使用两个stack来实现，stack1用来做添加，stack2用来做删除
    // 1：[a],[b],[c]
    // 2：[],[],[]
    
    // 执行删除头部操作，
    NSLog(@"delete-1:%@",[queue deleteHead]);
    // 1.内部会先将1中的数据压栈到2中
    // 这个时候1为空，2有1的倒序值
    // [],[],[]
    // [c],[b],[a]
    
    // 2.然后对2执行pop，删除a
    // 1：[],[],[]
    // 2：[c],[b],[]
    [queue log];
    
    // 接下来不论是执行append还是delete，都是append的时候添加到1中，delete的时候从2中pop
    NSLog(@"delete-2:%@",[queue deleteHead]);
    [queue log];
    
    NSLog(@"append-1:d");
    [queue appendTail:@"d"];
    [queue log];
    MakeItEasyEnd
}

// NO.8
- (void) throughRotateArrayFindMinValue{
    MakeItEasyBegin
    // 把数组中前面若干元素搬到数组的末尾，称为数组的旋转
    // 给定一个升序排列的数组的一个转转，求该数组中最小的元素
    // [3,4,5,1,2]为[1,2,3,4,5]的一个旋转，该数组最小值为1
    
    // 1.
    // 因为给定的数组部分有序：[3,4,5]和[1,2]，并且是升序的
    // 根据定义可以知道，前面数组的最小值一定大于后面数组的最大值：3>2
    // 只需要从后边遍历，直到值大于第一个值即可，然后遍历到索引的下一个即可，这个就是该数组中最小的值
    NSArray * array = @[@30,@34,@51,@58,@76,@1,@2,@14,@23,@24,@25,@29];
    NSInteger headValue = [array.firstObject integerValue];
    NSInteger minValue = NSNotFound;
    for (NSInteger index = array.count - 1; index >= 0; index --) {
        if ([array[index] integerValue] > headValue) {
            if (index + 1 < array.count) {
                minValue = [array[index + 1] integerValue];
            }
            break;
        }
    }
    NSLog(@"min value:%ld",(long)minValue);
    // 这个算法的效率不是很高，O(n)，如果[1,2,3,4]是[1,2,3,4]（也就是升序数组自身也是一个旋转的时候），需要遍历所有的元素
    
//    array = @[@1,@2,@3,@4,@5];
    // 2.
    // 在有序列表中，使用二分法可以解决大部分问题
    [self findMinValueWithHeadIndex:0
                          tailIndex:array.count - 1
                           midIndex:array.count / 2// 如果给定的数组是[1,2,3,4],那么就是一个有序数组，把mid设置为head能避免多余的计算
                            atArray:array];
    
    // 以上算法没有考虑到[0,1,1,1,1]这种数组中有重复数据的情况
    MakeItEasyEnd
}
- (void) findMinValueWithHeadIndex:(NSInteger)headIndex tailIndex:(NSInteger)tailIndex midIndex:(NSInteger)midIndex atArray:(NSArray *)array{
    NSLog(@"head:%ld mid:%ld tail:%ld",(long)headIndex,(long)midIndex,(long)tailIndex);
    NSInteger headValue = [array[headIndex] integerValue];
    NSInteger tailValue = [array[tailIndex] integerValue];
    if (headIndex + 1 == tailIndex) {
        // 当两个索引相差1的时候就说明headIndex为第一个数组的最后一个，tailIndex为第二个数组的第一个，即最小值
        NSLog(@"find min:%ld",(long)tailValue);
    } else if ([array[midIndex] integerValue] > headValue) {
        // 说明mid在左边数组中，head-mid中间的可以不用遍历，遍历mid-tail
        headIndex = midIndex;
        midIndex = (tailIndex - headIndex) / 2 + headIndex;
        headValue = [array[headIndex] integerValue];
        [self findMinValueWithHeadIndex:headIndex tailIndex:tailIndex midIndex:midIndex atArray:array];
    } else if ([array[midIndex] integerValue] < tailValue){
        // 说明mid在右边数组中，mid-tail中间的不用遍历，，遍历head-mid
        tailIndex = midIndex;
        midIndex = (tailIndex - headIndex) / 2 + headIndex;
        tailValue = [array[tailIndex] integerValue];
        [self findMinValueWithHeadIndex:headIndex tailIndex:tailIndex midIndex:midIndex atArray:array];
    }
}

// NO.9
- (void) makeFibonacci{
    MakeItEasyBegin
    // 实现斐波那契数列的时候，一般都是使用递归思想
    /*
     * f(n) =
     * n = 0, 0
     * n = 1, 1
     * f(n-1)+f(n-2),n>1
     */
    // 但是递归方法会有一些效率问题，比如f(10)=f(9)+f(8),这就需要先求的f(9)、f(8)，
    // f(9)=f(8)+f(7),而f(8)=f(7)+f(6)
    // 可以看到，f(10)=f(8)+f(7)+f(7)+f(6)，而第一个f(8)又需要再求一遍，本来可以直接使用f(7)+f(6)的，这就导致效率不高
    NSLog(@"fib 1:%ld",(long)[self fib1:23]);
    
    // 使用递归和使用循环是一样的效果，只不过递归在实现上会比较直观，但是递归也有可能会因为调用过深导致栈溢出
    NSLog(@"fib 2:%ld",(long)[self fib2:23]);
    
    // 斐波那契数列还有很多其他的变种形式
    // 比如，青蛙1次可以跳上1级，也可以跳上2级。。。。也可以跳上n级台阶，求跳上一个n级的台阶一共有多少种方法
    NSLog(@"fib 3:%ld",(long)[self fib3:23]);
    
    MakeItEasyEnd
}

- (NSInteger) fib1:(NSInteger)n{
    
    if (n == 0) {
        return 0;
    }
    if (n == 1) {
        return 1;
    }
    return [self fib1:n - 1] + [self fib1:n - 2];
}
- (NSInteger) fib2:(NSInteger)n{
    
    if (n == 0) {
        return 0;
    }
    if (n == 1) {
        return 1;
    }
    NSInteger minus_1 = 1;
    NSInteger minus_2 = 0;
    NSInteger result = 0;
    
    for (NSInteger index = 2; index <= n; index ++) {
        result = minus_1 + minus_2;
        minus_2 = minus_1;
        minus_1 = result;
    }
    return result;
}
- (NSInteger) fib3:(NSInteger)n{
    
    return 1;
}

- (void) exchange{
    MakeItEasyBegin
    NSMutableArray * tmp = @[@3,@10,@1,@8,@76,@5,@19,@32,@17,@15].mutableCopy;
    // 将一个数组中的元素按照基数在前，偶数在后进行排列
    NSInteger index_1 = 0;
    NSInteger index_2 = tmp.count - 1;
    
    for (NSInteger i = 0; i < tmp.count; i ++) {
        NSInteger value_1 = [tmp[index_1] integerValue];
        NSInteger value_2 = [tmp[index_2] integerValue];
        if (value_1 / 2 == 0 && value_2 / 2 == 1) {
            // 前面为偶数、后面为奇数的时候，换位置
            [tmp exchangeObjectAtIndex:value_1 withObjectAtIndex:value_2];
        }
    }
    NSLog(@"exchange :%@",tmp);
    MakeItEasyEnd
}
@end

// 先进先出
@implementation XXXQueue
- (instancetype)init{
    self = [super init];
    if (self) {
        _stack1 = [MMStack new];
        _stack2 = [MMStack new];
    }
    return self;
}
- (void) log{
    NSLog(@"stack1:%@",_stack1);
    NSLog(@"stack2:%@",_stack2);
}
- (void) appendTail:(id)value{
    [_stack1 push:value];
}

- (id) deleteHead{
    if (_stack2.size == 0) {
        NSInteger count = _stack1.size;
        for (NSInteger index = 0; index < count; index ++) {
            [_stack2 push:_stack1.pop];
        }
    }
    
    return [_stack2 pop];
}
@end
