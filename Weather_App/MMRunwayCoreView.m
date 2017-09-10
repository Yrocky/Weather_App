//
//  MMRunwayCoreView.m
//  Weather_App
//
//  Created by user1 on 2017/9/4.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMRunwayCoreView.h"
#import <CoreText/CoreText.h>

@interface _MMRunwayViewOperation : NSOperation{

    __block CGFloat _runwayViewMoveRatio;
}

@property (nonatomic ,strong ) UIView * runwayView;
@property (nonatomic,copy ) NSString * runwayKey;
@property (nonatomic ,assign) CGFloat speed;// 移动10px需要的时间
@property (nonatomic ,assign ,readonly) CGFloat runwayViewMoveRatio;

@property (nonatomic ,copy) void(^finishedHandle)(BOOL,_MMRunwayViewOperation *);

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

+ (instancetype) operationWithRunwayView:(UIView *)runwayView finishedHandle:(void(^)(BOOL result,_MMRunwayViewOperation * operation))finished;

@end

@implementation _MMRunwayViewOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

#pragma mark - Thread

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"RunwayCoreViewThread"];
        do {
            [[NSRunLoop currentRunLoop] run];
        }
        while (YES);
    }
}

static NSThread *_networkRequestThread = nil;

+ (void)endNetworkThread {
    if (!_networkRequestThread) {
        return;
    }
    
    if ([NSThread currentThread] == _networkRequestThread) {
        [NSThread exit];
    }
    else {
        [NSThread performSelector:@selector(exit) onThread:_networkRequestThread withObject:nil waitUntilDone:NO];
    }
    
    _networkRequestThread = nil;
}

+ (BOOL)networkRequestThreadIsAvailable {
    return (_networkRequestThread != nil);
}

+ (NSThread *)networkRequestThread {
    if (!_networkRequestThread) {
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    }
    
    return _networkRequestThread;
}

+ (instancetype)operationWithRunwayView:(UIView *)runwayView finishedHandle:(void (^)(BOOL, _MMRunwayViewOperation *))finished{

    _MMRunwayViewOperation * operation = [[_MMRunwayViewOperation alloc] init];
    operation.runwayView = runwayView;
    operation.finishedHandle = finished;
    return operation;
    return [[self alloc] initWithRunwayView:runwayView finishedHandle:finished];
}

- (instancetype) initWithRunwayView:(UIView *)runwayView finishedHandle:(void(^)(BOOL,_MMRunwayViewOperation *))finishedHandle{

    self = [super init];
    if (self) {
        
        self.executing = NO;
        self.finished  = NO;
        
        NSString * runwayKey = [NSString stringWithFormat:@"%lu",(unsigned long)runwayView.hash];
        _runwayKey = runwayKey;
        
        _runwayView = runwayView;
        
        _finishedHandle = finishedHandle;
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    if ([self isReady]) {
        self.executing = YES;
        [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO];
    }else{
        NSLog(@"Error: Cannot start Operation: Operation is not ready to start");
    }
}

- (void)operationDidStart{

    CGRect frame = self.runwayView.frame;
    CGFloat width = frame.size.width;
    frame.origin.x = -width;
    CGFloat duration = width * 0.1 * self.speed;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.runwayView.frame = frame;
    }completion:^(BOOL finished) {
        
        if (!self.isCancelled) {
            [self cancel];
        }
        self.executing = NO;
        self.finished = YES;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (_finishedHandle) {
                _finishedHandle(finished,self);
            }
        }];
    }];
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}
@end

#pragma mark - UILabel+TXLabel

@implementation MMRunwayLabel

+ (instancetype)label {
    MMRunwayLabel *label = [[MMRunwayLabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (CGSize) configAttributedString:(NSAttributedString *)attString{

    NSAssert(attString, @"请设置有效的 NSAttributedString ");
    
    [self setAttributedText:attString];
    CGSize size = [attString size];
    NSLog(@"att size :%@",NSStringFromCGSize(size));
    return size;
}
- (CGSize) configText:(NSString *)text{

    [self setText:text];
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.font.pointSize)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.font} context:nil].size;
    NSLog(@"text size :%@",NSStringFromCGSize(size));
    return size;
}
@end

#pragma mark - MMRunwayCoreView

@interface MMRunwayCoreView ()

@property (nonatomic ,strong) NSOperationQueue * queue;

@property (weak, nonatomic) MMRunwayLabel *upLabel;
//定时器
@property (strong, nonatomic) NSTimer *scrollTimer;
//文本行分割数组
@property (strong, nonatomic) NSArray *scrollArray;

@property (strong, nonatomic) NSArray *scrollTexts;
//当前滚动行
@property (assign, nonatomic) NSInteger currentSentence;
//是否第一次开始计时
@property (assign, nonatomic, getter=isFirstTime) BOOL firstTime;
//传入参数是否为数组
@property (assign, nonatomic) BOOL isArray;

@end

