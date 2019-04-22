//
//  UIView+AutoLayoutSupport.m
//  Weather_App
//
//  Created by user1 on 2017/8/31.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "UIView+AutoLayoutSupport.h"
#import <objc/runtime.h>

@interface _ADKAutoLayoutValueWrap : NSObject

@property (assign, nonatomic) CGFloat initializedMargin;
@property (assign, nonatomic) CGFloat widthConstraintConstant;
@property (assign, nonatomic) CGFloat heightConstraintConstant;
@property (assign, nonatomic) CGFloat topConstraintConstant;
@property (assign, nonatomic) CGFloat bottomConstraintConstant;
@property (assign, nonatomic) CGFloat leadingConstraintConstant;
@property (assign, nonatomic) CGFloat trailingConstraintConstant;
@property (assign, nonatomic) CGFloat leftConstraintConstant;
@property (assign, nonatomic) CGFloat rightConstraintConstant;
@end
@implementation _ADKAutoLayoutValueWrap
@end

@interface ADKAutoLayoutValueObject : NSObject

@property (assign, nonatomic) CGFloat initializedMargin;
@property (assign, nonatomic) CGFloat cachedWidthConstraintConstant;
@property (assign, nonatomic) CGFloat cachedHeightConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTopConstraintConstant;
@property (assign, nonatomic) CGFloat cachedBottomConstraintConstant;
@property (assign, nonatomic) CGFloat cachedLeadingConstraintConstant;
@property (assign, nonatomic) CGFloat cachedTrailingConstraintConstant;
@property (assign, nonatomic) CGFloat cachedLeftConstraintConstant;
@property (assign, nonatomic) CGFloat cachedRightConstraintConstant;

@end
@implementation ADKAutoLayoutValueObject
@end

@implementation UIView (AutoLayoutSupport)

NSString * const hideKey;
NSString * const valueWrapConstantKey;

#pragma mark - Getter and Setter

- (void)setCachedValueWrap:(_ADKAutoLayoutValueWrap *)cachedValueWrap{
    objc_setAssociatedObject(self, &valueWrapConstantKey, cachedValueWrap, OBJC_ASSOCIATION_RETAIN);
}

- (_ADKAutoLayoutValueWrap *)cachedValueWrap{
    
    _ADKAutoLayoutValueWrap *wrap = objc_getAssociatedObject(self, &valueWrapConstantKey);
    if (!wrap) {
        wrap = [[_ADKAutoLayoutValueWrap alloc] init];
        self.cachedValueWrap = wrap;
    }
    return wrap;
}

- (void)setADKHidden:(BOOL)ADKHidden{
    objc_setAssociatedObject(self, &hideKey, @(ADKHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)ADKHidden{
    return objc_getAssociatedObject(self, &hideKey);;
}

#pragma mark - Support methods

///<使用自定义枚举接口进行视图的隐藏与显示修改约束，这个接口的包容性更强，由于是自定义的枚举，因此这里支持使用` | & `操作
- (void)ADKHideView:(BOOL)isHidden withConstraints:(ADKLayoutAttribute)attributes
{
    _ADKAutoLayoutValueWrap *valueWrap = self.cachedValueWrap;
    if (isHidden) {
        
        if (attributes & ADKLayoutAttributeLeading) {
            ///<通过对应的位置找到约束
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeading];
            if (constraint.constant != 0.0f) {
                valueWrap.leadingConstraintConstant = constraint.constant;///<缓存下来原始的leading约束数据
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTrailing];
            if (constraint.constant != 0.0f) {
                valueWrap.trailingConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeLeft) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeft];
            if (constraint.constant != 0.0f) {
                valueWrap.leftConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeRight) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeRight];
            if (constraint.constant != 0.0f) {
                valueWrap.rightConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTop];
            if (constraint.constant != 0.0f) {
                valueWrap.topConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeBottom];
            if (constraint.constant != 0.0f) {
                valueWrap.bottomConstraintConstant = constraint.constant;
                constraint.constant = 0.0f;
            }
        }
        if (attributes & ADKLayoutAttributeWidth) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeWidth];
            if (constraint.constant != 0.0f) {
                valueWrap.widthConstraintConstant = viewSize.width;
                constraint.constant = 0.0f;
//                self.hidden = isHidden;
                self.alpha = !isHidden;
            }
        }
        if (attributes & ADKLayoutAttributeHeight) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            CGSize viewSize = self.bounds.size;
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeHeight];
            if (constraint.constant != 0.0f) {
                valueWrap.heightConstraintConstant = viewSize.height;
                constraint.constant = 0.0f;
//                self.hidden = isHidden;
                self.alpha = !isHidden;
            }
        }
    }
    else {
        if (attributes & ADKLayoutAttributeLeading) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeading];
            constraint.constant = valueWrap.leadingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTrailing) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTrailing];
            constraint.constant = valueWrap.trailingConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeLeft) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeLeft];
            constraint.constant = valueWrap.leftConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeRight) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeRight];
            constraint.constant = valueWrap.rightConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeTop) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeTop];
            constraint.constant = valueWrap.topConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeBottom) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeBottom];
            constraint.constant = valueWrap.bottomConstraintConstant;
        }
        if (attributes & ADKLayoutAttributeWidth) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeWidth];
            constraint.constant = valueWrap.widthConstraintConstant;
