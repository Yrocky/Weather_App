//
//  XXXBasePopupView.h
//  Weather_App
//
//  Created by skynet on 2019/11/12.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 背景mask视图的颜色
typedef NS_ENUM(NSInteger ,XXXPopupMaskColorType) {
    XXXPopupMaskColorClear,
    XXXPopupMaskColorWhite,
    XXXPopupMaskColorBlurWhite,// todo
    XXXPopupMaskColorBlack,
    XXXPopupMaskColorBlurBlack// todo
};

// 弹出试图的尺寸类型，在设置布局中使用
typedef NS_ENUM(NSInteger ,XXXPopupContentSizeType) {
    /// 固定高/宽度的contentView
    XXXPopupContentSizeFixed,
    /// 变高/宽的contentView，根据子视图撑起来contentView的高/宽度
    XXXPopupContentSizeFlex
};

// 弹出视图所处的位置
typedef NS_ENUM(NSUInteger, XXXPopupLayoutType) {
    /// 在顶部显示
    XXXPopupLayoutTypeTop = 0,
    /// 居中显示
    XXXPopupLayoutTypeCenter,
    /// 默认底部显示
    XXXPopupLayoutTypeBottom,
};

// 控制弹出视图将以哪种样式呈现
typedef NS_ENUM(NSInteger, XXXPopupTransitStyle) {
    /// 从上部滑出
    XXXPopupTransitStyleFromTop = 0,
    /// 从底部滑出
    XXXPopupTransitStyleFromBottom,
    /// 从左部滑出
    XXXPopupTransitStyleFromLeft,
    /// 从右部滑出
    XXXPopupTransitStyleFromRight,
    /// 从中心点扩大或收缩
    XXXPopupTransitStyleShrinkInOut,
    /// 渐变效果
    XXXPopupTransitStyleDefault,
};

@interface XXXBasePopupView : UIView{
    /// 后面的蒙层
    UIView *_touchMaskView;
    /// 内容呈现视图，所有业务相关的子视图都要添加到这个视图上
    UIView *_contentView;
}

/// 是否允许点击背景蒙层消失，默认YES
@property (nonatomic ,assign) BOOL dismissOnMaskTouched;
@property (nonatomic ,strong ,readonly) UIView * contentView;

/// 展示时候的动画时间，default 0.3
@property (nonatomic ,assign) CGFloat showAnimationDuration;
/// 消失时候的动画时间，default 0.3
@property (nonatomic ,assign) CGFloat dismissAnimationDuration;

@property (nonatomic ,copy) void(^bShowedCallback)(void);
@property (nonatomic ,copy) void(^bDismissedCallback)(void);

/// 清除contentView的圆角
- (void) clearContentViewCornerRadius;

/// 子类需要重写改方法来添加子控件，并选择合适的时机调用该方法
- (void) addSubContentView;

- (void) showIn:(UIView *)view;
- (void) dismiss;
- (void) dismiss:(BOOL)animation;

@end

@interface XXXBasePopupView (CustomeUI)

/// default is XXXPopupMaskColorClear
- (XXXPopupMaskColorType) touchMaskViewColorType;

/// 哪种动画呈现，会根据`layoutType`来选择合适的类型，
- (XXXPopupTransitStyle) transitStyle;

/// 哪种动画呈现，default is ...Bottom
- (XXXPopupLayoutType) layoutType;

#pragma mark - size

/// default is Fixed
- (XXXPopupContentSizeType) contentViewWidthType;
- (CGFloat) contentViewFixedWidth;

/// default is Fixed
- (XXXPopupContentSizeType) contentViewHeightType;
- (CGFloat) contentViewFixedHeight;

#pragma mark - 动画

/// 自定义contentView显示的样式，如果子类重写返回一个非nil的对象，-transitStyle方法就会无效
- (CAAnimation *) customShowAnimation;
- (CAAnimation *) customDismissAnimation;

@end

/// 动态修改尺寸
@interface XXXBasePopupView (DynamicChangeContentViewSize)

/// 将尺寸修改为原始值，水平、垂直、宽、高等
- (void) resetOrigFrame;

/// contentView在垂直方向上的偏移，+up，-down
- (void) contentViewVerticalOffset:(CGFloat)offset;

/// contentView在水平方向上的偏移，+left，-right
- (void) contentViewHorizontalOffset:(CGFloat)offset;

/// contentView的宽度发生变化
- (void) contentViewWidthOffset:(CGFloat)offset;

/// contentView的高度发生变化
- (void) contentViewHeightOffset:(CGFloat)offset;

@end

/// 针对于已经存在的视图控制器，然后将其进行包裹展示，不用设置子类视图
@interface XXXBasePopupView (WrapperViewController)

///  vc.view
@property (nonatomic ,strong ,readonly) UIView * viewControllerWrapperView;

/// 包裹一个vc，默认是bottomLayout
- (void)wrapViewController:(UIViewController *)vc fixedHeight:(CGFloat)fixedHeight;

/// 提供更加多样的接口，考虑到vc不太可能自适应宽高，这里使用 XXXPopupContentSizeFixed
- (void) wrapViewController:(UIViewController *)vc
                 layoutType:(XXXPopupLayoutType)layoutType
            contentViewSize:(CGSize)contentViewSize;
@end

NS_ASSUME_NONNULL_END
