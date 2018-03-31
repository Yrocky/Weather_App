//
//  HomeBillContainerView.h
//  Weather_App
//
//  Created by user1 on 2018/3/30.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeBillContainerViewDelegate <NSObject>


@end

@interface HomeBillContainerView : UIView

@property (nonatomic ,weak) id<HomeBillContainerViewDelegate>delegate;

- (void) configBillContentView:(__kindof UIView *)contentView;

@end
