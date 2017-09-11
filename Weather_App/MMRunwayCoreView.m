//
//  MMRunwayCoreView.m
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMRunwayCoreView.h"
#import <CoreText/CoreText.h>

@interface _MMRunwayViewOperation : NSObject{

    __block CGFloat _runwayViewMoveRatio;
    UIView * _runwayView;
    BOOL _finished;
    BOOL _executing;
    CADisplayLink * _link;
}

@property (nonatomic ,strong ,readonly) UIView * runwayView;
@property (nonatomic ,assign) CGFloat speed;//
@property (nonatomic ,assign ,readonly) CGFloat runwayViewMoveRatio;
@property (nonatomic ,assign) BOOL fullyDisplayed;// runwayView是否全部展示出来
@property (nonatomic ,assign) CGRect originalFrame;

@property (nonatomic ,copy) void(^finishedHandle)(BOOL,_MMRunwayViewOperation *);
@property (nonatomic ,copy) void(^progressHandle)(CGFloat ,BOOL ,_MMRunwayViewOperation *);

- (instancetype) initWithRunwayView:(UIView *)runwayView;

- (void) start;

@end

@implementation _MMRunwayViewOperation

- (void)dealloc
{
    NSLog(@"_MMRunwayViewOperation dealloc");
}
- (instancetype) initWithRunwayView:(UIView *)runwayView{

    self = [super init];
    if (self) {
        
        _runwayView = runwayView;
        
    }
    return self;
}

- (void)start {
    
    if (_finished || _executing) {
        return;
    }
    _executing = YES;
    [self performSelector:@selector(operationDidStart) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

- (void)operationDidStart{

    self.originalFrame = _runwayView.frame;
    
    [self startWatch];
}

- (void)startWatch{
    [self stopWatch];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(track)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)track{
    CGRect frame = _runwayView.frame;
    frame.origin.x -= self.speed;
    _runwayView.frame = frame;
    
    CALayer *presentationLayer = _runwayView.layer.presentationLayer;
    [self handleMaskViewWithMyViewFrame:presentationLayer.frame];
}

- (void)stopWatch{
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_link invalidate];
    _link = nil;
}

- (void)handleMaskViewWithMyViewFrame:(CGRect)frame{
    
    [_runwayView setNeedsDisplay];
    CGFloat x = frame.origin.x;
    CGFloat originalX = self.originalFrame.origin.x;
    CGFloat runwayViewSuperViewWidth = _runwayView.superview.frame.size.width;
    originalX = originalX >= runwayViewSuperViewWidth ? runwayViewSuperViewWidth : originalX;
    
    _runwayViewMoveRatio = (originalX - x) / (originalX + _runwayView.frame.size.width);
    self.fullyDisplayed = (originalX - x) >= self.originalFrame.size.width;
    if (self.progressHandle) {
        self.progressHandle(_runwayViewMoveRatio, self.fullyDisplayed ,self);
    }
    
    if (_runwayViewMoveRatio >= 1) {
        _finished = YES;
        _executing = NO;
        [self stopWatch];
        
        if (self.finishedHandle) {
            self.finishedHandle(YES, self);
        }
    }
}

@end

@interface _MMRunwayViewQueue : NSObject{
    
    __block NSMutableArray <_MMRunwayViewOperation *>* _operations;
}

@property (nonatomic ,assign ,readonly) NSUInteger operationCount;

- (void) addOperation:(_MMRunwayViewOperation *)operation;

- (_MMRunwayViewOperation *)lastOperation;
- (_MMRunwayViewOperation *)currentOperation;

@end

@implementation _MMRunwayViewQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operations = [NSMutableArray array];
    }
    return self;
}

- (void)addOperation:(_MMRunwayViewOperation *)operation{
    
    [_operations addObject:operation];
    [self startOperation:operation];
}

