
## 直播间无限滑动

直播软件中一个基础的功能就是可以上下滑动，这不仅从提升用户体验来说，还是从增大主播曝光度来说，都是一个必不可少的功能。另外，基本上直播间都会使用一个视图控制器来实现，由于其业务场景会很复杂的天然特点，在无限滚动中，不适合对其进行复用，需要保证直播间试图控制器的唯一性。一般来说，实现一个可以无限滑动的组件可以使用UIScrollView来设置offset，也可以使用UICollectionView来解决`数据的循环`，后者的好处是数据源这部分基于UIKit的特性，肯定比自己去写好。

### CardCollectionView

直播间滑动的实现是使用UICollectionView来做UI框架，使用`CardCollectionView`来进行封装，内部有对于数据源的一些逻辑处理，包括**insert**、**remove**、**update**、**reload**，对应的方法如下：
``` objective-c
- (void) removeRoomWithRoomId:(NSUInteger)roomId;
- (void) removeRoomWithRoomIds:(NSArray <NSNumber *>*)roomIds;

- (void) insertNewRoom:(RoomModel *)newRoom;

- (void) updateWithNewRoom:(RoomModel *)newRoom;

- (void) reloadData;
```
对数据源的处理是在`- (void) setupDataSource:(NSArray<RoomModel *> *)dataSource atIndex:(NSUInteger)index`方法中，将外部的数据进行重新排序，比如dataSource为`a,b,c,d`，经过转化之后为`d,a,b,c,d,a`，并将转化之后的数据源赋值给内部使用的一个变量`infiniteDataSource`，并且在滚动结束会后判断当前的索引和位置，来决定具体的显示数据：
``` objective-c
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetWhenFullyScrolledTop = scrollView.frame.size.height * (self.infiniteDataSource.count - 1);

    if (offsetY == offsetWhenFullyScrolledTop) {
        [self scrollToItemAtIndex:1 animated:NO];
    } else if (offsetY == 0) {
        [self scrollToItemAtIndex:self.infiniteDataSource.count - 2 animated:NO];
    }
}
```

### RoomViewController

直播间内部的更新主播的方式这里简单的罗列了一些场景：

* 当前主播关播之后通过滑动被移除
* 当前主播关播之后不滑动，点击推荐的主播被替换
    * 被替换的主播在循环的列表中
    * 被推荐的主播不在循环的列表中
* 在排行榜中进入新的直播间
    * 新的直播间在循环的列表中
    * 新的直播间不在循环的列表中

以上这些都是业务场景，因为要具体情况需要具体分析，所以在上面CardCollectionView中有对应的方法来更新数据源，如果有新的业务场景可以再行添加。

### CardCollectionViewController

通过代理模式，将上面处理数据的（CardCollectionView）和处理具体业务逻辑（RoomViewController）的两部分进行互通，这个角色是`CardCollectionViewController`担当的。控制器内部仅仅负责将两者的一些事件回调进行中转。

其中需要为CardCollectionView提供要展示的视图，这个视图就是业务逻辑中的视图，这里是直播间：
```objective-c
- (__kindof UIView *)cardCollectionViewShouldAddLiveView:(CardCollectionView *)view{
    return self.userLiveVC.view;
}
```

以上的三个部分都可以拆分出来单独使用，并且数据和业务部分不进行耦合，个人认为是一个比较简洁的无限滑动原型。

目前的不足之处有，快速滑动(暴力测试)的时候，在最后一个数据处可能会有卡壳，具体的UI效果为没有形成无限滑动，这是由于上面在减速完成之后才去进行数据的展示，滑动间隔太短导致减速还没有完成。

## 直播间无限滑动 改进版

由于上面的实现方式有一个使用上的瑕疵，因此下面考虑了优化，甚至重新使用新的方式来实现滑动。由于使用UIScrollView来实现需要计算各种位移，处理起来可控性会更高一些，另外无限滑动这种操作的原型可以想象成一个双向循环链表。这样，当前界面的前一个和后一个都可以通过双向循环链表这个数据结构来很方便的获取，而不需要像上一个版本的那样，去拼接一个假的**循环数据**。

> 这个思路的灵感来自于[这个仓库](https://github.com/poos/SXCycleView)，结合上一个版本然后整理出来直播间无限滑动原型。

### MMCycleLinkedList

这个方案中，`双向循环链`是其中的核心，它需要担当数据处理部分的任务，并且要保证内存的合理释放。这个类是在`MMLinkedList`的基础上创建的，并且添加了一些和业务相关的接口：

``` objective-c
#pragma mark - delete
- (BOOL) removeHead;///<移除之后，其后面的节点将会替代它
- (BOOL) removeTail;
- (BOOL) removeCurrent;
- (BOOL) removeValue:(T)value;
- (BOOL) removeValueAtIndex:(NSInteger)index;
- (void) removeAll;

#pragma mark - move
- (void) moveToHead;
- (void) moveToTail;
- (void) moveToIndex:(NSUInteger)index;
- (void) moveToValue:(T)value;
```
由于链表的查询存在耗时（复杂度差不多O(n)）的特性，因此在数据多的时候可能会存在一些问题，这个后期考虑使用其他方式（c、c++）来重新实现链表。另外，双向链表中的节点们之间通过`pre`和`next`来连接，如果都是用`strong`来持有前后节点，会导致循环引用，但又不能全部使用`weak`来修饰，因此这里的节点头文件如下：
``` objective-c
@interface MMNode<T> : NSObject

@property (nonatomic ,strong) MMNode<T> * pre;
@property (nonatomic ,weak) MMNode<T> * next;
@property (nonatomic ,assign) NSUInteger index;

@property (nonatomic ,strong ,readonly) T value;

+ (instancetype) nodeWithValue:(T)value;
- (void) updateValue:(T)newValue;
@end
```
即使节点这样修改了，到了双向循环链表中，还是会出现循环引用的，一个不是很优雅的做法就是在使用的时候注意一下，sad。

### RoomCycleScrollView

这一部分其实和上面版本中的CardCollectionView差不多，只不过他的循环形式是使用三个子视图`RoomCycleItemView`，在滑动结束之后移动到中间位置，并且更新当前的数据给到该子视图，这样的做法比上面好的一个地方是快速滑动的时候不会出现由于位移没到位的卡顿(以及由两个子视图实现也会有这样的情况)。

另外，将无限滚动视图的功能使用`RoomDataSourceHandler`协议抽象了一下，这样方便在控制器中方便的进行切换两种方案。控制器部分基本上不需要大改动，只需要将循环视图替换一下就可以了。
