##  RefreshProxy

每一个项目中都会使用下拉刷新控件，当然更多的不会使用系统的UIRefreshControl控件，而是使用第三方刷新控件。

并且为了风格统一，所有的刷新控件都是一致的，在所有需要的地方重复的使用这些方法难免会很繁琐，大多都是样板代码，并且在替换风格的时候也不是很方便。

一个好的做法是将刷新相关的功能抽离出来，只在需要的业务处添加即可，让业务和第三方组件之间没有直接联系，进行解耦。

另外，有下拉刷新和上拉加载更多的地方往往需要维护一些状态，比如当前的页数，是否处于刷新还是加载更多的状态，这些逻辑在任何业务中都是一样的，页数随着上拉加载更多自增，下拉刷新的时候置为原始值。

这里就对这样的需求进行封装，抽离出来一个RefreshProxy组件。

### usage

根据一个ScrollView初始化RefreshProxy，然后使用`-addRefresh`和`-addLoadMore`接口就可以添加对应的刷新控件了，刷新控件已经被封装在了RefreshProxy内部，以及上面提到的索引的修改等逻辑：

``` objective-c

self.refreshProxy = [[EaseRefreshProxy alloc] initWithScrollView:self.collectionView];
[self.refreshProxy setupPageOrigIndex:0 andSize:20];
[self.refreshProxy addRefresh:^(NSInteger index) {
    @strongify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshProxy endRefresh];
    });
}];
[self.refreshProxy addLoadMore:@"没有更多内容" callback:^(NSInteger index) {
    @strongify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshProxy endLoadMore];
    });
}];
```

