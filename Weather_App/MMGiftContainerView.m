//
//  MMGiftContainerView.m
//  Weather_App
//
//  Created by user1 on 2017/9/8.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMGiftContainerView.h"
#import "Masonry.h"
#import "YYWeakProxy.h"
#import <pthread.h>

typedef void (^MMDelegateBlock)(id target, Class cls, SEL sel, NSArray *args);

@interface MMDelegateBlockWrapper : NSObject
@property (nonatomic ,copy) NSString * method;
@property (nonatomic, copy) MMDelegateBlock before;

- (void)run:(id)target class:(Class)cls sel:(SEL)sel args:(NSArray *)args;
@end

@interface MMDelegateProxy : NSObject{
    pthread_mutex_t _blockMutex;
}
@property (nonatomic, weak, readonly) id target;
// private
@property (nonatomic, strong) NSMutableDictionary<NSString *,MMDelegateBlockWrapper *> *blockCache;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

- (void) onDelegateSEL:(SEL)sel before:(MMDelegateBlock)before;
@end

@interface MMGiftContainerView(){
    MMDelegateProxy *_delegateProxy;
}

@property (nonatomic ,strong) MMGiftView * giftView;
@property (nonatomic ,strong) MMGiftEffectOperationMgr * operationMgr;

@end

@implementation MMGiftContainerView
- (void)dealloc
{
    NSLog(@"MMGiftContainerView dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        self.operationMgr = [[MMGiftEffectOperationMgr alloc] init];
        
        self.giftView = [MMGiftView new];
        [self addSubview:self.giftView];
        [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.bottom.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setProxy:(id)proxy{
    if (!_proxy && _proxy != proxy) {
        _proxy = proxy;
        _delegateProxy = [MMDelegateProxy proxyWithTarget:proxy];
        [_delegateProxy onDelegateSEL:@selector(trackCallback) before:^(id target, __unsafe_unretained Class cls, SEL sel, NSArray *args) {
            NSLog(@"block:%@",target);
        }];
        self.giftView.delegate = (id)_delegateProxy;
    }
}

- (void)receiveGift:(MMGiftModel *)gift{

    [self.operationMgr appendGiftModel:gift];
}

- (NSArray *)giftViews{
    
    return [_giftViews copy];
}

@end

@implementation MMGiftView
- (void)dealloc
{
    NSLog(@"MMGiftView dealloc");
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) onTapAction{
    if ([self.delegate respondsToSelector:@selector(trackCallback)]) {
        [self.delegate trackCallback];
    }
}
@end

@implementation MMDelegateProxy

- (void)dealloc{
    pthread_mutex_destroy(&_blockMutex);
}

+ (instancetype)proxyWithTarget:(id)target{
    return [[self alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    self = [super init];
    if (self) {
        _target = target;
        _blockCache = [NSMutableDictionary new];
        pthread_mutex_init(&_blockMutex, NULL);
    }
    return self;
}

#pragma mark - API

- (void) onDelegateSEL:(SEL)sel before:(MMDelegateBlock)before{
    
    NSString * method = NSStringFromSelector(sel);
    if (method && ![self blockforKey:method]) {
        MMDelegateBlockWrapper * block = [MMDelegateBlockWrapper new];
        block.method = method;
        block.before = [before copy];
        [self setBlock:block forKey:method];
    }
}

#pragma mark - override

- (void)forwardInvocation:(NSInvocation *)invocation{
    
    Class originClass = [invocation.target class];
    SEL originSelector = invocation.selector;
    MMDelegateBlockWrapper * block = [self blockforKey:NSStringFromSelector(originSelector)];
    if (block && block.before) {
        block.before(invocation.target, originClass, originSelector, nil);
    }
    [super forwardInvocation:invocation];
}

#pragma mark - tools

- (void)setBlock:(MMDelegateBlockWrapper *)block forKey:(NSString *)key{
    pthread_mutex_lock(&_blockMutex);
    [self.blockCache setObject:block forKey:key];
    pthread_mutex_unlock(&_blockMutex);
}

- (MMDelegateBlockWrapper *)blockforKey:(NSString *)key{
    pthread_mutex_lock(&_blockMutex);
    MMDelegateBlockWrapper *block = [self.blockCache objectForKey:key];
    pthread_mutex_unlock(&_blockMutex);
    return block;
}

@end

@implementation MMDelegateBlockWrapper

- (void)run:(id)target class:(Class)cls sel:(SEL)sel args:(NSArray *)args{
    if (self.before) {
        self.before(target, cls, sel, args);
    }
}

@end
