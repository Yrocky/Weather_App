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

@interface FDContentView (FD_Swizzling)
@end;

@implementation FDContentView (FD_Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = NSSelectorFromString(@"handlePan:");
        SEL swizzledSelector = NSSelectorFromString(@"fd_handlePan:");
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

@end

@interface FDContentView()<UIScrollViewDelegate>

@property (nonatomic ,assign) CGFloat contentViewBeginPointY;

@property (nonatomic ,assign) CGFloat contentViewNextPointY;

@end
@implementation FDContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
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
        
        self.delegate = self;
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
//            [self fd_handlePan:gesture];
        }
//        self.alwaysBounceVertical = contentViewCanBounceVertical;
//        NSLog(@"changed contentOffset.y : %f \n %d",self.contentOffset.y,contentViewCanBounceVertical);
    }else{
//        self.alwaysBounceVertical = YES;
    }
    [self fd_handlePan:gesture];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.contentViewNextPointY = scrollView.contentOffset.y;
//    NSLog(@"scrollViewDidScroll - %f",self.contentViewNextPointY);
    
    bool contentViewCanBounceVertical = NO;
    CGFloat zeroContentOffsetY = 0;
    
    if (@available(iOS 11.0, *)) {
        zeroContentOffsetY = 0;
    } else {
        zeroContentOffsetY = -20;
    }
    
    contentViewCanBounceVertical = self.contentOffset.y <= zeroContentOffsetY;
    
    CGPoint zeroContentOffset = (CGPoint){
        0,zeroContentOffsetY
    };
    if (contentViewCanBounceVertical) {
        //            [self fd_handlePan:gesture];
    }
    
    bool contentViewScrollDirectionDown = NO;// 是否向下拉
    contentViewScrollDirectionDown = self.contentViewBeginPointY >= self.contentViewNextPointY;
    if (!contentViewScrollDirectionDown) {
        [self setContentOffset:zeroContentOffset animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.contentViewBeginPointY = scrollView.contentOffset.y;
}

@end
