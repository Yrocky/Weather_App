//
//  XXXBasePopupView.h
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 背景mask视图的颜色
typedef NS_ENUM(NSInteger ,XXXPopupMaskColorType) {
    XXXPopupMaskColorClear,
    XXXPopupMaskColorWhite,
    XXXPopupMaskColorBlurWhite,// todo
    XXXPopupMaskColorBlack,
    XXXPopupMaskColorBlurBlack// todo
};

// 弹出试图的尺寸类型，在设置布局中使用
typedef NS_ENUM(NSInteger ,XXXPopupContentSizeType) {
    XXXPopupContentSizeFixed,///<固定高/宽度的contentView
    XXXPopupContentSizeFlex///<变高/宽的contentView，根据子视图撑起来contentView的高/宽度
};

// 弹出视图所处的位置
typedef NS_ENUM(NSUInteger, XXXPopupLayoutType) {
    XXXPopupLayoutTypeTop = 0, ///<在顶部显示
    XXXPopupLayoutTypeBottom,///<默认底部显示
    XXXPopupLayoutTypeCenter ///<居中显示
};

// 控制弹出视图将以哪种样式呈现
typedef NS_ENUM(NSInteger, XXXPopupTransitStyle) {
    XXXPopupTransitStyleFromTop = 0, ///<从上部滑出
    XXXPopupTransitStyleFromBottom, ///<从底部滑出
    XXXPopupTransitStyleFromLeft,  ///<从左部滑出
    XXXPopupTransitStyleFromRight, ///<从右部滑出
    XXXPopupTransitStyleShrinkInOut, ///<从中心点扩大或收缩
    XXXPopupTransitStyleDefault, ///<渐变效果
};

@interface XXXBasePopupView : UIView{
    UIView *_touchMaskView;
    UIView *_contentView;
}

@property (nonatomic ,assign) BOOL dismissOnMaskTouched;///<是否允许点击背景蒙层消失，默认YES
@property (nonatomic ,strong ,readonly) UIView * contentView;

@property (nonatomic ,copy) void(^bShowedCallback)(void);
@property (nonatomic ,copy) void(^bDismissedCallback)(void);

///<清除contentView的圆角
- (void) clearContentViewCornerRadius;

- (void) addSubContentView;///<子类需要重写改方法来添加子控件，并选择合适的时机调用该方法

- (void) showIn:(UIView *)view;
- (void) dismiss;
- (void) dismiss:(BOOL)animation;

@end

@interface XXXBasePopupView (CustomeUI)

- (XXXPopupTransitStyle) transitStyle;///<哪种动画呈现，会根据`layoutType`来选择合适的类型，
- (XXXPopupLayoutType) layoutType;///<哪种动画呈现，default is ...Bottom

- (XXXPopupMaskColorType) touchMaskViewColorType;///<default is XXXPopupMaskColorClear

- (XXXPopupContentSizeType) contentViewWidthType;///<default is Fixed
- (CGFloat) contentViewFixedWidth;

- (XXXPopupContentSizeType) contentViewHeightType;///<default is Fixed
- (CGFloat) contentViewFixedHeight;
@end

///<针对于已经存在的视图控制器，然后将其进行包裹展示，不用设置子类视图
@interface XXXBasePopupView (WrapperViewController)

@property (nonatomic ,strong ,readonly) UIView * viewControllerWrapperView;///< vc.view

- (void)wrapViewController:(UIViewController *)vc fixedHeight:(CGFloat)fixedHeight;
@end

NS_ASSUME_NONNULL_END
