//
//  MMGiftContainerView.m
//  Weather_App
//
//  Created by user1 on 2017/9/8.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftContainerView.h"

@interface MMGiftEffectOperation : NSOperation


@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end

@implementation MMGiftEffectOperation

@synthesize finished = _finished;
@synthesize executing = _executing;


+ (instancetype)animOperationWithUserID:(NSString *)userID model:(id)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    MMGiftEffectOperation *op = [[[self class] alloc] init];
//    op.presentView = [[PresentView alloc] init];
//    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
//        _presentView.model = _model;
        
        //        // i ％ 2 控制最多允许出现几行
        //        if (_index % 2) {
        //             _presentView.frame = CGRectMake(-self.listView.frame.size.width / 2, 300, self.listView.frame.size.width / 2, 40);
        //        }else {
        //             _presentView.frame = CGRectMake(-self.listView.frame.size.width / 2, 230, self.listView.frame.size.width / 2, 40);
        //        }
        
//        _presentView.originFrame = _presentView.frame;
//        [self.listView addSubview:_presentView];
//        
//        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
//            self.finished = finished;
//            self.finishedBlock(finished,finishCount);
//        }];
        
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


@implementation MMGiftContainerView

- (void)receiveGift:(MMGiftModel *)gift{

    
}

- (NSArray *)giftViews{
    
    return [_giftViews copy];
}

@end

@implementation MMGiftView


@end
