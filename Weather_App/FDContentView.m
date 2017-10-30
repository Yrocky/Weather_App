//
//  FDContentView.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/30.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDContentView.h"
#import "ANYMethodLog.h"
#import <objc/runtime.h>

//@interface UIScrollView (handlePan)
//- (void) fd_handlePan:(UIPanGestureRecognizer *)gesture;
//@end;
//
//@implementation UIScrollView (handlePan)
//- (void) fd_handlePan:(UIPanGestureRecognizer *)gesture{
//
////    [self fd_handlePan:gesture];
//}
//@end

@interface FDContentView (FD_Swizz)
+ (void)fd_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;
+ (void)fd_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2;
@end;

@implementation FDContentView (FD_Swizz)

+ (void)fd_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
//    bool isFDContentView = [NSStringFromClass([self class]) isEqualToString:@"FDContentView"];
//    if (isFDContentView) {
//
//        method_exchangeImplementations(class_getInstanceMethod([self class], method1), class_getInstanceMethod([self class], method2));
//    }
}

+ (void)fd_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
//    bool isFDContentView = [NSStringFromClass([self class]) isEqualToString:@"FDContentView"];
//    if (isFDContentView) {
//
//        method_exchangeImplementations(class_getClassMethod([self class], method1), class_getClassMethod([self class], method2));
//    }
}
@end

@implementation FDContentView

+ (void)load{
    
    SEL handlePan = NSSelectorFromString(@"handlePan:");
    [self fd_exchangeInstanceMethod1:handlePan method2:@selector(fd_handlePan:)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [ANYMethodLog logMethodWithClass:[FDContentView class] condition:^BOOL(SEL sel) {
//
//            return [NSStringFromSelector(sel) isEqualToString:@"handlePan:"];
//        } before:^(id target, SEL sel, NSArray *args, int deep) {
//
//            NSLog(@" before target:%@ sel:%@",target,NSStringFromSelector(sel));
//
//            [target fd_handlePan:args[0]];
//
//        } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//
//        }];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 只能是 @implementation 里面的方法
//        [ANYMethodLog logMethodWithClass:[FDContentView class] condition:^BOOL(SEL sel) {
//
//            return [NSStringFromSelector(sel) isEqualToString:@"handlePan:"];
//        } before:^(id target, SEL sel, NSArray *args, int deep) {
//
////            NSLog(@" before target:%@ sel:%@",target,NSStringFromSelector(sel));
//
//            [target fd_handlePan:args[0]];
//
//        } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//
//        }];
    }
    return self;
}

- (void) fd_handlePan:(UIPanGestureRecognizer *)gesture{

    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        bool contentViewCanBounceVertical = NO;
        if (@available(iOS 11.0, *)) {
            contentViewCanBounceVertical = self.contentOffset.y <= 0;
        } else {
            contentViewCanBounceVertical = self.contentOffset.y <= -20;
        }
        if (contentViewCanBounceVertical) {
            [self fd_handlePan:gesture];
        }
        self.alwaysBounceVertical = contentViewCanBounceVertical;
        NSLog(@"changed contentOffset.y : %f \n %d",self.contentOffset.y,contentViewCanBounceVertical);
    }else{
        self.alwaysBounceVertical = YES;
        [self fd_handlePan:gesture];
    }
}
//
//- (void) handlePan:(UIPanGestureRecognizer *)gesture{
//
//    NSLog(@"------ %@ ",gesture);
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"began contentOffset.y : %f",self.contentOffset.y);
//    }
//    if (gesture.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"changed contentOffset.y : %f",self.contentOffset.y);
//    }
//
//    [super handlePan:gesture];
//}
@end
