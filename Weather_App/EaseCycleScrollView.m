//
//  EaseCycleScrollView.m
//  Weather_App
//
//  Created by rocky on 2020/7/27.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseCycleScrollView.h"
#import <Masonry.h>
#import "NSArray+Sugar.h"

@interface EaseInnerScrollItemView : UIView

@end
@interface EaseCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) EaseInnerScrollItemView * itemView0;
@property (nonatomic, strong) EaseInnerScrollItemView * itemView1;
@property (nonatomic, strong) EaseInnerScrollItemView * itemView2;

@property (nonatomic ,strong) UIScrollView * contentView;
@property (nonatomic ,strong) EaseCycleScrollConfig * config;

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) NSMutableArray * dataSource;
@end

@implementation EaseCycleScrollView

- (instancetype) initWithConfig:(EaseCycleScrollConfig *)config{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.config = config;
        self.dataSource = [NSMutableArray new];
        [self createViews];
        [self setupAppearance];
        [self scrollToCenter];
    }
    return self;
}

- (void) createViews{
    
    self.contentView = [UIScrollView new];
    [self addSubview:self.contentView];
    
    self.itemView0 = [EaseInnerScrollItemView new];
    self.itemView0.restorationIdentifier = @"conentView.itemView0";
    [self.contentView addSubview:self.itemView0];
    
    self.itemView1 = [EaseInnerScrollItemView new];
    self.itemView1.restorationIdentifier = @"conentView.itemView1";
    [self.contentView addSubview:self.itemView1];
    
    self.itemView2 = [EaseInnerScrollItemView new];
    self.itemView2.restorationIdentifier = @"conentView.itemView2";
    [self.contentView addSubview:self.itemView2];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.itemView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.left.top.equalTo(self.contentView);
    }];
    [self.itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.itemView0);
        if (self.config.axis == EaseCycleScrollAxisHorizontal) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.itemView0.mas_right);
        } else {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.itemView0.mas_bottom);
        }
    }];
    [self.itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.itemView1);
        if (self.config.axis == EaseCycleScrollAxisHorizontal) {
            make.left.equalTo(self.itemView1.mas_right);
            make.centerY.equalTo(self.contentView);
        } else {
            make.top.equalTo(self.itemView1.mas_bottom);
            make.centerX.equalTo(self.contentView);
        }
    }];
}

- (void) setupAppearance{
    if (@available(iOS 11.0, *)) {
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.scrollEnabled = YES;
    self.contentView.showsVerticalScrollIndicator = false;
    self.contentView.showsHorizontalScrollIndicator = false;
    self.contentView.pagingEnabled = true;
    self.contentView.scrollsToTop = false;
    self.contentView.alwaysBounceVertical =
    self.config.axis == EaseCycleScrollAxisVertical;
    self.contentView.alwaysBounceHorizontal =
    self.config.axis == EaseCycleScrollAxisHorizontal;
    self.contentView.delegate = self;
}

- (void) scrollToCenter{
    BOOL horizontal = self.config.axis == EaseCycleScrollAxisHorizontal;
    [self.contentView setContentOffset:(CGPoint){
        (horizontal ? self.bounds.size.width : 0),
        (horizontal ? 0 : self.bounds.size.height)
    } animated:false];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    BOOL horizontal = self.config.axis == EaseCycleScrollAxisHorizontal;
    self.contentView.contentSize = (CGSize){
        self.frame.size.width * (horizontal ? 3 : 1),
        self.frame.size.height * (horizontal ? 1 : 3)
    };
    [self scrollToCenter];
}

- (void) registScrollItemView:(Class)itemViewClazz{
    // for safe
    if (![itemViewClazz.alloc isKindOfClass:UIView.class]) {
        return;
    }
    [self addSubItemView:itemViewClazz.new
             forItemView:self.itemView0];
    [self addSubItemView:itemViewClazz.new
             forItemView:self.itemView1];
    [self addSubItemView:itemViewClazz.new
             forItemView:self.itemView2];
}
- (void) addSubItemView:(__kindof UIView *)subItemView forItemView:(EaseInnerScrollItemView *)itemView{
    // for safe
    if (![subItemView isKindOfClass:UIView.class]) {
        return;
    }
    itemView.clipsToBounds = YES;
    subItemView.tag = 101010;
    [itemView addSubview:subItemView];
    [subItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(itemView);
    }];
}

- (void) setupDataSource:(NSArray *)dataSource atIndex:(NSInteger)index{
    if (index < 0 || index >= dataSource.count) {
        return;
    }
    
    self.index = index;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    [self updateDataForItemViews];

    UIView * targetView = [self.itemView1 viewWithTag:202020];
    if (targetView) {
        [targetView removeFromSuperview];
    }
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewShouldAddContentView:)]) {
        UIView * contentView = [self.delegate cycleScrollViewShouldAddContentView:self];
        contentView.tag = 202020;
        [self.itemView1 addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.itemView1);
        }];
    }
    [self scrollToCenter];
    
    [self toggleForDelegate];
    [self allowScroll:dataSource.count != 1];
}

