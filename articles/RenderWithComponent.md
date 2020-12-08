##  Render with Component

我们工作中使用的最多还是UITableView/UICollectionView这两个UIView的子类，过于繁琐的数据源、代理方法写起来会不好重用，因此在解耦表视图上更多的方法是在其上再加一层，编写一套通用规范，可以应用于更多的场景。

这些方案中，有使用MVVM将数据源、代理方法放置在一处，业务只需针对具体的UI来进行绘制、设置数据即可。因为我们业务中更多的就是针对不同的UI展示不同的数据，其内部的通用逻辑可以下沉到一层来作为公用部分，前篇`MVVM`中所演示的就是该方法。

另外一种将整个模块（ViewController）进行从上到下的解耦，从整体到细节都进行分离抽象，这样可以在更细的维度上来组装我们的界面。以一种`Module-DataSource-Component-Layout`的架构来描述最终的界面，在业务中最关心的Component中来绘制UI以及设置数据，在Layout中来决定整体UI的展示，这也是前篇`HomeModule`中所展示的方案。

这次就再使用一种方案来对界面进行解耦，这种方案不同于前两者，本案是一种类似于`声明式`的方式来组装界面，同时也忽略了具体内在的UITableView、UICollectionView，使业务方只需要根据对应的Component来组装UI。

### Component

`Component`是对一块UI的抽象，反映到UITableView中可以认为是一个Section的Header、Cell、Footer。Component需要确定要展示的`Content`，这个Content是UIView的子类，用来决定具体的展示内容。Component除了需要确定要展示的视图还可以确定视图的展示尺寸，同时具备视图的展示、消失、点选等事件的回调，在这一点上和`HomeModule中的Component`是一致的。





