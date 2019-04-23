//
//  ExtensionViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "ExtensionViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "BillExtensionView.h"
#import "HLLAlert.h"
#import "BillInputView.h"
#import "BillKeyboardView.h"
#import "MMSingleton.h"
#import "NSArray+Sugar.h"

@interface ArrayWrap : NSObject
@property (nonatomic ,copy) NSString * name;
+ (instancetype) wrap:(NSString *)name;
@end
@implementation ArrayWrap
+ (instancetype) wrap:(NSString *)name{
    return [[self alloc] initWith:name];
}
- (instancetype) initWith:(NSString *)name{

    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}
@end

@interface MutableArrayWrap : ArrayWrap
@end
@implementation MutableArrayWrap
@end

@interface ExtensionViewController ()<BillExtensionViewDelegate>

@property (nonatomic ,strong) BillInputView * inputView;
@property (nonatomic ,strong) BillKeyboardView * keyboardView;
@property (nonatomic ,strong) MASConstraint * keyboardViewBottomConstraint;
@property (nonatomic ,strong) BillExtensionView * extensionView;
@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拓展功能";
    self.view.backgroundColor = [UIColor whiteColor];
    [self singleton];
    
    ///<使用谓词对数组进行filter的时候，如果谓词中有使用class作为条件来过滤数组，那么这个类不支持向下拓展，也就是说，他不支持class的子类，只能找到指定的类的实例对象
    ///<像下面的例子中，如果谓词中有 ‘class == %@,[ArrayWrap class]’这样的条件，只能从array数组中过滤出来四个元素（1，2，3，5），而不是六个元素（33，55不符合条件）
    ///<这样的问题如何解决呢？？？
    NSArray * array = @[[ArrayWrap wrap:@"1"],
                        [ArrayWrap wrap:@"2"],
                        [MutableArrayWrap wrap:@"33"],
                        [ArrayWrap wrap:@"3"],
                        [MutableArrayWrap wrap:@"55"],
                        [ArrayWrap wrap:@"5"],];
    
    [[array filteredArrayUsingPredicate:
      [NSPredicate predicateWithFormat:@"class == %@",[ArrayWrap class]]]
     mm_each:^(ArrayWrap * wrap) {
         NSLog(@"ArrayWrap:%@",wrap.name);
    }];
    // Do any additional setup after loading the view.
}

- (void) singleton{
    MMSingleton * mgr = [MMSingleton mgr];
    NSLog(@"mgr:%@",mgr);
    
//    MMSingleton * allocInit = [[MMSingleton alloc] init];
//    NSLog(@"allocInit:%@",allocInit);
    
    MMSingleton * copyMgr = [mgr copy];
    NSLog(@"copyMgr:%@",copyMgr);
    
    MMSingleton * mutableCopyMgr = [mgr mutableCopy];
    NSLog(@"mutableCopyMgr:%@",mutableCopyMgr);
    
    MMSubSingleton * subMgr = [MMSubSingleton mgr];
    subMgr.name = @"subMgr";
    NSLog(@"subMgr:%@",subMgr);
    
    MMSubSingleton * subAllocInitMgr = [[MMSubSingleton alloc] init];
    NSLog(@"subAllocInitMgr:%@",subAllocInitMgr);
    
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        MMSingleton * threadMgr = [MMSingleton mgr];
        NSLog(@"threadMgr:%@",threadMgr);
    }];
    [thread start];
}

- (void) bill{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat keyboardHeight = (screenWidth - 3)/1.68 + 3;
    
    self.inputView = [[BillInputView alloc] init];
    [self.view addSubview:self.inputView];
    
    self.keyboardView = [[BillKeyboardView alloc] init];
    [self.view addSubview:self.keyboardView];
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(keyboardHeight);
        if (@available(iOS 11.0, *)) {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            self.keyboardViewBottomConstraint = make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    return;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.keyboardView.mas_top).mas_offset(-20);
    }];
    
    BillExtensionView * extensionView = [[BillExtensionView alloc] init];
    extensionView.delegate = self;
    [self.view addSubview:extensionView];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.inputView.mas_bottom);
        make.bottom.mas_equalTo(self.keyboardView.mas_bottom).mas_offset(-40);
    }];
    self.extensionView = extensionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    

@end
