//
//  RoomCycleScrollView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/4/3.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "RoomCycleScrollView.h"
#import "Masonry.h"
#import "RoomModel.h"
#import "MMLinkedList.h"
#import "UIColor+Common.h"
//#import "UIImageView+WebCache.h"
#import "NSArray+Sugar.h"

@interface RoomCycleItemView : UIView
@property (nonatomic ,strong) UILabel * label;
@property (strong, nonatomic) UIVisualEffectView *coverEffectView;
@property (strong, nonatomic) UIImageView *coverImageView;

- (void) setupCoverImageWith:(NSString *)imageUrl name:(NSString *)name;
@end

@interface RoomCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) RoomCycleItemView * itemView0;
@property (nonatomic, strong) RoomCycleItemView * itemView1;
@property (nonatomic, strong) RoomCycleItemView * itemView2;

@property (nonatomic ,strong) MMCycleLinkedList<RoomModel *> * linkedList;
@end

@implementation RoomCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
    }
    return self;
}

- (void)createView {
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.backgroundColor = [UIColor randomColor];
    self.scrollEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.scrollsToTop = NO;
    self.alwaysBounceVertical = YES;
    
    self.itemView0 = [[RoomCycleItemView alloc] initWithFrame:(CGRect){
        CGPointZero,
        self.bounds.size
    }];
    self.itemView0.restorationIdentifier = @"conentView.itemView0";
    [self addSubview:self.itemView0];
    
    self.itemView1 = [[RoomCycleItemView alloc] initWithFrame:(CGRect){
        0,self.bounds.size.height,
        self.bounds.size
    }];
    self.itemView1.restorationIdentifier = @"conentView.itemView1";
    [self addSubview:self.itemView1];
    
    self.itemView2 = [[RoomCycleItemView alloc] initWithFrame:(CGRect){
        0,self.bounds.size.height * 2,
        self.bounds.size
    }];
    self.itemView2.restorationIdentifier = @"conentView.itemView2";
    [self addSubview:self.itemView2];
    
    if (!CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        self.contentSize = CGSizeMake(self.bounds.size.width,
                                      self.bounds.size.height * 3);
    }
    [self.itemView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.left.top.equalTo(self);
    }];
    
    [self.itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.itemView0);
        make.left.equalTo(self.itemView0);
        make.top.equalTo(self.itemView0.mas_bottom);
    }];
    
    [self.itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.itemView1);
        make.left.equalTo(self.itemView1);
        make.top.equalTo(self.itemView1.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate{
    NSAssert(delegate == self ||
             delegate == nil, @"setup RoomCycleScrollView's cycleDelegate for %@",delegate);
    [super setDelegate:delegate];
}

#pragma mark - API

- (void)setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index{
    
    self.linkedList = [[MMCycleLinkedList alloc] initWithArray:dataSource];
    
    ///<找到cls的currentNode
    [self.linkedList valueAtIndex:index];
    
    [self updateDataForItemViews];
    
    [self scrollToCenter];
    
    [self.itemView1 addSubview:[self liveViewFromDelegate]];
    
    [self toggleRoomForDelegate];
}

///<删除指定的房间
- (void) removeRoom:(RoomModel *)room{
    [self.linkedList removeValue:room];
}

- (void) removeRooms:(NSArray<RoomModel *> *)rooms{
    [rooms mm_each:^(RoomModel *obj) {
        [self removeRoom:obj];
    }];
    [self toggleRoomForDelegate];
}

///<在当前主播后面插入一条数据，并滚动到该数据处
- (void) insertNewRoom:(RoomModel *)newRoom{
 
    [self updateDataSourceWithRoom:newRoom removeCurrentRoom:NO];
}

///<替换当前直播间数据为新的直播间
- (void) updateWithNewRoom:(RoomModel *)newRoom{
    
    [self updateDataSourceWithRoom:newRoom removeCurrentRoom:YES];
}

///<是否允许滑动
- (void) allowScroll:(BOOL)allow{
    self.scrollEnabled = allow;
    self.pagingEnabled = allow;
}

- (BOOL)canSlipCard{
    return self.linkedList.count > 1;
}

#pragma mark - Privet M

- (void) updateDataSourceWithRoom:(RoomModel *)newRoom removeCurrentRoom:(BOOL)remove{
    
    ///<fix:当从外部进来的是当前的room信息，不需要更新数据结构
    if ([newRoom isEqual:self.linkedList.current.value]) {
        return;
    }
    
    NSArray * newRooms = [self.linkedList findValue:newRoom];
    if (0 == newRooms.count) {
        
        if (remove) {
            //如果链表中不存在，直接替换
            [self.linkedList.current updateValue:newRoom];
        } else {
            ///<不存在，也不删除当前房间，在后面插入一个
            [self.linkedList insertValue:newRoom atIndex:self.linkedList.current.index + 1];
            [self.linkedList moveToValue:newRoom];
        }
        
        [self updateDataForItemViews];
        [self toggleRoomForDelegate];
    } else {
        //如果链表中存在newRoom，则直接跳到newRoom中，并且移除当前节点
        if (remove) {        
            [self.linkedList removeCurrent];
        }
        [self.linkedList moveToValue:newRoom];
        
        [self updateDataForItemViews];
        [self toggleRoomForDelegate];
    }
}

- (UIView *) liveViewFromDelegate{
    
    if (self.cycleDelegate &&
        [self.cycleDelegate respondsToSelector:@selector(roomCycleScrollViewShouldAddLiveView:)]) {
        UIView * liveView = [self.cycleDelegate roomCycleScrollViewShouldAddLiveView:self];
        liveView.restorationIdentifier = @"cycleScrollView.liveView";
        return liveView;
    }
    return nil;
}

- (void) updateDataForItemViews{
    
    MMNode * currentNode = self.linkedList.current;
    [self setupData:currentNode.pre.value forItemView:self.itemView0];
    [self setupData:currentNode.value forItemView:self.itemView1];
    [self setupData:currentNode.next.value forItemView:self.itemView2];
}

- (void) setupData:(RoomModel *)room forItemView:(RoomCycleItemView *)itemView{
    [itemView setupCoverImageWith:room.pic
                             name:room.roomName];
}

- (void) scrollToCenter{
    [self setContentOffset:CGPointMake(0, self.bounds.size.height)
                              animated:NO];
}

- (CGFloat) contentOffsetY{
    return self.contentOffset.y;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.contentOffsetY > 0 &&
        self.contentOffsetY < self.bounds.size.height) {
        [self willStartToggleRoomForDelegate:self.linkedList.current.pre.value];
    } else if (self.contentOffsetY > self.bounds.size.height &&
               self.contentOffsetY < 2 * self.bounds.size.height) {
        [self willStartToggleRoomForDelegate:self.linkedList.current.next.value];
    }
    
    if (self.contentOffsetY <= 0 ||
        self.contentOffsetY >= 2 * self.bounds.size.height) {
        
        if (self.contentOffsetY <= 0) {
            [self.linkedList preValue];
        } else {
            [self.linkedList nextValue];
        }
        [self updateDataForItemViews];
        
        [self scrollToCenter];

        [self didFinishToggleRoomForDelegate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y != scrollView.bounds.size.height) {
        [self toggleRoomForDelegate];
    }
}

#pragma mark - WrappDelegate

- (void) willStartToggleRoomForDelegate:(RoomModel *)room{
    if (self.cycleDelegate &&
        [self.cycleDelegate respondsToSelector:@selector(roomCycleScrollView:willStartToggleRoom:)]) {
        [self.cycleDelegate roomCycleScrollView:self
                            willStartToggleRoom:room];
    }
}

- (void) toggleRoomForDelegate{
    if (self.cycleDelegate &&
        [self.cycleDelegate respondsToSelector:@selector(roomCycleScrollView:didToggleRoom:atIndex:)]) {
        [self.cycleDelegate roomCycleScrollView:self
                                  didToggleRoom:self.linkedList.currentValue
                                        atIndex:self.linkedList.current.index];
    }
}

- (void) didFinishToggleRoomForDelegate{
    if (self.cycleDelegate &&
        [self.cycleDelegate respondsToSelector:@selector(roomCycleScrollView:didFinishToggleRoom:)]) {
        [self.cycleDelegate roomCycleScrollView:self
                            didFinishToggleRoom:self.linkedList.current.value];
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.linkedList.count == 1) {
        return NO;
    }
    if (self.cycleDelegate &&
        [self.cycleDelegate respondsToSelector:@selector(roomCycleScrollViewShouldScroll:)]) {
        return [self.cycleDelegate roomCycleScrollViewShouldScroll:self];
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}
@end

@implementation RoomCycleItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
        
        self.coverImageView = [UIImageView new];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self addSubview:self.coverImageView];
        
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.coverEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:self.coverEffectView];
        
        self.label = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.coverEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void) setupCoverImageWith:(NSString *)imageUrl name:(NSString *)name{
    self.label.text = name;
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
