//
//  HLLAlert.m
//  One
//
//  Created by Rocky Young on 2017/2/21.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import "HLLAlert.h"

static NSString * const kAlertActionSheetHandleDisplayText = @"handleDisplayText";
static NSString * const kAlertActionSheetHandleStyle = @"handleStyle";

@interface HLLAlertActionSheetModel : NSObject

@property (strong, nonatomic) UIAlertController * alertVC;

@property (strong, nonatomic) NSString *title; // 标题
@property (strong, nonatomic) NSString *message; // 内容
@property (nonatomic ,strong) NSMutableArray * handleButtons;

@property (nonatomic ,copy) void (^bClickHandle)(NSInteger index);

@end

@implementation HLLAlertActionSheetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _handleButtons = [NSMutableArray array];
    }
    return self;
}

- (BOOL) isInvaild:(NSInteger)index{
    
    return self.handleButtons && self.handleButtons.count && index < self.handleButtons.count;
}
@end

@interface HLLAlert : NSObject<HLLAlertActionSheetProtocol>

@property (nonatomic ,strong) HLLAlertActionSheetModel * aModel;

#pragma mark - config

+ (HLLAlert *) alert;

@end

@implementation HLLAlert

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aModel = [[HLLAlertActionSheetModel alloc] init];
    }
    return self;
}

+ (HLLAlert *) alert{
    
    return [[HLLAlert alloc] init];
}

- (HLLAlert *) title:(NSString *)titile{
    
    self.aModel.title = titile;
    return self;
}

- (HLLAlert *) message:(NSString *)message{
    
    self.aModel.message = message;
    return self;
}

- (HLLAlert *) buttons:(NSArray *)buttons{
    
    if (buttons && buttons.count) {
        for (NSString * handle in buttons) {
            NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:@{kAlertActionSheetHandleDisplayText:handle,kAlertActionSheetHandleStyle:@(0)}];
            [self.aModel.handleButtons addObject:handleDic];
        }
    }
    return self;
}

- (HLLAlert *) buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if(buttonTitles){
        NSMutableArray *buttons = [NSMutableArray array];
        va_list args;
        va_start(args, buttonTitles);
        for (NSString *str = buttonTitles; str != nil; str = va_arg(args,NSString*)) {
            [buttons addObject:str];
        }
        va_end(args);
        
        if (buttons && buttons.count) {
            for (NSString * handle in buttons) {
                NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:@{kAlertActionSheetHandleDisplayText:handle,kAlertActionSheetHandleStyle:@(0)}];
                [self.aModel.handleButtons addObject:handleDic];
            }
        }
    }
    
    return self;
}

- (HLLAlert *) style:(UIAlertActionStyle)style index:(NSInteger)index{
    
    NSAssert([self.aModel isInvaild:index], @"Your `handleButtons` MUST BE nunull, AND the `index` less then handleButtons's length.");
    
    NSMutableDictionary * dictionary = self.aModel.handleButtons[index];
    dictionary[kAlertActionSheetHandleStyle] = @(style);
    
    [self.aModel.handleButtons replaceObjectAtIndex:index withObject:dictionary];
    return self;
}

- (HLLAlert *) fetchClick:(void (^)(NSInteger index))click{
    
    self.aModel.bClickHandle = click;
    return self;
}

- (HLLAlert *) show{
    
    return [self showIn:nil];
}

- (HLLAlert *) showIn:(__kindof UIViewController *)vc{
    
    self.aModel.alertVC = [UIAlertController alertControllerWithTitle:self.aModel.title message:self.aModel.message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < self.aModel.handleButtons.count; i++) {
        NSDictionary * handle = self.aModel.handleButtons[i];
        
        NSString * title = handle[kAlertActionSheetHandleDisplayText];
        UIAlertActionStyle style = [handle[kAlertActionSheetHandleStyle] integerValue];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (self.aModel.bClickHandle) {
                self.aModel.bClickHandle(i);
            }
        }];
        [self.aModel.alertVC addAction:action];
    }
    if (!vc) {
        vc = [HLLAlertActionSheet getPresentedViewController];//[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [vc presentViewController:self.aModel.alertVC animated:YES completion:nil];
    return self;
}

@end


