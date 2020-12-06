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

@protocol MT_Content <NSObject>
@end

@protocol MT_Component <NSObject>

- (id<MT_Content>) renderContent;
- (void) renderInContent:(id<MT_Content>)content;

@optional

@property (nonatomic ,copy) NSString * reuseIdentifier;

- (BOOL) shouldContentUpdateWithNext:(id<MT_Component>)next;
- (BOOL) shouldRenderNext:(id<MT_Component>)next inContent:(id<MT_Content>)content;

- (CGSize) referenceSizeInBounds:(CGRect)bounds;
- (CGSize) intrinsicContentSizeForContent:(id<MT_Content>)content;
- (void) layoutContent:(id<MT_Content>)content inContainer:(UIView *)container;

- (void) contentWillDisplay:(id<MT_Content>)content;
- (void) contentDidEndDisplay:(id<MT_Content>)content;

- (void) contentDidSelected:(id<MT_Content>)content;
@end

NS_ASSUME_NONNULL_END
