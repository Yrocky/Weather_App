//
//  MT_ComponentRenderable.h
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MT_AnyComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MT_ComponentRenderable <NSObject>

/*:
 @optional是为了消除警告，
 其实在`UIView+MT_ComponentRenderable`中已经全部实现了这些方法
 */
@optional

- (UIView *) componentContainerView;

@property (nonatomic ,strong) id<MT_Content> renderedContent;
@property (nonatomic ,strong) MT_AnyComponent * renderedComponent;

- (void) renderWithComponent:(MT_AnyComponent *)component;

- (void) contentWillDisplay;
- (void) contentDidEndDisplay;

- (void) contentDidSelected;
@end

NS_ASSUME_NONNULL_END
