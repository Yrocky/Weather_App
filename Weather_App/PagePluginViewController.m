//
//  PagePluginViewController.m
//  Weather_App
//
//  Created by rocky on 2020/11/13.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "PagePluginViewController.h"

@interface PagePluginViewController ()

@property (nonatomic,strong) dispatch_queue_t asyncQueue;

@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,strong) dispatch_group_t group;
@end
/*
 1）模块化 – 业务实体进行模块化，模块与模块呈现一定的组织形式；
 2）插件化 – 功能单元插件化，满足功能单元可组合、可拆解、可替换；统一接口
 3）数据 Key-Value 化 – 极简数据组织形式，减除因数据模型引入的依赖。也就是去model
 
 在UI层面上抽象4个模块：页面、抽屉、组件、坑位，从下往上依次可以作为小模块嵌入到上一层中
 
 * 页面：导航栏、管理列表容器(tableView/collectionView)、上拉下拉刷新、空态，以及页面级的网络请求、数据缓存、埋点
 * 抽屉：列表容器在这一层的布局管理：平铺、多tab翻页，以及抽屉级的网络请求
 * 组件：列表容器的布局管理（多行多列、平铺、瀑布流、水平滑动、轮播），以及组件级别的网络数据请求
 * 坑位：具体的ui（属于局部的ui）、手势响应、路由跳转（点击cell的跳转放在了这里）、埋点统计（局部ui的点击、曝光等）
 
 以上就是这个架构的宏观抽象，每一个功能可能和上面的每一个模块有联系，同时一个功能对应一个或多个插件。也就是说，模块的具体功能由插件承载，模块内外的功能通过事件传递消息和数据（也就是一个EventBus，或者叫做通知中心模式）
 
 4个Manager角色
 1）ModuleManager 负责模块的生命周期和关系管理；
 2）PluginManager 负责模块与插件的关系管理；
 3）EventManager 负责模块内外，插件与插件之间的消息通信；
 4）DataManager 负责模块的数据管理。
 
 将具体的列表容器（tableView/collectionView）、布局逻辑、埋点统计、网络请求、手势交互、路由跳转等等进行抽象，使用插件来表示。
 
 也就是说，最终落实的架构是n个插件+4个管理模块
 
 
 插件、功能单元和模块的关系有以下 4 点：

 1）一个模块实例关联多个插件实例，但一个插件实例仅对应一个模块实例；
 2）模块初始化时，完成全部所属插件的挂载，插件的生命周期与模块的生命周期基本同步，不允许中途某一时刻外挂或卸载某一插件；
 3）单一模块内的一项业务功能，即一个功能单元，由一个或多个插件组成承载；
 4）跨模块的一项业务功能，即一个跨模块功能单元，由分属多个模块的多个插件协同承载。
 
 */

@protocol ContextAble <NSObject>
//@property (nonatomic, copy) NSString *identifier; /// 模块 Id，全局唯一
@end 

@interface Context : NSObject<ContextAble>
@end
@implementation Context
@end

// 抽象4个模块，使用Context来表示的作用是：表示模块本身，以及模块关系的语法糖
@interface PageContext : NSObject<ContextAble>
@end
@implementation PageContext
@end

@interface ModuleContext : NSObject<ContextAble>
@end
@implementation ModuleContext
@end

@interface ComponentContext : NSObject<ContextAble>
@end
@implementation ComponentContext
@end

@interface ItemContext : NSObject<ContextAble>
@end
@implementation ItemContext
@end

@interface SCModuleManager : NSObject
+ (instancetype)sharedInstance;
- (void)registerModule:(NSString *)module superModule:(NSString *)supermodule;/// 注册模块
- (void)unregisterModule:(NSString *)module; /// 注销模块
- (NSString *)querySuperModule:(NSString *)module; /// 查询父模块
- (NSArray<NSString *> *)querySubModules:(NSString *)module; /// 查询子模块
@end
@implementation SCModuleManager
@end
/*
 数据中心为每个模块开辟一块独立的空间存放数据，(这个是如何做到的？)
 这是保证不同模块数据不串扰又同时保证同一模块内数据共享
 
 由于使用了Key-value的数据存储（去model），value只能是基本数据类型
 * int、double、bool
 * NSString
 * NSArray、NSDictionary等
 * NSValue
 
 这里应该避免使用自定义的模型，否则就违背了Key-Value化的本质
 
 这一句话还不错：在ViewController中，列表逻辑、网络、导航（界面跳转、popup视图的展示）、实现各种协议等等功能都堆积在一起，导致ViewController很臃肿。
 */
@interface SCDataManager : NSObject
+ (instancetype)sharedInstance;
// 设置数据
- (void) setData:(id)propertyValue
          forKey:(NSString *)propertyKey
        moduleId:(NSString *)moduleId;
// 获取数据
- (id) dataForKey:(NSString *)propertyKey
         moduleId:(NSString *)moduleId;
@end
@implementation SCDataManager
@end
@interface SCEventManager : NSObject
+ (instancetype)sharedInstance;
- (NSDictionary *) fireEvent:(NSString *)eventName module:(NSString *)moduleId params:(NSDictionary *)params;
@end
@implementation SCEventManager
@end
@interface SCEvent : NSObject
@property (nonatomic ,copy) NSDictionary * responseInfo;
@end
@implementation SCEvent
@end
/*
 在插件的使用上具有非常灵活的特性，因此我们约定插件边界必须清晰，
 必须做到单一职责原则，输入输出明确并足够简单，
 如果不满足以上条件，则表示该插件有拆解细分的可能性和必要。
 */
@implementation PagePluginViewController{
    
}

- (void) ql_addGroupRequestOfBackpack{
    dispatch_group_enter(self.group);

    // 异步操作
    dispatch_async(self.asyncQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // ui刷新
            self.view.backgroundColor = [UIColor redColor];
            NSLog(@"thread:%@",NSThread.currentThread);
            dispatch_group_leave(self.group);
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.asyncQueue = dispatch_queue_create("sdd", NULL);
    
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
    
    dispatch_group_async(self.group, self.queue, ^{
        [self ql_addGroupRequestOfBackpack];
    });
    
    // 写入数据[[SCDataManager sharedInstance] setdata:propertyValue forKey:propertyKey moduleId:moduleId];
    // 读取数据[[SCDataManager sharedInstance] dataForKey:propertyKey moduleId:moduleId];
    // 每个模块的数据都存放在数据中心内。
    
    // 事件发布
    NSString *eventName = @"demoEvent";
    NSString *moduleId = @"...";
    NSDictionary *params = @{};
//    NSDictionary *response =
//    [[SCEventManager sharedInstance]
//     fireEvent:eventName module:moduleId params:params];
    
//    [featureA step1];
//    [featureB step1];
//    [featureC step1];
}
// 事件订阅、处理
+ (NSArray *)scEventHandlerInfo{
    return @[
        @{
            @"event": @"demoEvent",
            @"selector": @"receiveDemoEvent:",
            @"priority": @500
        }
    ];
}

- (void)receiveDemoEvent:(SCEvent *)event{
    //do something  ...
    event.responseInfo = @{}; // 返回值 (可选);
    
}
- (void)callback_xxx {
//    [featureA step2];
//    [featureB step2];
}
- (void)callback_yyy {
//    [featureC step2];
}
@end