- (void)startOperation:(_MMRunwayViewOperation *)operation{
    
    operation.finishedHandle = ^(BOOL finished, _MMRunwayViewOperation * _operation) {
        [_operation.runwayView removeFromSuperview];
        [_operations removeObject:_operation];
    };
    operation.progressHandle = ^(CGFloat progress, BOOL fullDisplay ,_MMRunwayViewOperation * _operation) {
        if (fullDisplay) {
            NSInteger index = [_operations indexOfObject:_operation];
            if (_operations.count > 0 && index < _operations.count - 1) {
                
                _MMRunwayViewOperation * nextOperation = _operations[index + 1];
                [nextOperation start];
            }
        }
    };
    
    if (self.operationCount == 1) {
        [operation start];
    }
    else if(self.operationCount > 1) {
        NSInteger index = [_operations indexOfObject:operation];
        _MMRunwayViewOperation * perOperation = _operations[index - 1];
        if (perOperation.fullyDisplayed) {
            [operation start];
        }
    }
}

- (NSUInteger)operationCount{
    return _operations.count;
}

- (_MMRunwayViewOperation *)lastOperation{
    if (self.operationCount > 0) {
        [_operations lastObject];
    }
    return nil;
}

- (_MMRunwayViewOperation *)currentOperation{
    
    if (self.operationCount > 0) {
        return [_operations firstObject];
    }
    return nil;
}
@end

#pragma mark - UILabel+TXLabel

@implementation MMRunwayLabel

+ (instancetype)label {
    MMRunwayLabel *label = [[MMRunwayLabel alloc]init];
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (CGSize) configAttributedString:(NSAttributedString *)attString{

    NSAssert(attString, @"请设置有效的 NSAttributedString ");
    
    [self setAttributedText:attString];
    CGSize size = [attString size];
    return size;
}
- (CGSize) configText:(NSString *)text{

    [self setText:text];
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.font.pointSize)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.font} context:nil].size;
    return size;
}
@end

#pragma mark - MMRunwayCoreView

@interface MMRunwayCoreView ()

@property (nonatomic ,strong) _MMRunwayViewQueue * queue;

@end

@implementation MMRunwayCoreView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _speed = 1;
        _defaultSpace = 30;
        
        _queue = [[_MMRunwayViewQueue alloc] init];
//        _queue.maxConcurrentOperationCount = 100;
    }
    return self;
}

- (instancetype)initWithSpeed:(CGFloat)speed defaultSpace:(CGFloat)defaultSpace{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _speed = speed;
        _defaultSpace = defaultSpace;
        
        _queue = [[_MMRunwayViewQueue alloc] init];
//        _queue.maxConcurrentOperationCount = 100;
    }
    return self;
}

- (void)appendText:(NSString *)text{

    MMRunwayLabel * runwayLabel = [[MMRunwayLabel alloc] init];
    runwayLabel.textColor = [UIColor whiteColor];
    runwayLabel.font = [UIFont systemFontOfSize:16];
    CGSize size = [runwayLabel configText:text];
    runwayLabel.frame = (CGRect){CGPointZero,size};
    [self appendRunwayLabel:runwayLabel];
}

- (void)appendAttributedString:(NSAttributedString *)attString{

    MMRunwayLabel * runwayLabel = [[MMRunwayLabel alloc] init];
    CGSize size = [runwayLabel configAttributedString:attString];
    runwayLabel.frame = (CGRect){CGPointZero,size};
    [self appendRunwayLabel:runwayLabel];
}

- (void)appendRunwayLabel:(MMRunwayLabel *)runwayLabel{

    [self appendCustomView:runwayLabel];
}

- (void)appendCustomView:(UIView *)customView{

    NSAssert(customView != nil, @"请添加一个非nil的视图");
    NSAssert(!CGRectIsNull(customView.bounds), @"请确保customView的bounds已经设置好");
    
    CGRect frame = self.frame;
    BOOL overBorder = customView.frame.size.height - frame.size.height > 0;
    CGFloat y = overBorder ? 0 : (frame.size.height - CGRectGetHeight(customView.frame)) / 2;
    CGFloat x = 0;
    CGFloat selfWidth = frame.size.width;
    if (self.queue.operationCount > 0) {
        _MMRunwayViewOperation * lastOperation = [self.queue lastOperation];
        x = lastOperation.fullyDisplayed ? selfWidth : selfWidth + _defaultSpace;
    }else{
        x = selfWidth;
    }
    customView.frame = (CGRect){
        x, y,
        customView.frame.size
    };
    
    [self addSubview:customView];
    
    _MMRunwayViewOperation * operation = [[_MMRunwayViewOperation alloc] initWithRunwayView:customView];
    operation.speed = _speed;
    [_queue addOperation:operation];
}

@end