@implementation MMRunwayCoreView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _speed = 1;
        _defaultSpace = 30;
        
        _operations = [NSMutableArray array];
        
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 100;
    }
    return self;
}

- (instancetype)initWithSpeed:(CGFloat)speed defaultSpace:(CGFloat)defaultSpace{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        _speed = speed;
        _defaultSpace = defaultSpace;
        
        _operations = [NSMutableArray array];
        
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 100;
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
    customView.frame = (CGRect){
        frame.size.width, y,
        customView.frame.size
    };
    
    [self addSubview:customView];
    _MMRunwayViewOperation * operation = [[_MMRunwayViewOperation alloc] initWithRunwayView:customView finishedHandle:^(BOOL result, _MMRunwayViewOperation *_operation) {
//        NSInteger index = [self.queue.operations indexOfObject:_operation];
//        if (index < self.queue.operationCount - 1) {
//            
//            _MMRunwayViewOperation * nextOperation = self.queue.operations[index + 1];
//            [nextOperation start];
//        }
//        [_operation.runwayView removeFromSuperview];
        [_operations removeObject:_operation];
        NSLog(@"count:%lu",(unsigned long)self.queue.operationCount);
    }];
    operation.speed = _speed;
    [_operations addObject:operation];
    [self.queue addOperation:operation];
    
    NSInteger index = [self.queue.operations indexOfObject:operation];
    if (index > 0) {
        _MMRunwayViewOperation * perOperation = self.queue.operations[index - 1];
        [operation addDependency:perOperation];
    }
    if (self.queue.operationCount == 1) {
        [operation start];
    }
}

#pragma mark - Custom Methods

/** 重置滚动视图 */
- (void)resetScrollLabelView {
//    [self endup];//停止滚动
//    [self setupSubviewsLayout];//重新布局
//    [self startup];//开始滚动
}
#pragma mark - SubviewsLayout Methods

- (void)setupSubviewsLayout {
//    if (self.isArray) {
//        [self setupInitial];
//    }else {
//        [self setupSubviewsLayout_LeftRight];
//    }
}

- (void)setupSubviewsLayout_LeftRight {
    
//    CGFloat labelMaxH = self.tx_height;//最大高度
//    CGFloat labelMaxW = 0;//无限宽
//    CGFloat labelH = labelMaxH;//label实际高度
//    __block CGFloat labelW = 0;//label宽度，有待计算
//    self.contentOffset = CGPointZero;
//    [self setupLRUDTypeLayoutWithMaxSize:CGSizeMake(labelMaxW, labelMaxH) width:labelW height:labelH completedHandler:^(CGSize size) {
//        labelW = MAX(size.width, self.tx_width);
//        //开始布局
//        self.upLabel.frame = (CGRect){
//            _scrollInset.left + self.frame.size.width, 0,
//            labelW, labelH
//        };
//    }];
}

- (void)setupLRUDTypeLayoutWithMaxSize:(CGSize)size
                                 width:(CGFloat)width
                                height:(CGFloat)height
                      completedHandler:(void(^)(CGSize size))completedHandler {
//    CGSize scrollLabelS = [_scrollTitle boundingRectWithSize:size
//                                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                                  attributes:@{NSFontAttributeName: self.font} context:nil].size;
//    //回调获取布局数据
//    completedHandler(scrollLabelS);
//    if (!self.isArray) {
//        [self setupTitle:_scrollTitle];
//    }
}

- (void)setupLRUDTypeLayoutWithTitle:(NSString *)title
                             maxSize:(CGSize)size
                               width:(CGFloat)width
                              height:(CGFloat)height
                    completedHandler:(void(^)(CGSize size))completedHandler {
//    CGSize scrollLabelS = [title boundingRectWithSize:size
//                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:@{NSFontAttributeName: self.font} context:nil].size;
//    //回调获取布局数据
//    completedHandler(scrollLabelS);
}

/**
 update the frame of scrollLabel. Just layout
 
 @param text scrollText
 @param type scrollLabel type
 */
//- (void)updateLeftRightScrollLabelLayoutWithText:(NSString *)text labelType:(TXScrollLabelType)type {
//    }

//#pragma mark - Scrolling Operation Methods -- Public
//
//- (void)beginScrolling {
//    self.currentSentence = 0;
//    if (self.isArray) {
//        [self setupInitial];
//    }
//    [self startup];
//}
//
//- (void)endScrolling {
//    [self endup];
//}
//
//- (void)pauseScrolling {
//    [self endup];
//}
//
//#pragma mark - Scrolling Operation Methods -- Private
//
//- (void)endup {
//    [self.scrollTimer invalidate];
//    self.scrollTimer = nil;
//    self.scrollArray = nil;
//}
//
//- (void)startup {
//    if (!self.scrollTitle.length && !self.scrollArray.count) return;
//    
//    [self endup];
//    
//    [self startWithVelocity:self.scrollVelocity];
//}

