//
//  CardCollectionView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "CardCollectionView.h"
#import "CardCollectionViewCell.h"
#import "Masonry.h"
#import "RoomModel.h"
#import "NSArray+Sugar.h"

#define CardCollectionLiveViewTag 100010

@interface InternalCardCollectionView : UICollectionView
@property (nonatomic ,copy) BOOL (^bCardScrollEnabled)(void);
@end

@interface CardCollectionView ()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic ,weak) RoomModel * currentRoom;///<当前房间

@property (nonatomic ,assign) NSUInteger currentIndex;

@property (nonatomic ,strong) NSMutableArray<RoomModel *> * infiniteDataSource;///<无限滚动的数据源

@property (nonatomic ,strong) InternalCardCollectionView * contentView;
@end

@implementation CardCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        @weakify(self);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.contentView = [[InternalCardCollectionView alloc]initWithFrame:CGRectZero
                                                         collectionViewLayout:flowLayout];
        self.contentView.layer.masksToBounds = NO;
        self.contentView.dataSource = self;
        self.contentView.delegate = self;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.pagingEnabled = YES;
        self.contentView.bounces = YES;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        [self.contentView setBCardScrollEnabled:^BOOL{
//            @strongify(self);
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(cardCollectionViewShouldScroll:)]) {
                return [self.delegate cardCollectionViewShouldScroll:self];
            }
            return YES;
        }];
        [self.contentView registerClass:[CardCollectionViewCell class]
             forCellWithReuseIdentifier:[CardCollectionViewCell cellIdentifier]];
        self.contentView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            self.contentView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.contentView];
        [self reloadData];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.currentIndex = -1;
    }
    return self;
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndex:self.currentIndex animated:NO];
    });
}

#pragma mark - API

- (void) setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index{
    
    if (0 == dataSource.count) {// for safe
        return;
    }
    if (index >= dataSource.count) {// for safe
        index = 0;
    }
    RoomModel * room = [dataSource objectAtIndex:index];
    
    [self.infiniteDataSource removeAllObjects];
    [self.infiniteDataSource addObjectsFromArray:dataSource];
    __block NSUInteger scrollToItem = index;
    
    if (dataSource.count != 1) {///<多于一个主播的时候需要进行无限循环
        [self.infiniteDataSource insertObject:dataSource.mm_last atIndex:0];
        [self.infiniteDataSource addObject:dataSource.mm_first];
        _canSlipCard = YES;
    }
    
    [self.infiniteDataSource mm_eachWithIndex:^(RoomModel * _Nonnull obj, NSInteger index) {
        if (obj.roomId == room.roomId) {
            scrollToItem = index;
        }
    }];
    
    if (dataSource.count != 1) {
        if (scrollToItem == 0) {
            scrollToItem = self.infiniteDataSource.count - 2;
        } else if (scrollToItem == self.infiniteDataSource.count - 1) {
            scrollToItem = 1;
        }
    }
    
    self.currentIndex = scrollToItem;
    
    [self reloadData];
    
    [self toggleLiveView];
}

- (void) removeRooms:(NSArray <RoomModel *>*)rooms{
    [rooms mm_each:^(RoomModel * _Nonnull obj) {
        [self removeRoom:obj];
    }];
}

- (void) removeRoom:(RoomModel *)room{
    
    ///<移除roomId下的room
    [self.infiniteDataSource mm_each:^(RoomModel * _Nonnull obj) {
        if (obj.roomId == room.roomId) {
            [self.infiniteDataSource removeObject:obj];
        }
    }];
    ///<去重获得数据源
    NSMutableArray<RoomModel *> * originDataSource = [[self.infiniteDataSource mm_distinctUnion2] mutableCopy];
    
    __block NSUInteger currentIndex = [originDataSource indexOfObject:self.currentRoom];
    
    [originDataSource mm_eachWithIndex:^(RoomModel * _Nonnull obj, NSInteger index) {
        if (obj.roomId == self.currentRoom.roomId) {
            currentIndex = index;
        }
    }];
    
    [self setupDataSource:originDataSource atIndex:currentIndex];
    [self scrollToItemAtIndex:self.currentIndex animated:NO];
}

- (void) insertNewRoom:(RoomModel *)newRoom{
    
    [self updateDataSourceWithRoom:newRoom removeCurrentRoom:NO];
}

- (void) updateWithNewRoom:(RoomModel *)newRoom{
    
    [self updateDataSourceWithRoom:newRoom removeCurrentRoom:YES];
}

- (void) reloadData{
    [self.contentView reloadData];
}

