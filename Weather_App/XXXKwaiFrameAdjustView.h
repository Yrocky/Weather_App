//
//  XXXKwaiFrameAdjustView.h
//  Weather_App
//
//  Created by skynet on 2019/12/30.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XXXKwaiFrameAdjustViewDelegate;

@interface XXXKwaiFrameAdjustView : UIView

@property (nonatomic ,weak) id<XXXKwaiFrameAdjustViewDelegate> delegate;

- (void)addGestures;

- (void)removeGestures;
@end

@protocol XXXKwaiFrameAdjustViewDelegate <NSObject>

- (void) frameAdjustView:(XXXKwaiFrameAdjustView *)view didChangeFrame:(CGPoint)orig;

@end
NS_ASSUME_NONNULL_END
