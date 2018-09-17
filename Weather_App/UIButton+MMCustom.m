//
//  UIButton+MMCustom.m
//  Weather_App
//
//  Created by user1 on 2018/9/14.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "UIButton+MMCustom.h"
#import <objc/runtime.h>

@implementation MMCustomButtonMaker

- (CGRect) imageRect{
    return CGRectZero;
}
- (CGRect) titleRect{
    return CGRectZero;
}
- (CGRect) resultFrame{
    return CGRectZero;
}
@end

@interface UIButton(_MMMaker)
@property (nonatomic ,strong) MMCustomButtonMaker * maker;
@end

@implementation UIButton (_MMMaker)
- (MMCustomButtonMaker *)maker{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setMaker:(MMCustomButtonMaker *)maker{
    objc_setAssociatedObject(self, @selector(maker), maker, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation UIButton (MMCustom)

+ (void)load{
    [self mm_hook:@selector(titleRectForContentRect:)
           newSel:@selector(mm_titleRectForContentRect:)];
    [self mm_hook:@selector(imageRectForContentRect:)
           newSel:@selector(mm_imageRectForContentRect:)];
}

+ (void) mm_hook:(SEL)originalSel newSel:(SEL)newSel{
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void) mm_makeCustomImage:(void(^)(MMCustomButtonMaker *maker))block{
    if (!self.maker) {
        self.maker = [[MMCustomButtonMaker alloc] init];
    }
    if (block) {
        block(self.maker);
    }
}

- (void) mm_makeCustomTitle:(void(^)(MMCustomButtonMaker *maker))block{
    if (!self.maker) {
        self.maker = [[MMCustomButtonMaker alloc] init];
    }
    if (block) {
        block(self.maker);
    }
}

- (CGRect) mm_titleRectForContentRect:(CGRect)contentRect{
    if (self.maker) {
        return self.maker.titleRect;
    }
    return [self mm_titleRectForContentRect:contentRect];
}

- (CGRect) mm_imageRectForContentRect:(CGRect)contentRect{
    
    if (self.maker) {
        return self.maker.imageRect;
    }
    return [self mm_imageRectForContentRect:contentRect];
}

@end
