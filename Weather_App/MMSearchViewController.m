//
//  MMSearchViewController.m
//  Weather_App
//
//  Created by user1 on 2017/10/17.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMSearchDefaultCollectionView.h"
#import <Masonry/Masonry.h>
#import "AHKBuilder.h"

@protocol MM_testObjBuilder <NSObject>

@property (nonatomic ,retain ,readwrite) NSString * title;
@end

@interface MM_Config : NSObject
@property (nonatomic ,copy) NSString * address;
@end
@implementation MM_Config
@end

@interface MM_testObj : NSObject
@property (nonatomic ,copy) void (^cb)(NSString *text);
@property (nonatomic ,copy) NSString * detail;
@property (nonatomic ,strong) MM_Config * config;
@property (nonatomic ,retain ,readonly) NSString * title;

- (instancetype) initWith:(NSString *)title;
@end
@implementation MM_testObj
- (instancetype) initWith:(NSString *)title{

    if (self == [super init]) {
        _title = title;
    }
    return self;
}

@end

@protocol MMPersonBuilder <NSObject>

@property (nonatomic ,retain ,readwrite) NSString * name;
@property (nonatomic ,assign ,readwrite) NSInteger age;
@property (nonatomic ,retain ,readwrite) NSString * address;

- (void) logInfo;
- (void) crash;
@end

@class MMPersonBuilder;

@interface MMPerson : NSObject
@property (nonatomic ,retain ,readonly) NSString * name;
@property (nonatomic ,assign ,readonly) NSInteger age;
@property (nonatomic ,retain ,readonly) NSString * address;

- (instancetype) initWithBuilder:(MMPersonBuilder *)builder;
- (instancetype) initWithBuilderProtocol:(void(^)(id<MMPersonBuilder>builder))buildHandle;

@end
@implementation MMPerson

- (instancetype) initWithName:(NSString *)name age:(NSInteger)age address:(NSString *)address{
    
    if (self == [super init]) {
        _name = name;
        _age = age;
        _address = address;
    }
    return self;
}

- (instancetype) initWithBuilderProtocol:(void(^)(id<MMPersonBuilder>builder))buildHandle{

    if (self == [super init]) {
        if (buildHandle) {
            id<MMPersonBuilder> _builder;// 初始化
            buildHandle(_builder);
            _name = _builder.name;
            _age = _builder.age;
            _address = _builder.address;
        }
    }
    return self;
}

+ (instancetype) personWith:(void(^)(MMPersonBuilder *builder))buildHandle{
    
//    if (buildHandle) {
//        MMPersonBuilder * builder = [[MMPersonBuilder alloc] init];
//        buildHandle(builder);
//        return [builder build];
//    }
    return nil;
}
- (void) logInfo{
    NSLog(@"this is some log");
}
@end

@interface MMPersonBuilder : NSObject<MMPersonBuilder>

- (MMPerson *) build;

- (MMPersonBuilder *(^)(NSString *name))configName;
- (MMPersonBuilder *(^)(NSInteger age))configAge;
- (MMPersonBuilder *(^)(NSString *address))configAddress;
@end
@implementation MMPersonBuilder
@synthesize address;
@synthesize age;
@synthesize name;

- (MMPerson *) build{
    return [[MMPerson alloc] initWithName:self.name
                                      age:self.age
                                  address:self.address];
}
- (MMPersonBuilder *(^)(NSString *name))configName{
    return ^MMPersonBuilder *(NSString *name ){
        self.name = name;
        return self;
    };
}
- (MMPersonBuilder *(^)(NSInteger age))configAge{
    return ^MMPersonBuilder *(NSInteger age){
        self.age = age;
        return self;
    };
}
- (MMPersonBuilder *(^)(NSString *address))configAddress{
    return ^MMPersonBuilder *(NSString *address ){
        self.address = address;
        return self;
    };
}

@end



@interface MMSearchViewController ()<MMSearchDefaultCollectionViewDelegate>

