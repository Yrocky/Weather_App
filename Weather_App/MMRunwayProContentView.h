//
//  MMRunwayProContentView.h
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMRunwayProAnimationProtocol <NSObject>

@optional
- (void) startAnimation;
- (void) finishAnimation;

@end

@interface MMRunwayProContentView : UIView{

    NSMutableArray *_runwayViews;
    BOOL _isShowRunwayView;
}
@property (nonatomic ,readonly) BOOL isShowRunwayView;// 通过这个属性来获取高级跑道是否在显示

// 添加一个 消息
- (void) addMarquee:(UIView *)marquee;
@end
