//
//  MT_Component.h
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 应该限制为UIView的子类，oc中不支持
@protocol MT_Content <NSObject>
@end

typedef id<MT_Content> MTContent;

@protocol MT_Component <NSObject>

- (MTContent) renderContent;
- (void) renderInContent:(MTContent)content;

@optional

@property (nonatomic ,copy) NSString * reuseIdentifier;

- (BOOL) shouldContentUpdateWithNext:(id<MT_Component>)next;
- (BOOL) shouldRenderNext:(id<MT_Component>)next inContent:(MTContent)content;

- (CGSize) referenceSizeInBounds:(CGRect)bounds;
- (CGSize) intrinsicContentSizeForContent:(MTContent)content;
- (void) layoutContent:(MTContent)content inContainer:(UIView *)container;

- (void) contentWillDisplay:(MTContent)content;
- (void) contentDidEndDisplay:(MTContent)content;

- (void) contentDidSelected:(MTContent)content;
@end

NS_ASSUME_NONNULL_END
