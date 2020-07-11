//
//  XXXLivingRoomViewController.m
//  Weather_App
//
//  Created by skynet on 2020/5/7.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXLivingRoomViewController.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import <IGListDiffKit/IGListDiffKit.h>

typedef struct XXXEventWrap{
    NSString *name;
    SEL method;
} XXXEventWrap;

NS_INLINE XXXEventWrap
XXXEventWrapMake(NSString *name, SEL method){
    XXXEventWrap event;
    event.name = name;
    event.method = method;
    return event;
};

NS_INLINE XXXEventWrap
XXXEventWrapFromNSValue(NSValue * value){
    XXXEventWrap event;
    [value getValue:&event];
    return event;
};

NS_INLINE NSValue *
NSValueFromEventWrap(XXXEventWrap event){
    return ({
        [NSValue valueWithBytes:&event
                       objCType:@encode(struct XXXEventWrap)];
    });
};

NS_INLINE NSValue *
NSValueFromEventAndMethod(NSString * name, SEL method){
    return NSValueFromEventWrap(XXXEventWrapMake(name, method));
};

@interface XXXDiffObject : NSObject<IGListDiffable>
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,assign) NSInteger age;

+ (instancetype) object:(NSString *)name age:(NSInteger)age;
@end
@interface XXXEventProxy : NSObject{
    NSSet<NSValue *> * _eventStrategy;
}
- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end

@interface UIResponder (XXXRouter)
- (void)routerEventWithName:(NSString *)eventName;
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end

@interface XXXContentView : UIView

@end

@interface XXXSubView : UIView

@end

@interface XXXLivingRoomEventProxy : XXXEventProxy
- (instancetype) initWithController:(__kindof UIViewController *)controller;
@end

@interface XXXLivingRoomViewController ()

@property (nonatomic ,strong) XXXLivingRoomEventProxy * eventProxy;
@property (nonatomic ,strong) XXXContentView * oneContentView;
@end

@implementation XXXLivingRoomViewController
-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventProxy = [[XXXLivingRoomEventProxy alloc] initWithController:self];
    
    self.oneContentView = [XXXContentView new];
    [self.view addSubview:self.oneContentView];
    
    [self.oneContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
        }
    }];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    [self.eventProxy handleEvent:eventName userInfo:userInfo];
}
@end

@implementation XXXContentView
-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        
        XXXSubView * subView = [XXXSubView new];
        [self addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(300);
        }];
    }
    return self;
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    NSMutableDictionary * tmp = [userInfo mutableCopy];
    // 如果中间视图需要追加数据，可以重写方法，识别对应的event然后修改userInfo
    if ([eventName isEqualToString:@"sub-view-button2-click"]) {
        tmp[@"addKey"] = @"addValue";
    }
    [[self nextResponder] routerEventWithName:eventName userInfo:tmp.copy];
}
@end

@implementation XXXSubView
-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        UIButton * button = [UIButton new];
        [button setTitle:@"This is Button" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButton)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 30));
            make.center.equalTo(self);
        }];
        
        UIButton * button2 = [UIButton new];
        [button2 setTitle:@"This is Button 2" forState:UIControlStateNormal];
        [button2 setTitleColor:UIColor.purpleColor forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(onButton2)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 30));
            make.top.equalTo(button.mas_bottom).mas_offset(20);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

- (void) onButton{
    [self routerEventWithName:@"sub-view-button-click"];
}
- (void) onButton2{
    [self routerEventWithName:@"sub-view-button2-click" userInfo:@{@"key":@"name"}];
}

@end

@implementation UIResponder (XXXRouter)
- (void)routerEventWithName:(NSString *)eventName{
    [self routerEventWithName:eventName userInfo:nil];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if (nil != eventName) {
        [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
    }
}
@end

@interface XXXEventProxy()
@property (nonatomic, copy) NSSet<NSValue *> *eventStrategy;
@end

@implementation XXXEventProxy

-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}

- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    
    __block NSDictionary * strongUserInfo = userInfo;
    [self.eventStrategy enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
        XXXEventWrap event = XXXEventWrapFromNSValue(obj);
        if ([event.name isEqualToString:eventName]) {
            NSInvocation *invocation = [self createInvocationWithSelector:event.method];
            if (invocation) {
                if (invocation.methodSignature.numberOfArguments > 2) {
                    [invocation setArgument:&strongUserInfo atIndex:2];
                }
                [invocation invoke];
            }
            *stop = YES;
        }
    }];
}

#pragma mark - private

- (NSInvocation *)createInvocationWithSelector:(SEL)sel{
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    inv.selector = sel;
    inv.target = self;
    return inv;
}
@end

@interface XXXLivingRoomEventProxy ()
@property (nonatomic ,weak) XXXLivingRoomViewController * controller;
@end
@implementation XXXLivingRoomEventProxy

-(instancetype)initWithController:(__kindof UIViewController *)controller{
    self = [super init];
    if (self) {
        self.controller = controller;
        _eventStrategy = [NSSet setWithArray:({
            @[NSValueFromEventAndMethod(@"sub-view-button-click",
                                        @selector(onSubViewButtonClick)),
              NSValueFromEventAndMethod(@"sub-view-button2-click",
                                        @selector(onSubViewButton2Click:))];
        })];
    }
    return self;
}

- (void) onSubViewButtonClick{
    NSLog(@"onSubViewButtonClick");
    [self.controller presentViewController:({
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"MEssage" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"alert sure");
            }];
        })];
        alert;
    }) animated:YES completion:nil];
}

- (void) onSubViewButton2Click:(NSDictionary *)info{
    NSLog(@"onSubViewButton2Click:%@",info);
    
    XXXDiffObject * one = [XXXDiffObject object:@"aa" age:10];
    XXXDiffObject * two = [XXXDiffObject object:@"b" age:20];
    XXXDiffObject * three = [XXXDiffObject object:@"cc" age:30];
    XXXDiffObject * four = [XXXDiffObject object:@"four" age:40];
    
    XXXDiffObject * nOne = [XXXDiffObject object:@"a" age:100];
    XXXDiffObject * nTwo = [XXXDiffObject object:@"b" age:200];
    XXXDiffObject * nThree = [XXXDiffObject object:@"c" age:300];
    XXXDiffObject * nFour = [XXXDiffObject object:@"nfour" age:400];
    if (0) {
        NSArray * old = @[@1,@22,@33,@4,@55];
        NSArray * new = @[@11,@3,@4,@6];
        IGListIndexSetResult * result = IGListDiff(old, new, IGListDiffPointerPersonality);
    }
    if (0){
        NSArray * old = @[one,two,three];
        NSArray * new = @[nOne,nThree,nTwo];
        IGListIndexSetResult * result = IGListDiff(old, new, IGListDiffEquality);
        NSLog(@"result:%@",result);
    }
}
@end

@implementation XXXDiffObject

#pragma mark - <IGListDiffable>
+ (instancetype) object:(NSString *)name age:(NSInteger)age{
    XXXDiffObject * obj = [XXXDiffObject new];
    obj.name = name;
    obj.age = age;
    return obj;
}

- (id<NSObject>)diffIdentifier {
    return self.name;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    BOOL isSameClass = [(NSObject *)object isKindOfClass:XXXDiffObject.class];
    if (!isSameClass) {
        return NO;
    }
    BOOL isDiffIdentifierEqual = [self.diffIdentifier isEqual:object.diffIdentifier];
    BOOL isSameAge = self.age == [(XXXDiffObject *)object age];
    
    return isDiffIdentifierEqual && isSameAge;
}

@end
