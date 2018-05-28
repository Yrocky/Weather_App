//
//  MMCoreTextViewController.m
//  Weather_App
//
//  Created by user1 on 2018/4/26.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMCoreTextViewController.h"
#import "NSArray+Algorithms.h"

#if __clang__

// 取余
#if !defined(MM_Mod)

    #define __MM_Mod_IMPL__(A,B,L)({\
        __typeof__(A) __NSX_PASTE__(__a,L) = (A);\
        __typeof__(B) __NSX_PASTE__(__b,L) = (B);\
        __NSX_PASTE__(__a,L) % __NSX_PASTE__(__b,L);\
    })\

    #define MM_Mod(A,B) __MM_Mod_IMPL__(A,B,__Counter__)
#endif

// 求整
#if !defined(MM_Int)

    #define __MM_Int_IMPL__(A,B,L)({\
        __typeof__(A) __NSX_PASTE__(__a,L) = (A);\
        __typeof__(B) __NSX_PASTE__(__b,L) = (B);\
        __NSX_PASTE__(__a,L) / __NSX_PASTE__(__b,L);\
    })\

    #define MM_Int(A,B) __MM_Int_IMPL__(A,B,__Counter__)
#endif

#else

// 取余
#if !defined(MM_Mod)
    #define MM_Mod(A,B) ({__typeof__(A) __a = A;__typeof__(B) __b = B; __a % __b;})
#endif

// 求整
#if !defined(MM_Int)
    #define MM_Int(A,B) ({__typeof__(A) __a = A;__typeof__(B) __b = B; __a / __b;})
#endif

#endif

@interface MMCoreTextViewController ()

@end

@implementation MMCoreTextViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIButton * buton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buton setImage:[UIImage imageNamed:@"red_dot"] forState:UIControlStateNormal];
    [buton setImage:nil forState:UIControlStateSelected];
    [buton setTitle:@"normal" forState:UIControlStateNormal];
    [buton setTitle:@"selected" forState:UIControlStateSelected];
    //    [buton setImage:[UIImage imageNamed:@"cell_arrow_right"] forState:UIControlStateHighlighted];
    //    [buton setTitle:@"high" forState:UIControlStateHighlighted];
    [buton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    buton.frame = CGRectMake(0, 200, 90, 50);
    int a = MM_Mod(10,3);
    int c = MM_Mod(34,2);
    int d = MM_Int(8,5);
    int e = MM_Int(14,5);
    int f = MM_Int(7,4);
    int b = MM_Mod(13,9) * 3;
    int bb = 3*MM_Mod(13,9);
//    NSLog(@"__Counter__%d",__Counter__);
//    NSLog(@"%s",__LINE__);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self countingSort];
    [self naiveBubbleSort];
}

- (void)buttonAction:(UIButton *)button{
    button.selected = !button.isSelected;
//    [button setImage:button.isSelected?nil:[UIImage imageNamed:@"red_dot"] forState:UIControlStateNormal];
}

- (void) naiveBubbleSort{
    
    NSMutableArray * a = [@[@(4),@(8),@(0),@(2),@(11),@(7),@(3)] mutableCopy];
    [[a naiveBubbleSort] debugPrint];
}

- (void) countingSort{
    
    // 0-9之间的数字
    NSArray * a = @[@(4),@(8),@(5),@(2),@(4),@(8),@(3)];
    [a debugPrint];
    [[a countingSortWithRange:NSMakeRange(1, 9)] debugPrint];
}
@end
