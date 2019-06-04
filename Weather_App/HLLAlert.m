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

@property (weak, nonatomic) UIAlertController * alertVC;

@property (strong, nonatomic) NSString *title; // 标题
@property (strong, nonatomic) NSString *message; // 内容
@property (nonatomic ,strong) NSMutableArray * handleButtons;

@property (nonatomic ,copy) void (^bClickHandle)(NSInteger index);

@end

@implementation HLLAlertActionSheetModel

- (void)dealloc{
    NSLog(@"%@ dealloc",self);
}

- (instancetype)init{
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

@interface InternalAlert : NSObject<HLLAlertActionSheetProtocol>
@property (nonatomic ,strong) HLLAlertActionSheetModel * aModel;

- (UIAlertControllerStyle) style;
@end

@implementation InternalAlert
- (void)dealloc{
    NSLog(@"%@ dealloc",self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aModel = [[HLLAlertActionSheetModel alloc] init];
    }
    return self;
}

- (instancetype) title:(NSString *)titile{
    
    self.aModel.title = titile;
    return self;
}

- (instancetype) message:(NSString *)message{
    
    self.aModel.message = message;
    return self;
}

- (instancetype) buttons:(NSArray *)buttons{
    
    if (buttons && buttons.count) {
        for (NSString * handle in buttons) {
            NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:
                                        @{kAlertActionSheetHandleDisplayText:handle,
                                          kAlertActionSheetHandleStyle:@(UIAlertActionStyleDefault)}];
            [self.aModel.handleButtons addObject:handleDic];
        }
    }
    return self;
}

- (instancetype) buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
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
                NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:
                                            @{kAlertActionSheetHandleDisplayText:handle,
                                              kAlertActionSheetHandleStyle:@(UIAlertActionStyleDefault)}];
                [self.aModel.handleButtons addObject:handleDic];
            }
        }
    }
    return self;
}

- (instancetype) style:(UIAlertActionStyle)style index:(NSInteger)index{
    
    NSAssert([self.aModel isInvaild:index], @"Your `handleButtons` MUST BE nunull, AND the `index` less then handleButtons's length.");
    
    NSMutableDictionary * dictionary = self.aModel.handleButtons[index];
    dictionary[kAlertActionSheetHandleStyle] = @(style);
    
    [self.aModel.handleButtons replaceObjectAtIndex:index withObject:dictionary];
    return self;
}
- (id<HLLAlertActionSheetProtocol>) addButton:(void (^)(NSInteger index))click title:(NSString *)title style:(UIAlertActionStyle)style{
    
    NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:
                                @{kAlertActionSheetHandleDisplayText:title,
                                  kAlertActionSheetHandleStyle:@(style)}];
    [self.aModel.handleButtons addObject:handleDic];
    self.aModel.bClickHandle = click;
    return self;
}
- (id<HLLAlertActionSheetProtocol>) addCancelButton:(NSString *)title{
    NSDictionary * handleDic = [NSMutableDictionary dictionaryWithDictionary:
                                @{kAlertActionSheetHandleDisplayText:title,
                                  kAlertActionSheetHandleStyle:@(UIAlertActionStyleCancel)}];
    [self.aModel.handleButtons addObject:handleDic];
    return self;
}
- (instancetype) fetchClick:(void (^)(NSInteger index))click{
    
    self.aModel.bClickHandle = click;
    return self;
}

- (instancetype) show{
    
    return [self showIn:nil];
}

- (instancetype) showIn:(__kindof UIViewController *)vc{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:self.aModel.title message:self.aModel.message preferredStyle:[self style]];
    self.aModel.alertVC = alertVC;
    
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
- (void)dismiss{
    
    [self dismiss:nil];
}

- (void) dismiss:(void (^ __nullable)(void))completion{
    
    [self.aModel.alertVC dismissViewControllerAnimated:YES completion:completion];
}

- (UIAlertControllerStyle) style{
    return UIAlertControllerStyleAlert;
}
@end

@interface HLLAlert : InternalAlert

#pragma mark - config
+ (HLLAlert *) alert;
@end

@implementation HLLAlert

+ (HLLAlert *) alert{
    return [[HLLAlert alloc] init];
}

- (UIAlertControllerStyle) style{
    return UIAlertControllerStyleAlert;
}

@end

@interface HLLActionSheet : InternalAlert

@property (nonatomic ,copy) void (^bHideHandle)();

#pragma mark - config
+ (HLLActionSheet *) actionSheet;
@end

@implementation HLLActionSheet

+ (HLLActionSheet *) actionSheet{
    
    return [[HLLActionSheet alloc] init];
}

- (HLLActionSheet *)hide:(void (^)())hide{
    
    self.bHideHandle = hide;
    return self;
}
- (UIAlertControllerStyle) style{
    return UIAlertControllerStyleActionSheet;
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
    // bug here
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController){
        NSLog(@"topVC-start:%@",topVC);
        NSLog(@"topVC.presentedViewController-start:%@",topVC.presentedViewController);
        topVC = topVC.presentedViewController;
        NSLog(@"topVC-end:%@",topVC);
        NSLog(@"topVC.presentedViewController-end:%@",topVC.presentedViewController);
        NSLog(@"+++++++++++++");
    }
    
    return topVC;
}
@end
