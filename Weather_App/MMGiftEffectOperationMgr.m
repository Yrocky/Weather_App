//
//  MMGiftEffectOperationMgr.m
//  Weather_App
//
//  Created by user1 on 2017/9/12.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftEffectOperationMgr.h"

@interface MMGiftEffectOperationMgr ()

@property (nonatomic,strong) NSOperationQueue *queue1;
@property (nonatomic,strong) NSOperationQueue *queue2;

@property (nonatomic,strong) NSCache *operationCache;
@property (nonatomic,strong) NSCache *userGigtInfos;
@end

@implementation MMGiftEffectOperationMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operations = [NSMutableArray array];
        
        _operationCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)startTrack{
    [self stopTrack];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(track)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopTrack{
    
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_link invalidate];
    _link = nil;
}

- (void) track{
}

- (void)appendGiftModel:(MMGiftModel *)giftModel{

    
    
}

- (void) addOperation:(MMGiftEffectOperation *)operation{

    [_operations addObject:operation];
}

@end


@interface MMGiftEffectOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation MMGiftEffectOperation

+ (instancetype)animOperationWithGiftModel:(MMGiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
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
        
    }
    return self;
}

- (void)start {
    
    if (self.isFinished || self.isExecuting) {
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
    }];
    
}


- (void) updateWith:(MMGiftModel *)model{

    
}

@end

@implementation MMGiftModel

@end
