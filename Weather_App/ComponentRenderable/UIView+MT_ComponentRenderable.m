//
//  UIView+MT_ComponentRenderable.m
//  Weather_App
//
//  Created by rocky on 2020/12/6.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "UIView+MT_ComponentRenderable.h"
#import <objc/runtime.h>

@implementation UIView (MT_ComponentRenderable)

- (UIView *)componentContainerView{
    if ([self isKindOfClass:[UICollectionViewCell class]]) {
        return ((UICollectionViewCell *)self).contentView;
    } else if ([self isKindOfClass:[UITableViewCell class]]) {
        return ((UITableViewCell *)self).contentView;
    } else if ([self isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return ((UITableViewHeaderFooterView *)self).contentView;
    }
    return self;
}

- (id<MT_Content>)renderedContent{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRenderedContent:(id<MT_Content>)renderedContent{
    objc_setAssociatedObject(self, @selector(renderedContent), renderedContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MT_AnyComponent *)renderedComponent{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRenderedComponent:(MT_AnyComponent *)renderedComponent{
    objc_setAssociatedObject(self, @selector(renderedComponent), renderedComponent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) renderWithComponent:(MT_AnyComponent *)component{
    if (self.renderedComponent &&
        [self.renderedComponent shouldRenderNext:component inContent:self.renderedContent]) {
        return;
    }
    
    // 从component（VM）中获取content（UI），第一次肯定没有，会进入else分支
    if (self.renderedContent) {
        [component renderInContent:self.renderedContent];
        self.renderedComponent = component;
    } else {
        // 从Component中获取UI，然后对UI进行布局，之后再递归，
        id<MT_Content> content = [component renderContent];
        [component layoutContent:content inContainer:self.componentContainerView];
        self.renderedContent = content;
        [self renderWithComponent:component];
    }
}

- (void) contentWillDisplay{
    if (self.renderedContent) {
        [self.renderedComponent contentWillDisplay:self.renderedContent];
    }
}

- (void) contentDidEndDisplay{
    if (self.renderedContent) {
        [self.renderedComponent contentDidEndDisplay:self.renderedContent];
    }
}

- (void) contentDidSelected{
    if (self.renderedContent) {
        [self.renderedComponent contentDidSelected:self.renderedContent];
    }
}
@end