//开始计时
- (void)startWithVelocity:(NSTimeInterval)velocity {
    //    if (!self.scrollTitle.length) return;
    
//    if (!self.scrollTitle.length && self.scrollArray.count) return;
//    
//    __weak typeof(self) weakSelf = self;
//    self.scrollTimer = [NSTimer tx_scheduledTimerWithTimeInterval:velocity repeat:YES block:^(NSTimer *timer) {
//        MMRunwayCoreView *strongSelf = weakSelf;
//        if (strongSelf) {
//            [strongSelf updateScrolling];
//        }
//    }];
//    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - Scrolling Animation Methods

- (void)updateScrolling {
    
//    if (self.contentOffset.x >= (_scrollInset.left + self.upLabel.tx_width + self.scrollSpace + self.tx_width)) {// 滚动的文字滚动结束
//        /** 更新 Label.text */
//        if ((self.contentOffset.x > (_scrollInset.left + self.upLabel.tx_width) - self.tx_width) &&
//            self.isArray) {
//            [self updateTextForScrollViewWithSEL:@selector(updateLeftRightScrollLabelLayoutWithText:labelType:)];
//        }
//        [self endup];
//        [self setContentOffset:CGPointMake(self.scrollInset.left + 2.5, 0)];
//        [self startup];
//    }else {
//        [self setContentOffset:CGPointMake(self.contentOffset.x + 2.5, self.contentOffset.y)];
//    }
}

#pragma mark - Params For Array

void (*setter)(id, SEL, NSString *, TXScrollLabelType);

- (void)updateTextForScrollViewWithSEL:(SEL)sel {
    
//    if (!self.scrollArray.count) return;
//    
//    /** 更新文本 */
//    [self updateScrollText];
//    /** 执行 SEL */
//    setter = (void (*)(id, SEL, NSString *, TXScrollLabelType))[self methodForSelector:sel];
//    setter(self, sel, self.upLabel.text, TXScrollLabelTypeUp);
}

- (void)updateScrollText {
    NSInteger currentSentence = self.currentSentence;
    if (currentSentence >= self.scrollArray.count) currentSentence = 0;
    self.upLabel.text = self.scrollArray[currentSentence];
    currentSentence ++;
    if (currentSentence >= self.scrollArray.count) currentSentence = 0;
    
    self.currentSentence = currentSentence;
}

#pragma mark - Text-Separator

-(NSArray *)getSeparatedLinesFromLabel {
//    if (!_scrollTitle.length) return nil;
//    
//    NSString *text = _scrollTitle;
//    UIFont *font;//self.font;
//    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
//    
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0,0,self.upLabel.tx_width,100000));
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//    
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
//    for (id line in lines) {
//        CTLineRef lineRef = (__bridge CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        NSString *lineString = [text substringWithRange:range];
//        [linesArray addObject:lineString];
//    }
    
    return (NSArray *)linesArray;
}

@end


@implementation UIView (TXFrame)

- (CGFloat)tx_x {
    return self.frame.origin.x;
}

- (void)setTx_x:(CGFloat)tx_x {
    CGRect frame = self.frame;
    frame.origin.x = tx_x;
    self.frame = frame;
}

- (CGFloat)tx_y {
    return self.frame.origin.y;
}

- (void)setTx_y:(CGFloat)tx_y {
    CGRect frame = self.frame;
    frame.origin.y = tx_y;
    self.frame = frame;
}

- (CGFloat)tx_width {
    return self.frame.size.width;
}

- (void)setTx_width:(CGFloat)tx_width {
    CGRect frame = self.frame;
    frame.size.width = tx_width;
    self.frame = frame;
}

- (CGFloat)tx_height {
    return self.frame.size.height;
}

- (void)setTx_height:(CGFloat)tx_height {
    CGRect frame = self.frame;
    frame.size.height = tx_height;
    self.frame = frame;
}

- (CGSize)tx_size {
    return self.frame.size;
}

- (void)setTx_size:(CGSize)tx_size {
    CGRect frame = self.frame;
    frame.size = tx_size;
    self.frame = frame;
}

- (CGPoint)tx_origin {
    return self.frame.origin;
}

- (void)setTx_origin:(CGPoint)tx_origin {
    CGRect frame = self.frame;
    frame.origin = tx_origin;
    self.frame = frame;
}

- (CGPoint)tx_center {
    return self.center;
}

- (void)setTx_center:(CGPoint)tx_center {
    self.center = tx_center;
}

- (CGFloat)tx_centerX {
    return self.center.x;
}

- (void)setTx_centerX:(CGFloat)tx_centerX {
    CGPoint center = self.center;
    center.x = tx_centerX;
    self.center = center;
}

- (CGFloat)tx_centerY {
    return self.center.y;
}

- (void)setTx_centerY:(CGFloat)tx_centerY {
    CGPoint center = self.center;
    center.y = tx_centerY;
    self.center = center;
}

- (CGFloat)tx_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setTx_bottom:(CGFloat)tx_bottom {
    CGRect frame = self.frame;
    frame.origin.y = tx_bottom - frame.size.height;
    self.frame = frame;
}

@end