///<删除指定的房间
- (void) remove:(id)data{
    if ([self.dataSource containsObject:data]) {
        [self removeDataAt:[self.dataSource indexOfObject:data]];
    }
}

- (void) removeDataAt:(NSInteger)index{
    
}

- (void) removeDatas:(NSArray *)datas{
    [datas mm_each:^(id data) {
        [self remove:data];
    }];
    [self toggleForDelegate];
//    [rooms mm_each:^(RoomModel *obj) {
//        [self removeRoom:obj];
//    }];
//    [self toggleRoomForDelegate];
}

///<在当前主播后面插入一条数据，并滚动到该数据处
- (void) insertNewData:(id)newData{
    [self updateDataSourceWithNewData:newData removeCurrentData:NO];
}

///<替换当前数据
- (void) updateWithNewData:(id)newData{
    [self updateDataSourceWithNewData:newData removeCurrentData:YES];
}

///<是否允许滑动
- (void) allowScroll:(BOOL)allow{
    self.contentView.scrollEnabled = allow;
    self.contentView.pagingEnabled = allow;
}

#pragma mark - Private M

- (void) increase{
    self.index += 1;
    if (self.index >= self.dataSource.count) {
        self.index = 0;
    }
}

- (void) decrease {
    self.index -= 1;
    if (self.index < 0) {
        self.index = self.dataSource.count - 1;
    }
}

- (id) preData {
    NSInteger preIndex = self.index - 1;
    if (preIndex < 0) {
        preIndex = self.dataSource.count - 1;
    }
    return self.dataSource[preIndex];
}

- (id) nextData {
    NSInteger nextIndex = self.index + 1;
    if (nextIndex >= self.dataSource.count) {
        nextIndex = 0;
    }
    return self.dataSource[nextIndex];
}

- (void) updateDataForItemViews {
    
    [self setupData:[self preData] forItemView:self.itemView0];
    [self setupData:self.dataSource[self.index] forItemView:self.itemView1];
    [self setupData:[self nextData] forItemView:self.itemView2];
}

- (void) setupData:(id)data forItemView:(EaseInnerScrollItemView *)itemView {
    
    UIView * subItemView = [itemView viewWithTag:101010];
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewUpdateItemView:withData:)]) {
        [self.delegate cycleScrollViewUpdateItemView:subItemView withData:data];
    }
}

- (void) updateDataSourceWithNewData:(id)newData removeCurrentData:(BOOL)remove{
    
    if (newData == self.dataSource[self.index]) {
        return;
    }
    
    BOOL existInDataSource = [self.dataSource containsObject:newData];
    if (existInDataSource) {
        // 存在，滚到当前数据
        NSInteger index = [self.dataSource indexOfObject:newData];
        self.index = index;
    } else {
        // 不存在
        if (remove) {
            self.dataSource[self.index] = newData;
        } else {
            [self.dataSource insertObject:newData atIndex:self.index + 1];
        }
    }
    [self updateDataForItemViews];
    [self toggleForDelegate];
}

#pragma mark - UIScrollViewDelegate

- (void) toggleDataWithOffset:(CGFloat)offset targetValue:(CGFloat)targetValue{
    
    if (offset > 0 && offset < targetValue ){
        [self willBeginToggleForDelegateWithData:[self preData]];
    } else if (offset > targetValue && offset < 2 * targetValue) {
        [self willBeginToggleForDelegateWithData:[self nextData]];
    }
    
    if (offset <= 0 || offset >= 2 * targetValue) {
        if (offset <= 0) {
            // 获取数据源的前一个值
            [self decrease];
        } else {
            // 获取数据源的后一个值
            [self increase];
        }
        [self updateDataForItemViews];
        [self scrollToCenter];
        [self didFinishToggleForDelegateWithData:self.dataSource[self.index]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        
    if (self.config.axis == EaseCycleScrollAxisVertical) {
        [self toggleDataWithOffset:scrollView.contentOffset.y
                       targetValue:self.bounds.size.height];
    } else {
        [self toggleDataWithOffset:scrollView.contentOffset.x
                       targetValue:self.bounds.size.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    switch (self.config.axis) {
        case EaseCycleScrollAxisHorizontal:
            if (scrollView.contentOffset.x != scrollView.bounds.size.width) {
                [self toggleForDelegate];
        }
        case EaseCycleScrollAxisVertical:
            if (scrollView.contentOffset.y != scrollView.bounds.size.height) {
                [self toggleForDelegate];
        }
    }
}

#pragma mark - Toggle

- (void) willBeginToggleForDelegateWithData:(id)data{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:willBeginToggleData:)]) {
        [self.delegate cycleScrollView:self willBeginToggleData:data];
    }
}

- (void) toggleForDelegate{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didToggleData:atIndex:)]) {
        [self.delegate cycleScrollView:self
                         didToggleData:self.dataSource[self.index]
                               atIndex:self.index];
    }
}

- (void) didFinishToggleForDelegateWithData:(id)data{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didFinishToggleData:)]) {
        [self.delegate cycleScrollView:self didFinishToggleData:data];
    }
}
@end

@implementation EaseCycleScrollConfig

@end

@implementation EaseInnerScrollItemView

@end
