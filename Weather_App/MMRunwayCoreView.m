//
//  MMRunwayCoreView.m
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMRunwayCoreView.h"

////////////// 封装具体的跑道视图的类，内部主要进行跑道视图的位移操作，每一个跑道视图都拥有一个计时器
@interface _MMRunwayViewOperation : NSObject{

    __block CGFloat _runwayViewMoveRatio;
    __weak UIView * _runwayView;
    BOOL _finished;
    BOOL _executing;
    CADisplayLink * _link;
}

@property (nonatomic ,weak ,readonly) UIView * runwayView;
@property (nonatomic ,assign ,readonly) CGFloat runwayViewMoveRatio;
@property (nonatomic ,assign) CGFloat speed;//
@property (nonatomic ,assign) BOOL fullyDisplayed;// runwayView是否全部展示出来
@property (nonatomic ,assign) CGRect originalFrame;

@property (nonatomic ,copy) void(^finishedHandle)(BOOL,_MMRunwayViewOperation *);
@property (nonatomic ,copy) void(^progressHandle)(CGFloat ,BOOL ,_MMRunwayViewOperation *);

- (instancetype) initWithRunwayView:(UIView *)runwayView;

- (void) start;
- (void) cancel;
@end

@implementation _MMRunwayViewOperation

- (void)dealloc
{
    NSLog(@"_MMRunwayViewOperation dealloc");
    _link = nil;
    _runwayView = nil;
}

- (instancetype) initWithRunwayView:(UIView *)runwayView{

    self = [super init];
    if (self) {
        
        _runwayView = runwayView;
    }
    return self;
}
////////////// 1.外部通过start函数的调用，开始在主线程中进行计时器操作
- (void)start {
    
    if (_finished || _executing) {
        return;
    }
    _executing = YES;
    [self operationDidStart];
//    [self performSelector:@selector(operationDidStart) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

- (void) cancel{

    [self stopWatch];
}

#pragma mark - Private M

- (void)operationDidStart{

    self.originalFrame = _runwayView.frame;
    
    [self startWatch];
}
////////////// 2.内部通过CADisplayLLink作为计时器，结合runloop，runwayView进行位移操作，并对位移操作做记录，通过block传递出去
- (void)startWatch{
    [self stopWatch];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(track)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)track{
    CGRect frame = _runwayView.frame;
    frame.origin.x -= self.speed;
    _runwayView.frame = frame;
    
    CALayer *presentationLayer = _runwayView.layer.presentationLayer;
    [self handleMaskViewWithMyViewFrame:presentationLayer.frame];
}
////////////// 3.当监控到view已经完全移动出去之后从runloop中移除，并停止计时器
- (void)stopWatch{
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_link invalidate];
    _link = nil;
}
////////////// 具体的runwayView计算位移方法
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

@class _MMRunwayViewQueue;
@protocol _MMRunwayViewQueueDelegate <NSObject>

@optional
- (void) runwayViewQueue:(_MMRunwayViewQueue *)queue willStartOperation:(_MMRunwayViewOperation *)operation;
- (void) runwayViewQueue:(_MMRunwayViewQueue *)queue didFinishOperation:(_MMRunwayViewOperation *)operation;
- (void) runwayViewQueueDidFinishAllOperation:(_MMRunwayViewQueue *)queue;
@end
////////////// 封装数组作为跑道队列的抽象类，可以操作operation
@interface _MMRunwayViewQueue : NSObject{
    
    __block NSMutableArray <_MMRunwayViewOperation *>* _operations;
}
@property (nonatomic ,weak) id<_MMRunwayViewQueueDelegate> delegate;
@property (nonatomic ,assign ,readonly) NSUInteger operationCount;

- (void) addOperation:(_MMRunwayViewOperation *)operation;

- (_MMRunwayViewOperation *)lastOperation;
- (_MMRunwayViewOperation *)currentOperation;

- (void) cancelAllOperations;

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
////////////// 1.添加一个operation
- (void)addOperation:(_MMRunwayViewOperation *)operation{
    
    [_operations addObject:operation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(runwayViewQueue:willStartOperation:)]) {
        [self.delegate runwayViewQueue:self willStartOperation:operation];
    }
    [self startOperation:operation];
}
////////////// 2.判断数组中的operation数量
////////////// 如果只有一个就直接开始operation中的计时器操作
////////////// 如果有在执行中的operation，先加入到数组中，然后通过前一个operation的finishBlock开启下一个operation，依次类推
- (void)startOperation:(_MMRunwayViewOperation *)operation{
    
    operation.finishedHandle = ^(BOOL finished, _MMRunwayViewOperation * _operation) {
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(runwayViewQueue:didFinishOperation:)]) {
            [self.delegate runwayViewQueue:self didFinishOperation:_operation];
        }
        [_operation.runwayView removeFromSuperview];
        [_operations removeObject:_operation];
        
        if (_operations.count == 0 &&
            self.delegate &&
            [self.delegate respondsToSelector:@selector(runwayViewQueueDidFinishAllOperation:)]) {
            [self.delegate runwayViewQueueDidFinishAllOperation:self];
        }
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

