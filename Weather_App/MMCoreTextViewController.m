//
//  MMCoreTextViewController.m
//  Weather_App
//
//  Created by user1 on 2018/4/26.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MMCoreTextViewController.h"


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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
