//
//  MT_AnyComponent.m
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_AnyComponent.h"

@interface UIView (MT_Component)
- (void) addSubviewWithEdgeConstraints:(UIView *)view;
@end

@interface MT_InnerAnyComponentBox : NSObject<MT_Component>{
    id<MT_Component> _base;
}
@property (nonatomic ,copy) NSString * reuseIdentifier;

+ (instancetype) boxWith:(id<MT_Component>)base;
- (instancetype) initWith:(id<MT_Component>)base;
@end

@interface MT_AnyComponent ()

@property (nonatomic ,strong) MT_InnerAnyComponentBox * box;
@end

@implementation MT_AnyComponent

- (void)dealloc{
    NSLog(@"MT_AnyComponent dealloc");
}

- (instancetype)initWithComponent:(id<MT_Component>)component{
    self = [super init];
    if (self) {
        self.box = [MT_InnerAnyComponentBox boxWith:component];
    }
    return self;
}

+ (MT_AnyComponent * _Nonnull (^)(id<MT_Component> _Nonnull))make{
    return ^MT_AnyComponent*(id<MT_Component> component){
        if ([component isKindOfClass:[MT_AnyComponent class]]) {
            return component;
        }
        return [[MT_AnyComponent alloc]
                initWithComponent:component];
    };
}

- (NSString *)reuseIdentifier{
    return self.box.reuseIdentifier;
}

- (id<MT_Content>) renderContent{
    return [self.box renderContent];
}

- (void) renderInContent:(id<MT_Content>)content{
    [self.box renderInContent:content];
}

- (CGSize) referenceSizeInBounds:(CGRect)bounds{
    return [self.box referenceSizeInBounds:bounds];
}

- (BOOL) shouldContentUpdateWithNext:(id<MT_Component>)next{
    return [self.box shouldContentUpdateWithNext:next];
}

- (BOOL) shouldRenderNext:(id<MT_Component>)next inContent:(id<MT_Content>)content{
    if ([next isKindOfClass:MT_AnyComponent.class]) {
        return [self.box shouldRenderNext:((MT_AnyComponent *)next).box inContent:content];
    }
    return [self.box shouldRenderNext:next inContent:content];
}

- (void) layoutContent:(id<MT_Content>)content inContainer:(UIView *)container{
    [self.box layoutContent:content inContainer:container];
}

- (CGSize) intrinsicContentSizeForContent:(id<MT_Content>)content{
    return [self.box intrinsicContentSizeForContent:content];
}

- (void) contentWillDisplay:(id<MT_Content>)content{
    [self.box contentWillDisplay:content];
}

- (void) contentDidEndDisplay:(id<MT_Content>)content{
    [self.box contentDidEndDisplay:content];
}
- (void) contentDidSelected:(id<MT_Content>)content{
    [self.box contentDidSelected:content];
}
@end

@implementation MT_InnerAnyComponentBox

- (void)dealloc{
    NSLog(@"MT_InnerAnyComponentBox dealloc");
}

+ (instancetype) boxWith:(id<MT_Component>)base{
    return [[self alloc] initWith:base];
}

- (instancetype) initWith:(id<MT_Component>)base{
    self = [super init];
    if (self) {
        _base = base;
    }
    return self;
}

-(NSString *)reuseIdentifier{
    return NSStringFromClass(_base.class);
}

- (id<MT_Content>)renderContent {
    if ([_base respondsToSelector:_cmd]) {
        return [_base renderContent];
    }
    return nil;
}

- (void)renderInContent:(id<MT_Content>)content {
    if ([_base respondsToSelector:_cmd]) {
        [_base renderInContent:content];
    }
}

- (CGSize)intrinsicContentSizeForContent:(id<MT_Content>)content {
    if ([_base respondsToSelector:_cmd]) {
        return [_base intrinsicContentSizeForContent:content];
    } else if ([content isKindOfClass:[UIViewController class]]) {
        return ((UIViewController *)content).view.intrinsicContentSize;
    } else if ([content isKindOfClass:[UIView class]]) {
        return ((UIView *)content).intrinsicContentSize;
    }
    return CGSizeZero;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds {
    if ([_base respondsToSelector:_cmd]) {
        return [_base referenceSizeInBounds:bounds];
    }
    return CGSizeZero;
}

- (void)layoutContent:(id<MT_Content>)content inContainer:(UIView *)container {
    if ([content isKindOfClass:UIViewController.class]) {
        [container addSubviewWithEdgeConstraints:((UIViewController *)content).view];
    } else if ([content isKindOfClass:UIView.class]) {
        [container addSubviewWithEdgeConstraints:(UIView *)content];
    }
    if ([_base respondsToSelector:_cmd]) {
        [_base layoutContent:content inContainer:container];
    }
}

- (BOOL)shouldContentUpdateWithNext:(nonnull id<MT_Component>)next {
    if ([_base respondsToSelector:_cmd]) {
        return [_base shouldContentUpdateWithNext:next];
    }
    return NO;
}

- (BOOL)shouldRenderNext:(MT_InnerAnyComponentBox *)next inContent:(id<MT_Content>)content {
    if ([_base respondsToSelector:_cmd]) {
        return [_base shouldRenderNext:next->_base inContent:content];
    }
    return YES;
}

- (void)contentDidEndDisplay:(id<MT_Content>)content {
    if ([_base respondsToSelector:_cmd]) {
        [_base contentDidEndDisplay:content];
    }
}

- (void)contentWillDisplay:(id<MT_Content>)content {
    if ([_base respondsToSelector:_cmd]) {
        [_base contentWillDisplay:content];
    }
}

- (void)contentDidSelected:(id<MT_Content>)content{
    if ([_base respondsToSelector:_cmd]) {
        [_base contentDidSelected:content];
    }
}
@end

@implementation UIView (MT_Component)

- (void) addSubviewWithEdgeConstraints:(UIView *)view{
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];

    NSLayoutConstraint * bottomCons =
    [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor];
    NSLayoutConstraint * trailingCons =
    [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
    
    bottomCons.priority = 999;
    trailingCons.priority = 999;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.topAnchor constraintEqualToAnchor:view.topAnchor],
        [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        bottomCons,
        trailingCons
    ]];
}

@end

@implementation UIView (MT_Content)
@end

@implementation UIViewController (MT_Content)
@end
