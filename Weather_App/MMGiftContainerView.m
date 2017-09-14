//
//  MMGiftContainerView.m
//  Weather_App
//
//  Created by user1 on 2017/9/8.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftContainerView.h"

@interface MMGiftContainerView()

@property (nonatomic ,strong) MMGiftEffectOperationMgr * operationMgr;

@end

@implementation MMGiftContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationMgr = [[MMGiftEffectOperationMgr alloc] init];
    }
    return self;
}


- (void)receiveGift:(MMGiftModel *)gift{

    [self.operationMgr appendGiftModel:gift];
}

- (NSArray *)giftViews{
    
    return [_giftViews copy];
}

@end

@implementation MMGiftView


@end