- (void) cancelAllOperations{

    [_operations enumerateObjectsUsingBlock:^(_MMRunwayViewOperation * _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [operation.runwayView removeFromSuperview];
        [operation cancel];
    }];
    
    [_operations removeAllObjects];
}

@end

#pragma mark - MMRunwayCoreView
////////////// 用来显示跑道视图的承载视图，
////////////// 内部处理跑道视图的size、根据跑道视图创建operation、将operation加入到queue中，
////////////// 具体的移动操作都是在queue类中进行
@interface MMRunwayCoreView ()<_MMRunwayViewQueueDelegate>

@property (nonatomic ,strong) _MMRunwayViewQueue * queue;

@end

@implementation MMRunwayCoreView

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithSpeed:1 defaultSpace:30];
}

- (instancetype)initWithSpeed:(CGFloat)speed defaultSpace:(CGFloat)defaultSpace{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _speed = speed;
        _defaultSpace = defaultSpace;
        self.clipsToBounds = YES;
//        self.hidden = YES;
        
        _queue = [[_MMRunwayViewQueue alloc] init];
        _queue.delegate = self;
    }
    return self;
}

- (void)appendText:(NSString *)text{

    MMRunwayLabel * runwayLabel = [[MMRunwayLabel alloc] init];
    runwayLabel.textColor = [UIColor orangeColor];
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

    UIView * _runwayView = customView;
    if (customView.superview &&
        [customView respondsToSelector:@selector(copyWithZone:)]) {
        _runwayView = [customView copy];
    }
    
    CGRect frame = self.frame;
    BOOL overBorder = _runwayView.frame.size.height - frame.size.height > 0;
    CGFloat y = overBorder ? 0 : (frame.size.height - CGRectGetHeight(_runwayView.frame)) / 2;
    CGFloat x = 0;
    CGFloat selfWidth = frame.size.width;
    if (self.queue.operationCount > 0) {
        _MMRunwayViewOperation * lastOperation = [self.queue lastOperation];
        x = lastOperation.fullyDisplayed ? selfWidth : selfWidth + _defaultSpace;
    }else{
        x = selfWidth;
    }
    _runwayView.frame = (CGRect){
        x, y,
        _runwayView.frame.size
    };
    
    [self addSubview:_runwayView];
    
    _MMRunwayViewOperation * operation = [[_MMRunwayViewOperation alloc] initWithRunwayView:_runwayView];
    operation.speed = _speed;

    [_queue addOperation:operation];
}

- (void)removeAllRunwayView{

    [_queue cancelAllOperations];
}

#pragma mark - _MMRunwayViewQueueDelegate M

- (void)runwayViewQueue:(_MMRunwayViewQueue *)queue willStartOperation:(_MMRunwayViewOperation *)operation{

    if (self.delegate && [self.delegate respondsToSelector:@selector(runwayCoreView:willStartDisplayItemView:)]) {
        [self.delegate runwayCoreView:self willStartDisplayItemView:operation.runwayView];
    }
}

- (void)runwayViewQueueDidFinishAllOperation:(_MMRunwayViewQueue *)queue{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(runwayCoreViewDidFinishDisplayAllItemView:)]) {
        [self.delegate runwayCoreViewDidFinishDisplayAllItemView:self];
    }
}

- (void) runwayViewQueue:(_MMRunwayViewQueue *)queue didFinishOperation:(_MMRunwayViewOperation *)operation{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(runwayCoreView:didFinishDisplayItemView:)]) {
        [self.delegate runwayCoreView:self didFinishDisplayItemView:operation.runwayView];
    }
}
@end

#pragma mark - UILabel+TXLabel

@implementation MMRunwayLabel

- (id)copyWithZone:(NSZone *)zone
{
    MMRunwayLabel *label = [[[self class] alloc] init]; // <== 注意这里
    if (self.text) {
        [label configText:self.text];
    }
    if (self.attributedText) {
        [label configAttributedString:self.attributedText];
    }
    label.frame = self.frame;
    return label;
}

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