- (void) allowScroll:(BOOL)allow{
    self.contentView.scrollEnabled = allow;
    self.contentView.pagingEnabled = allow;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infiniteDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CardCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    RoomModel * room = [self.infiniteDataSource objectAtIndex:indexPath.row];
    [cell setupCoverImageWith:room.pic
                         name:room.roomName];
    
    [cell.contentView.subviews mm_eachWithStop:^BOOL(__kindof UIView * _Nonnull view) {
        BOOL isLiveView = view.tag == CardCollectionLiveViewTag;
        if (isLiveView) {
            [view removeFromSuperview];
        }
        return isLiveView;
    }];
    
    if (self.currentIndex == indexPath.item) {///<只在当前的cell上添加
        [cell.contentView addSubview:[self _liveViewFromDelegate]];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"will begin draging");
    if (self.currentIndex == [self convertContentOffsetToIndex]) {
        [self willStartToggleLiveForDelegateWithRoom:[self.infiniteDataSource objectAtIndex:self.currentIndex]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetWhenFullyScrolledTop = scrollView.frame.size.height * (self.infiniteDataSource.count - 1);
    
    if (offsetY == offsetWhenFullyScrolledTop) {
        [self scrollToItemAtIndex:1 animated:NO];
    } else if (offsetY == 0) {
        [self scrollToItemAtIndex:self.infiniteDataSource.count - 2 animated:NO];
    }
    
    // 当停止滚动的时候进行视图的添加和移除、以及index的修改
    if ([self convertContentOffsetToIndex] != self.currentIndex) {
        // 更新currentIndex
        [self updateCurrentIndex];
        [self toggleLiveView];
        ///<更新完成，通知代理
        [self didFinishToggleLiveForDelegateWithRoom:self.currentRoom];
    }
}

#pragma mark - Private

- (void) updateDataSourceWithRoom:(RoomModel *)room removeCurrentRoom:(BOOL)remove{
    
    ///<fix:当从外部进来的是当前的room信息，不需要更新数据结构
    if ([room isEqual:self.currentRoom]) {
        return;
    }
    NSArray<RoomModel *> * newRooms = [self.infiniteDataSource mm_select:^BOOL(RoomModel * _Nonnull obj) {
        return room.roomId == obj.roomId;
    }];
    
    if (self.infiniteDataSource.count > 1) {
        [self.infiniteDataSource removeObjectAtIndex:0];///<在可以无限滑动的时候，将`第一个数据`删除，第一个其实是最后一个数据
    }
    
    NSMutableArray<RoomModel *> * originDataSource = [[self.infiniteDataSource mm_distinctUnion2] mutableCopy];
    __block NSUInteger currentIndex = [originDataSource indexOfObject:self.currentRoom];
    if (currentIndex < originDataSource.count) {
        if (remove) {
            [originDataSource replaceObjectAtIndex:currentIndex withObject:room];
        } else if (0 == newRooms.count){// 不存在，在当前room后面插入，然后滚动到room处
            [originDataSource insertObject:room atIndex:currentIndex + 1];
        }
    }
    
    [originDataSource mm_eachWithIndex:^(RoomModel * _Nonnull obj, NSInteger index) {
        if (obj.roomId == room.roomId) {
            currentIndex = index;
        }
    }];
    
    [self setupDataSource:originDataSource atIndex:currentIndex];
    
    [self scrollToItemAtIndex:self.currentIndex animated:NO];
}

- (void) addLiveViewForCellAtIndexPath:(NSIndexPath *)indexPath{
    
    CardCollectionViewCell * cell = (CardCollectionViewCell *)[self.contentView cellForItemAtIndexPath:indexPath];
    [cell.contentView addSubview:[self _liveViewFromDelegate]];
}

- (void) allowScroll{
    [self allowScroll:YES];
}

- (UIView *) _liveViewFromDelegate{
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionViewShouldAddLiveView:)]) {///<只在当前的cell上添加
        UIView * liveView = [self.delegate cardCollectionViewShouldAddLiveView:self];
        liveView.restorationIdentifier = @"cardCollectionView.liveView";
        liveView.tag = CardCollectionLiveViewTag;
        return liveView;
    }
    return nil;
}

- (void) updateCurrentIndex{
    NSLog(@"before current index:%ld",(long)self.currentIndex);
    self.currentIndex = [self convertContentOffsetToIndex];
    NSLog(@"after current index:%ld",(long)self.currentIndex);
}

- (void) toggleLiveView{
    
    [[self _liveViewFromDelegate] removeFromSuperview];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    
    [self addLiveViewForCellAtIndexPath:indexPath];
    
    self.currentRoom = [self.infiniteDataSource objectAtIndex:self.currentIndex];

    [self toggleLiveForDelegateWithRoom:[self.infiniteDataSource objectAtIndex:self.currentIndex]];
}

- (void) toggleLiveForDelegateWithRoom:(RoomModel *)room{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:didToggleRoom:atIndex:)]) {
        [self.delegate cardCollectionView:self
                            didToggleRoom:room
                                  atIndex:self.convertContentOffsetToIndex];
    }
}

- (void) willStartToggleLiveForDelegateWithRoom:(RoomModel *)room{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:willStartToggleRoom:)]) {
        [self.delegate cardCollectionView:self
                      willStartToggleRoom:room];
    }
}

- (void) didFinishToggleLiveForDelegateWithRoom:(RoomModel *)room{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:didFinishToggleRoom:)]) {
        [self.delegate cardCollectionView:self
                      didFinishToggleRoom:room];
    }
}

- (void) scrollToItemAtIndex:(NSUInteger)index animated:(BOOL)animated{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentView scrollToItemAtIndexPath:indexPath
                             atScrollPosition:UICollectionViewScrollPositionTop
                                     animated:animated];
}

- (NSUInteger) convertContentOffsetToIndex{
    /// bug:由于contentView是使用AL布局的，在这里有可能拿不到具体的frame以及contentOffset，因此这里暂时使用0进行返回
    if (self.contentView.frame.size.height == 0) {
        return 0;
    }
    return self.contentView.contentOffset.y / self.contentView.frame.size.height;
}

#pragma mark - Getter

- (NSMutableArray<RoomModel *> *)infiniteDataSource{
    if (!_infiniteDataSource) {
        _infiniteDataSource = [NSMutableArray array];
    }
    return _infiniteDataSource;
}

@end

@implementation InternalCardCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.bCardScrollEnabled) {
        return self.bCardScrollEnabled();
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