//            self.hidden = isHidden;
            self.alpha = !isHidden;
        }
        if (attributes & ADKLayoutAttributeHeight) {
            NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:NSLayoutAttributeHeight];
            constraint.constant = valueWrap.heightConstraintConstant;
//            self.hidden = isHidden;
            self.alpha = !isHidden;/// for animation
        }
    }
}

- (void)ADKHideViewWidth
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeWidth];
}

- (void)ADKUnhideViewWidth
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeWidth];
}

- (void)ADKHideViewHeight
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeHeight];
}

- (void)ADKUnhideViewHeight
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeHeight];
}

- (void)ADKHideTopConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeTop];
}

- (void)ADKUnhideTopConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeTop];
}

- (void)ADKHideBottomConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeBottom];
}

- (void)ADKUnhideBottomConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeBottom];
}

- (void)ADKHideLeadingConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeLeading];
}

- (void)ADKUnhideLeadingConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeLeading];
}

- (void)ADKHideTrailingConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeTrailing];
}

- (void)ADKUnhideTrailingConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeTrailing];
}

- (void)ADKHideLeftConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeLeft];
}

- (void)ADKUnhideLeftConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeLeft];
}

- (void)ADKHideRightConstraint
{
    [self ADKHideView:YES byAttribute:NSLayoutAttributeRight];
}

- (void)ADKUnhideRightConstraint
{
    [self ADKHideView:NO byAttribute:NSLayoutAttributeRight];
}
- (void) ADKHide{
    
    if (self.ADKHidden) {
        return;
    }
    [self ADKHideView:YES withConstraints:
     ADKLayoutAttributeTop|
     ADKLayoutAttributeBottom|
     ADKLayoutAttributeLeft|
     ADKLayoutAttributeRight|
     ADKLayoutAttributeWidth|
     ADKLayoutAttributeHeight];
    
    self.ADKHidden = YES;
}
- (void) ADKShow{
    
    if (!self.ADKHidden) {
        return;
    }
    [self ADKHideView:NO withConstraints:
     ADKLayoutAttributeTop|
     ADKLayoutAttributeBottom|
     ADKLayoutAttributeLeft|
     ADKLayoutAttributeRight|
     ADKLayoutAttributeWidth|
     ADKLayoutAttributeHeight];
    
    self.ADKHidden = NO;
}
///<使用系统枚举接口进行视图的隐藏于显示修改约束，不可以进行 | & 操作
- (void)ADKHideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:attribute];
    
    if (hidden) {
        if (constraint && constraint.constant > 0.0f) {
            // Cache constraint's value
            if (attribute == NSLayoutAttributeWidth) {
                self.cachedValueWrap.widthConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeHeight) {
                self.cachedValueWrap.heightConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeTop) {
                self.cachedValueWrap.topConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeBottom) {
                self.cachedValueWrap.bottomConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeLeading) {
                self.cachedValueWrap.leadingConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeTrailing) {
                self.cachedValueWrap.trailingConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeLeft) {
                self.cachedValueWrap.leftConstraintConstant = constraint.constant;
            } else if (attribute == NSLayoutAttributeRight) {
                self.cachedValueWrap.rightConstraintConstant = constraint.constant;
            }
        } else {
            // Calculate by yourself (No one set constraint for this view)
            [self setNeedsLayout];
            [self layoutIfNeeded];
            ///<有可能试图的宽高是相互绑定的，没有具体的数值，通过layoutIfNeeded可以获取到真是的宽高，然后将这个数值进行保存
            CGSize viewSize = self.bounds.size;
            if (attribute == NSLayoutAttributeWidth && viewSize.width > 0.0f) {
                self.cachedValueWrap.widthConstraintConstant = viewSize.width;
            } else if (attribute == NSLayoutAttributeHeight && viewSize.height > 0.0f) {
                self.cachedValueWrap.heightConstraintConstant = viewSize.height;
            }
            // Top, Bottom, Leading, Trailing can not be calculated.
        }
        
        // Set up new constraint for hidden
        [self ADKSetConstraintConstant:0.0f forAttribute:attribute];
    } else {
        // Restore constraint for unhidden
        if (attribute == NSLayoutAttributeWidth &&
            self.cachedValueWrap.widthConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.widthConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeHeight &&
                   self.cachedValueWrap.heightConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.heightConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTop) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.topConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeBottom) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.bottomConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeLeading &&
                   self.cachedValueWrap.leadingConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.leadingConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeTrailing &&
                   self.cachedValueWrap.trailingConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.trailingConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeLeft &&
                   self.cachedValueWrap.leftConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.leftConstraintConstant
                              forAttribute:attribute];
        } else if (attribute == NSLayoutAttributeRight &&
                   self.cachedValueWrap.rightConstraintConstant != 0.0f) {
            [self ADKSetConstraintConstant:self.cachedValueWrap.rightConstraintConstant
                              forAttribute:attribute];
        }
    }
    
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        self.alpha = !hidden;
//        self.hidden = hidden;
    }
}

