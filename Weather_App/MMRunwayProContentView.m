//
//  MMRunwayProContentView.m
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMRunwayProContentView.h"

#pragma mark - 超级跑道的背景视图
@class _MMRunwayProBackgroundView;
@protocol MMRunwayProBackgroundViewDelegate <NSObject>

- (void) runwayProBackgroundViewDidFinishAnimation:(_MMRunwayProBackgroundView *)bgView;
- (void) runwayProBackgroundViewDidFinishAnimationAndRemoveFromSuperView;

@end

@interface _MMRunwayProBackgroundView : UIView<MMRunwayProAnimationProtocol>{

    UIImageView * _bgImageView;
    UIScrollView * _contentView;
    UIView * _runwayView;
}
@property (nonatomic ,weak) id<MMRunwayProBackgroundViewDelegate>delegate;

// 根据【要展示的视图】初始化火箭视图，这时候【要展示的视图】的size已经确定,并且【要展示的视图】作为子视图添加到内部
- (instancetype) initWithView:(UIView *)view;

@end

@implementation _MMRunwayProBackgroundView

- (void)dealloc{

    [_bgImageView removeFromSuperview];
    _bgImageView = nil;
    
    [_runwayView removeFromSuperview];
    _runwayView = nil;
    
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    //NSLog(@"_MMRunwayProBackgroundView dealloc");
}

- (instancetype) initWithView:(UIView *)view{

    self = [super init];
    if (self) {
        
        self.frame = (CGRect){
            [UIScreen mainScreen].bounds.size.width,CGPointZero.y,
            [UIScreen mainScreen].bounds.size.width,46
        };
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0;
        
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"mm_pro_runway_bg"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.frame = self.bounds;
        [self addSubview:_bgImageView];
        
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.alpha = 0;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.frame = (CGRect){
            self.frame.size.width * (196.0/750.0),//
            0,
            self.frame.size.width * ((682.0 - 196.0) / 750.0),// 这些是和UI商量好的图片比例位置
            self.frame.size.height
        };
        [self addSubview:_contentView];
        
        NSAssert(view != nil, @"请确保要添加的视图不为nil");
        _runwayView = view;
        _runwayView.frame = (CGRect){
            CGPointZero,
            view.frame.size
        };
        _contentView.contentSize =_runwayView.frame.size;
        [_contentView addSubview:_runwayView];
    }
    return self;
}


- (void)startAnimation{

    CGFloat runwayViewOffset = _runwayView.frame.size.width - _contentView.frame.size.width;
    
    CGFloat selfAnimationDuration = 1;
    CGFloat contentViewAnimationDuration = 1;
    CGFloat runwayViewAnimationDuration = abs((int)runwayViewOffset) * 0.01;// 0.01 = 0.1/10 移动10px花费0.1秒
    
    // 1.自己的位移动画+alpha动画
    CGRect originalFrame = self.frame;
    originalFrame = (CGRect){
        0,originalFrame.origin.y,
        originalFrame.size
    };
    self.alpha = 0.5;
    [UIView animateWithDuration:selfAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = originalFrame;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    // 2.开始contentView 的位移动画+alpha动画
    CGRect originalContentFrame = _contentView.frame;
    _contentView.frame = (CGRect){
        originalContentFrame.origin.x + 40,originalContentFrame.origin.y,
        originalContentFrame.size
    };
    [UIView animateWithDuration:contentViewAnimationDuration delay:selfAnimationDuration options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        _contentView.frame = originalContentFrame;
        _contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (runwayViewOffset <=0 && finished) {
            [self finishAnimation];
        }
    }];
    
    if (runwayViewOffset > 0) {
        
        CGRect runwayViewFrame = _runwayView.frame;
        // 3.跑道视图的位移动画，需要位移的
        [UIView animateWithDuration:runwayViewAnimationDuration delay:contentViewAnimationDuration + selfAnimationDuration options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            _runwayView.frame = (CGRect){
                -runwayViewOffset,runwayViewFrame.origin.y,
                runwayViewFrame.size
            };
        } completion:^(BOOL finished) {
            if (finished) {
                [self finishAnimation];
            }
        }];
    }
}

- (void)finishAnimation{

    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = (CGRect){
            -self.frame.size.width,self.frame.origin.y,
            self.frame.size
        };
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(runwayProBackgroundViewDidFinishAnimation:)]) {
            [self.delegate runwayProBackgroundViewDidFinishAnimation:self];
        }
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(runwayProBackgroundViewDidFinishAnimationAndRemoveFromSuperView)]) {
            [self.delegate runwayProBackgroundViewDidFinishAnimationAndRemoveFromSuperView];
        }
    }];
}

@end

#pragma mark - 超级跑道

@interface MMRunwayProContentView ()<MMRunwayProBackgroundViewDelegate>

@end
@implementation MMRunwayProContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _runwayViews = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _runwayViews = [NSMutableArray array];
    }
    return self;
}

- (void)addMarquee:(UIView *)marquee{

    _MMRunwayProBackgroundView * bgView = [[_MMRunwayProBackgroundView alloc] initWithView:marquee];
    bgView.delegate = self;
    [self addSubview:bgView];
    [_runwayViews addObject:bgView];
    if (_runwayViews.count == 1) {
        [bgView startAnimation];
    }
    _isShowRunwayView = YES;
}

#pragma mark - MMRunwayProBackgroundViewDelegate

- (void)runwayProBackgroundViewDidFinishAnimation:(_MMRunwayProBackgroundView *)bgView{
    
    if (_runwayViews.count && [_runwayViews containsObject:bgView]) {
        
        [_runwayViews removeObject:bgView];
        if (_runwayViews.count >= 1) {
            _MMRunwayProBackgroundView * nextBgView = _runwayViews[0];
            [nextBgView startAnimation];
        }
    }
    else{
        NSLog(@"代码逻辑错误");
    }
}

- (void)runwayProBackgroundViewDidFinishAnimationAndRemoveFromSuperView{

    _isShowRunwayView = _runwayViews.count;
}
@end