@property (nonatomic ,strong) MM_SearchDefaultCollectionView * defaultView;

@end

@implementation MMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    
    
    MMPerson * p1 = [[MMPerson alloc] initWithName:@"name" age:20 address:@"shanghai"];

    MMPersonBuilder * p3Builder = [[MMPersonBuilder alloc] init];
    p3Builder.name = @"name";
    p3Builder.age = 20;
    p3Builder.address = @"shanghai";
    MMPerson * p3 = [p3Builder build];
    
    MMPerson * p4 = [MMPerson personWith:^(MMPersonBuilder *builder) {
        builder.name = @"name";
        builder.age = 20;
        builder.address = @"shanghai";
    }];
    
    MMPerson * p5 = [MMPersonBuilder new].configName(@"name").configAge(20).configAddress(@"shanghai").build;
    
    MMPerson * p2 = [[MMPerson alloc] initWithBuilderProtocol:^(id<MMPersonBuilder> builder) {
        builder.name = @"name";
        builder.age = 20;
        builder.address = @"shanghai";
    }];
    
    MMPerson * p6 = [[MMPerson alloc] initWithBuilder_ahk:^(id<MMPersonBuilder>builder) {
        builder.name = @"name";
//        builder.age = 20;
//        builder.address = @"shanghai";
//        [builder logInfo];
//        [builder crash];// 打开这个代码， 运行会崩溃，因为 MMPerson 类没有实现对应的方法
    }];
    
    
    MM_Config * config = [[MM_Config alloc] init];
    config.address = @"10.0.1.181";
    
    MM_testObj * obj = [[MM_testObj alloc] initWith:@"Name"];
    obj.detail = @"Detail";
    obj.config = config;
    NSLog(@"%@/%@",obj.title,obj.detail);// Name/Detail
    
    MM_testObj * obj_1 = [[MM_testObj alloc] initWithBuilder_ahk:^(id<MM_testObjBuilder>builder) {
        builder.title = @"Name_1";
    }];
    NSLog(@"%@/%@",obj_1.title,obj_1.detail);// Name_1/(null)
    
    MM_testObj * obj_2 = [obj copyWithBuilder_ahk:^(id<MM_testObjBuilder>builder) {
        
    }];
    NSLog(@"%@/%@",obj_2.title,obj_2.detail);// Name/Detail
    
    MM_testObj * obj_3 = [obj copyWithBuilder_ahk:^(id<MM_testObjBuilder>builder) {
        builder.title = @"Name_3";
    }];
    NSLog(@"%@/%@",obj_3.title,obj_3.detail);// Name_3/Detail
    NSLog(@"config:%@",obj_3.config.address);
    NSLog(@"%d",obj_3.config == config);
    
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 20;
    self.defaultView = [[MM_SearchDefaultCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.defaultView.handleDelegate = self;
    self.defaultView.historyArray = @[@"sdfs",@"sdfdvd",@"rweef"];
    self.defaultView.labelArray = @[@"sdfdsf",@"3r3",@"sdfdfd",@"g3gerg",@"g34gerfergergaerg",@"dgdfgfd",@"dfgdg4",@"dfg34ger",@"g34geg",@"gdt4",@"f34gergd",@"43g3erg",@"g34ger",@"dfg3gr",@"34gf"];
    self.defaultView.recommandArray = @[@"g3gerg",@"dfgdg4",@"dfg34ger",@"[][]jhk",@"g34gerfergergaerg",@"dgdfgfd",@"f34gergd",@"43g3erg",@"g34ger",@"g34geg",@"gdt4",@"dfg3gr",@"34gf"];
    [self.view addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - MMSearchDefaultCollectionViewDelegate

// 清空搜索历史
- (void) searchDefaultCollectionViewDidCleanSearchHistory:(MM_SearchDefaultCollectionView *)collectionView{
    
    
}

// 点击某一个cell
- (void) searchDefaultCollectionView:(MM_SearchDefaultCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