- (void)ADKSetConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self ADKConstraintForAttribute:attribute];
    
    if (constraint) {
        constraint.constant = constant;
    } else {
        ///< 如果试图的宽高是相互绑定的
        ///< <MASLayoutConstraint:0x6000010f03c0 ALDebugView:oneView.height == ALDebugView:oneView.width>
        ///< 这时候如果修改宽度或者高度为0，是拿不到对应的约束的，因此会添加一个约束，但是这个约束是添加到俯视图上的，这就会导致等下重置宽度或者高度的时候还是拿不到约束，就会得到一个约束冲突的警告
        ///< 因此这里将 self.superView 修改为 self ，如果有其他地方的bug再看是什么情况引起的
        UIView * view = self.superview;
        if (attribute == NSLayoutAttributeWidth ||
            attribute == NSLayoutAttributeHeight) {
            view = self;
        }
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:attribute
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:constant]];
    }
}

- (NSLayoutConstraint *)ADKConstraintForAttribute:(NSLayoutAttribute)attribute
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d && class == %@", self, attribute, [NSLayoutConstraint class]];
    NSArray *predicatedArray;
    ///<从log中可以看出来，视图的width、height约束只是加在了自己上面
    ///<而left、right、top、bottom、leading、trailing这些约束才是加在了'父视图'（和当前视图有关的最近的共有视图）上
    ///<TODO:由于这个分类的作用是隐藏一个视图，让其他的视图占用他以前的位置，这个其他的视图处理范围限制在共同父类
    ///<因此，这里分两种情况来获取约束
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }
    
    if (predicatedArray.count > 0) {
        return predicatedArray.firstObject;
    } else {
        ///<如果以firstItem没有找到对应的约束，那就通过secontItem寻找对应的约束
        NSLayoutConstraint *reverseConstraint = [self handleReversedCaseForAttribute:attribute];
        if (reverseConstraint) {
            return reverseConstraint;
        }
        ///<没有发现约束，尝试使用`NSContentSizeLayoutConstraint`来返回约束，这是一个私有类
        // No constraint found, try to use NSContentSizeLayoutConstraint instead.
        return [self contentSizeADKConstraintForAttribute:attribute];
    }
}

- (NSLayoutConstraint *)handleReversedCaseForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"secondItem = %@ && secondAttribute = %d && class == %@", self, attribute, [NSLayoutConstraint class]];
    NSArray *predicatedArray;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }
    
    return predicatedArray.firstObject;
}

- (NSLayoutConstraint *)contentSizeADKConstraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d", self, attribute];
    NSArray *predicatedArray;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        predicatedArray = [self.constraints filteredArrayUsingPredicate:predicate];
    } else {
        predicatedArray = [self.superview.constraints filteredArrayUsingPredicate:predicate];
    }
    
    if (predicatedArray.count > 0) {
        return predicatedArray.firstObject;
    } else {
        return nil;
    }
}

@end
