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
#import <Masonry.h>
#import "NSArray+Sugar.h"

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
    
    UIImageView * circle_1 = [UIImageView new];
    circle_1.image = [UIImage imageNamed:@"demo_circle_3"];
    circle_1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:circle_1];
    [circle_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(20);
    }];
    
    UIImageView * circle_2 = [UIImageView new];
    circle_2.image = [UIImage imageNamed:@"demo_circle_3"];
    circle_2.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:circle_2];
    [circle_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(circle_1);
        make.top.equalTo(circle_1.mas_bottom).mas_offset(20);
    }];
    
    UIImageView * circle_3 = [UIImageView new];
    circle_3.image = [UIImage imageNamed:@"demo_circle_3"];
    circle_3.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:circle_3];
    [circle_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(circle_2);
        make.top.equalTo(circle_2.mas_bottom).mas_offset(20);
    }];
    
    [self greedyAlgorithm];
//    [self qsort];
//    [self replaceSpace];
//    [self printLinkFromTailToHead];
//    [self makeQueueWithTwoStack];
//    [self throughRotateArrayFindMinValue];
//    [self makeFibonacci];
//    [self exchange];
}

// 贪心算法
- (void) greedyAlgorithm {
    MakeItEasyBegin
    /*
     假设字典中的key表示广播台，集合中的为广播台可以覆盖的区域，
     要求使用最少的广播台覆盖全部的区域
     
     贪婪算法仅仅考虑当前的最优解
     
     */
    NSSet * one = [NSSet setWithObjects:@"id",@"nv",@"ut", nil];
    NSSet * two = [NSSet setWithObjects:@"wa",@"id",@"mt", nil];
    NSSet * three = [NSSet setWithObjects:@"or",@"nv",@"ca", nil];
    NSSet * four = [NSSet setWithObjects:@"nv",@"ut", nil];
    NSSet * five = [NSSet setWithObjects:@"ca",@"az", nil];
    
    NSDictionary * stations = @{
        @"kone": one,
        @"ktwo": two,
        @"kthree": three,
        @"kfour": four,
        @"kfive": five,
    };
    
    NSMutableSet * result = [NSMutableSet new];
    
    // 记录已经被覆盖的数据
    NSMutableSet * states_covered = [NSMutableSet new];
    [stations enumerateKeysAndObjectsUsingBlock:^(NSString * station, NSSet * states_for_station, BOOL * _Nonnull stop) {
        [states_covered intersectSet:states_for_station];
    }];
    
    MakeItEasyEnd
}

// 快排
- (void) qsort{

    MakeItEasyBegin
//    NSArray * tmp = @[@(12),@(4),@(8),@(1),@(10),@(34)];
    NSArray * tmp = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8)];
    NSArray * result = [self quickSort:tmp];
    NSLog(@"%@",result);
    
    MakeItEasyEnd
}

- (NSArray *) quickSort:(NSArray<NSNumber *> *)array{
    /*
     快排使用递归的方法
     1.选取好结束条件
     2.选取pivot，这里先使用第一个元素，然后比较当前数组中的元素，
        小于pivot的放入一个less数组，大于pivot的放入一个greater数组
        然后对less、greater数组进行快排，分别得到less_result和greater_result
        并将 less_result + pivot + greater_result 作为排序结果
     
     在最坏的情况下，快排的运行时间为O(n²)，但是在平均情况下，是O(n log n)
     
     那么为什么快排比merge sort（合并排序）更好呢，合并排序比较稳定，时间一直是O(n log n)
     
     O(n)的实际表示为O(c*n)，c为固定的时间量，也就是常量，通常不考虑这个常量，
     在两个算法的大O运行时间不同的时候，这个常量将无关紧要，比如简单查找和二分查找，常量起到的作用不大，
     
     但是如果在两个算法的运行时间很接近的时候，c常量就有用了，比如快排和合并排序就是这样，
     这两个算法的运行时间都为O(n log n)的时候，快排的速度将更快，因为他的常量比合并的常量更小，
     另一个问题，他最糟的时候可是O(n²)呀！因为相对于遇上最糟的情况，他遇上平均情况的可能性更大。
     
     快排的性能高度依赖于pivot，也就是选择分割数组的基准值，
     由于快排是不检验输入的数组是否有序的，
     这里是使用数组的第一个元素作为基准值，如果一个是逆向排序的数组，要升序排列，选择第一个就是最快的
     
     */
    NSLog(@"++");
    if (array.count < 2) {
        return array;
    }
    // 选取第一个元素为基准值
    NSInteger pivot = array.firstObject.integerValue;
    // 选取中间值为基准值
//    NSInteger pivot = array[array.count >> 1].integerValue;
    
    NSMutableArray<NSNumber *> * less = [NSMutableArray new];
    NSMutableArray<NSNumber *> * greater = [NSMutableArray new];
    for (NSInteger index = 1; index < array.count; index ++) {
        NSNumber * obj = array[index];
        if (obj.integerValue < pivot) {
            [less addObject:obj];
        } else {
            [greater addObject:obj];
        }
    }
    NSMutableArray * result = [NSMutableArray arrayWithArray:[self quickSort:less]];
    [result addObject:@(pivot)];
    [result addObjectsFromArray:[self quickSort:greater]];
    return result;
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
