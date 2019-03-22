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

@property (nonatomic ,assign) NSUInteger initialIndex;
@property (nonatomic ,assign) NSUInteger currentIndex;
@property (nonatomic ,assign) NSUInteger lastIndex;

@property (nonatomic ,strong) NSMutableArray<RoomModel *> * infiniteDataSource;///<

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

- (void) _setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index{
    [dataSource mm_each:^(RoomModel * _Nonnull obj) {
        NSLog(@"origin datasource:%d",obj.roomId);
    }];
    [self.infiniteDataSource removeAllObjects];
    [self.infiniteDataSource addObjectsFromArray:dataSource];
    NSUInteger scrollToItem = index;
    
    if (dataSource.count > 1) {///<多于一个主播的时候需要进行无限循环
        [self.infiniteDataSource insertObject:dataSource.mm_last atIndex:0];
        [self.infiniteDataSource addObject:dataSource.mm_first];
        scrollToItem ++;
    }
    
    self.initialIndex = scrollToItem;
    self.currentIndex = scrollToItem;
}
- (void) setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index{
    
    [self _setupDataSource:dataSource atIndex:index];
    
    // TODO: 滚动不及时
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self scrollToItemAtIndex:scrollToItem animated:NO];
    //    });
    
    [self toggleLiveView];
}

- (void) removeRoomWithRoomId:(NSUInteger)roomId{
    
    [self.infiniteDataSource mm_each:^(RoomModel * _Nonnull obj) {
        NSLog(@"before remove:%ld",(long)obj.roomId);
    }];
    NSArray * waitRemoveRoomInfos = [self.infiniteDataSource mm_select:^BOOL(RoomModel * _Nonnull obj) {
        return obj.roomId == roomId;
    }];
    
    NSUInteger waitRemoveRoomInfoCount = waitRemoveRoomInfos.count;
    NSUInteger index = [self.infiniteDataSource indexOfObject:[waitRemoveRoomInfos mm_first]];
    [self.infiniteDataSource removeObjectsInArray:waitRemoveRoomInfos];
    
//    NSArray * originDataSource = [self.infiniteDataSource mm_distinctUnion];
//    [self _setupDataSource:originDataSource atIndex:self.currentIndex];
//    [self updateCurrentIndex];
    
    [self scrollToRoomWithRoomId:index animation:NO];
    if (0) {
        
        if (self.infiniteDataSource.count == 2) {///<仅剩一个房间
            [self.infiniteDataSource removeLastObject];
            [self allowScroll:NO];
        } else if (waitRemoveRoomInfoCount == 2) {
            
            [self updateCurrentIndex];
            if (index == 0) {///是第一个，将倒数第二个加到第一个上
                //            [self.infiniteDataSource insertObject:[self.infiniteDataSource mm_objectAtIndex:self.infiniteDataSource.count - 2]
                //                                          atIndex:0];
                [self.infiniteDataSource addObject:[self.infiniteDataSource objectAtIndex:1]];
            } else if (index == 1) {///<是第二个，将第二个加到最后
                // error:这里删除之后，向下、向上滑动会出现重复房间
                [self.infiniteDataSource addObject:[self.infiniteDataSource objectAtIndex:1]];
                //             error:加了这一个之后数据没有过来
                //            self.currentIndex --;
            } else {///<中间的任意一个数据
                self.currentIndex --;
            }
        }
    }
    // 更新currentIndex
    [self.infiniteDataSource mm_each:^(RoomModel * _Nonnull obj) {
        NSLog(@"after remove:%ld",(long)obj.roomId);
    }];
    [self reloadData];
    NSLog(@"after reload data");
}

- (void) removeRoomWithRoomIds:(NSArray <NSNumber *>*)roomIds{
    [roomIds mm_each:^(NSNumber * _Nonnull obj) {
        [self removeRoomWithRoomId:obj.integerValue];
    }];
}

- (void)insertRoomWithRoomInfo:(RoomModel *)roomInfo{
    
    __block NSUInteger roomIndex = NSNotFound;
    __block BOOL existThisRoom = NO;
    [self.infiniteDataSource mm_eachWithIndex:^(RoomModel * _Nonnull obj, NSInteger index) {
        
        if (obj.roomId == roomInfo.roomId) {
            roomIndex = index;
            existThisRoom = YES;
        }
    }];
    
    if (!existThisRoom) {
        ///<插入数据，需要考虑到两边的情况
        
    }
    ///<滚动到这里
    [self scrollToRoomWithRoomId:roomInfo.roomId animation:NO];
}

- (void)updateCurrentRoomWithRoomInfo:(RoomModel *)roomInfo{
    
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
    
    RoomModel * roomInfo = [self.infiniteDataSource objectAtIndex:indexPath.row];
    [cell setupCoverImageWith:roomInfo.pic
                         name:roomInfo.roomName];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.currentIndex == [self convertContentOffsetToIndex]) {
        [self willStartToggleLiveForDelegateWithRoomInfo:[self.infiniteDataSource objectAtIndex:self.currentIndex]];
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
        [self didFinishToggleLiveForDelegateWithRoomInfo:[self.infiniteDataSource objectAtIndex:self.currentIndex]];
    }
}

#pragma mark - Private

- (void) scrollToRoomWithRoomId:(NSUInteger)roomId animation:(BOOL)animation{
    
    __block NSUInteger index = NSNotFound;
    __block RoomModel * targetRoomInfo;
    [self.infiniteDataSource mm_eachWithIndexStop:^BOOL(RoomModel * _Nonnull obj, NSUInteger _index) {
        BOOL findedTarget = obj.roomId == roomId;
        if (findedTarget) {
            index = _index;
            targetRoomInfo = obj;
        }
        return findedTarget;
    }];
    
    if (NSNotFound != index && nil != targetRoomInfo) {
        
        ///<找到要滚动的位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.contentView scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionNone
                                         animated:animation];
        ///<计算当前的索引
        
        ///<更新房间信息
        [self toggleLiveForDelegateWithRoomInfo:targetRoomInfo];
    }
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
    CardCollectionViewCell * cell = (CardCollectionViewCell *)[self.contentView cellForItemAtIndexPath:indexPath];
    [cell.contentView addSubview:[self _liveViewFromDelegate]];
    
    [self toggleLiveForDelegateWithRoomInfo:[self.infiniteDataSource objectAtIndex:self.currentIndex]];
}

- (void) toggleLiveForDelegateWithRoomInfo:(RoomModel *)roomInfo{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:didToggleRoom:atIndex:)]) {
        [self.delegate cardCollectionView:self
                            didToggleRoom:roomInfo
                                  atIndex:self.convertContentOffsetToIndex];
    }
}

- (void) willStartToggleLiveForDelegateWithRoomInfo:(RoomModel *)roomInfo{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:willStartToggleRoom:)]) {
        [self.delegate cardCollectionView:self
                      willStartToggleRoom:roomInfo];
    }
}

- (void) didFinishToggleLiveForDelegateWithRoomInfo:(RoomModel *)roomInfo{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cardCollectionView:didFinishToggleRoom:)]) {
        [self.delegate cardCollectionView:self
                      didFinishToggleRoom:roomInfo];
    }
}

- (void) scrollToItemAtIndex:(NSUInteger)index animated:(BOOL)animated{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentView scrollToItemAtIndexPath:indexPath
                             atScrollPosition:UICollectionViewScrollPositionTop
                                     animated:animated];
}

- (NSUInteger) convertContentOffsetToIndex{
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