@interface HLLActionSheet : NSObject<HLLAlertActionSheetProtocol>

@property (nonatomic ,strong) HLLAlertActionSheetModel * aModel;

@property (nonatomic ,copy) void (^bHideHandle)();

#pragma mark - config

+ (HLLActionSheet *) actionSheet;
@end

@implementation HLLActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aModel = [[HLLAlertActionSheetModel alloc] init];
    }
    return self;
}

+ (HLLActionSheet *) actionSheet{
    
    return [[HLLActionSheet alloc] init];
}

- (HLLActionSheet *) title:(NSString *)titile{
    
    self.aModel.title = titile;
    return self;
}
- (HLLActionSheet *) message:(NSString *)message{
    
    self.aModel.message = message;
    return self;
}
- (HLLActionSheet *) buttons:(NSArray *)buttons{
    
    if (buttons && buttons.count) {
        for (NSString * handle in buttons) {
            NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:@{kAlertActionSheetHandleDisplayText:handle,kAlertActionSheetHandleStyle:@(0)}];
            [self.aModel.handleButtons addObject:handleDic];
        }
    }
    return self;
}

- (HLLActionSheet *) buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    if(buttonTitles){
        NSMutableArray *buttons = [NSMutableArray array];
        va_list args;
        va_start(args, buttonTitles);
        for (NSString *str = buttonTitles; str != nil; str = va_arg(args,NSString*)) {
            [buttons addObject:str];
        }
        va_end(args);
        
        if (buttons && buttons.count) {
            for (NSString * handle in buttons) {
                NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:@{kAlertActionSheetHandleDisplayText:handle,kAlertActionSheetHandleStyle:@(0)}];
                [self.aModel.handleButtons addObject:handleDic];
            }
        }
    }
    
    return self;
}


- (HLLActionSheet *) style:(UIAlertActionStyle)style index:(NSInteger)index{
    
    NSAssert([self.aModel isInvaild:index], @"Your `handleButtons` MUST BE nunull, AND the `index` less then handleButtons's length.");
    
    NSMutableDictionary * dictionary = self.aModel.handleButtons[index];
    dictionary[kAlertActionSheetHandleStyle] = @(style);
    
    [self.aModel.handleButtons replaceObjectAtIndex:index withObject:dictionary];
    return self;
}

- (HLLActionSheet *) fetchClick:(void (^)(NSInteger index))click{
    
    self.aModel.bClickHandle = click;
    return self;
}

- (HLLActionSheet *)hide:(void (^)())hide{
    
    self.bHideHandle = hide;
    return self;
}

- (HLLActionSheet *) show{
    
    return [self showIn:nil];
}

- (HLLActionSheet *) showIn:(__kindof UIViewController *)vc{
    
    self.aModel.alertVC = [UIAlertController alertControllerWithTitle:self.aModel.title message:self.aModel.message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < self.aModel.handleButtons.count; i++) {
        NSDictionary * handle = self.aModel.handleButtons[i];
        
        NSString * title = handle[kAlertActionSheetHandleDisplayText];
        UIAlertActionStyle style = [handle[kAlertActionSheetHandleStyle] integerValue];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (self.aModel.bClickHandle) {
                self.aModel.bClickHandle(i);
            }
        }];
        [self.aModel.alertVC addAction:action];
    }
    if (!vc) {
        vc = [HLLAlertActionSheet getPresentedViewController];//[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [vc presentViewController:self.aModel.alertVC animated:YES completion:nil];
    return self;
}

@end

@implementation HLLAlertActionSheet

#pragma mark - config

+ (id<HLLAlertActionSheetProtocol>) alert{
    
    return [HLLAlert alert];
}

+ (id<HLLAlertActionSheetProtocol>) actionSheet{
    
    return [HLLActionSheet actionSheet];
}

+ (__kindof UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    do {
        NSLog(@"topVC-start:%@",topVC);
        NSLog(@"topVC.presentedViewController-start:%@",topVC.presentedViewController);
        topVC = topVC.presentedViewController;
        NSLog(@"topVC-end:%@",topVC);
        NSLog(@"topVC.presentedViewController-end:%@",topVC.presentedViewController);
        NSLog(@"+++++++++++++");
    } while (topVC.presentedViewController);
    
    return topVC;
}
@end
