//
//  BlockViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2021/3/3.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import "BlockViewController.h"

typedef void(^TestBlockType)(void);

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"return block:%@",[self returnSomeBlock]);
    [self createStackBlock];
    
    [self copyBlock];
    
    [self testBlockInArray];
    
    [self useBlockAs:^{
        NSLog(@"in block");
    }];
    
    [self testCopyBlock];
    
    [self holdObj];
}

- (TestBlockType) returnSomeBlock{
    
    TestBlockType block = ^{
        NSLog(@"in return block inner");
    };
    
    return block;
}

- (void) createStackBlock {
    __weak void(^block)();
    block = ^{};
//    block();
    NSLog(@"stack block:%@",block);
}

- (void) copyBlock{
    void(^blk)() = ^{
        
    };
    NSLog(@"1:%@",blk);
    TestBlockType copyedBlock = [blk copy];
    NSLog(@"2:%@",copyedBlock);
}

- (NSArray *) getBlockArray{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            [^{NSLog(@"1 val:%d",val);} copy],
            [^{NSLog(@"2 val:%d",val);} copy],
            nil];
    return @[
        ^{NSLog(@"1 val:%d",val);},
         ^{NSLog(@"2 val:%d",val);}
    ];
}

- (void) testBlockInArray{
    NSArray * array = [self getBlockArray];
    void(^blk)() = array[0];
    blk();
}

- (void) useBlockAs:(TestBlockType)block{
    NSLog(@"use block:%@",block);
    block();
}

- (void) testCopyBlock{
    
    __block int val = 10;
    void(^blk)() = ^{
        ++val;// 使用了__block修饰之后的变量已经可以跟随着外部变化而变化
        NSLog(@"1val:%d",val);
    };
    
    ++val;// 11
    
    NSLog(@"2val:%d",val);// 11
    
    blk();
    
    NSLog(@"3val:%d",val);
}

- (void) holdObj{
    void(^blk)(id);
    {
        NSMutableArray * array = [[NSMutableArray alloc] init];
//        blk = [^(id obj){
//            [array addObject:obj];
//            NSLog(@"array count:%d",array.count);
//        } copy];
        blk = ^(id obj) {
            [array addObject:obj];
            NSLog(@"array count:%d",array.count);
        };
    }
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
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
