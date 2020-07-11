##  首页解耦

在直播的业务开发中，首页会有太多的耦合，特别是那种多页面嵌套的结构，很多东西都需要共用，UI结构类似、点击cell的效果类似、空白页类似等等。另外，首页可能会有很深的视图控制器之间的继承，比如将相同逻辑在基类中实现，子类实现具体的逻辑。由于具备特殊的UI性，即使有其他模块也有类似的结构，首页的逻辑很难被其他地方复用。

基于以上的这些痛点，考虑将首页进行解耦，抽离出来一个高复用、可配置的功能模块。

todo 展示图片

### 拆分

在拆分模块的时候，参考的是IGListKit。IGListKit中对UICollectionView的抽离是将每个小模块抽象成一个SectionController，并且在SectionController中决定具体的cell、insert、spacing、header、footer等等。

TODO 图片

基于我们具体的业务，一共抽离出来`Module`、`DataSource`、`Component`和`Layout`四个模块。Module表示一个具体的业务，比如首页的一个分类，Component表示某一些具备特性的集合，同时也是组成Module的组件，DataSource和Layout是功能类，分别用来管理数据源和计算布局。四者之间的关系为：Component通过DataSource被Module管理，Layout通过Component为DataSource提供布局的计算操作。

Module是对一个具体业务的抽象，可以看做是对UIViewController的解耦，通过将相同的逻辑进行整合：refresh、loadMore、request、emptyView。Module的子类只需要实现以下方法，提供一个网络请求类，然后在请求成功的方法中解析数据，添加具体的Component即可：

``` objective-c

- (__kindof YTKRequest *) fetchModuleRequest;
- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request;
```

DataSource不仅担任着为Module管理Component的任务，其还实现了UICollectionViewDataSource和UICollectionViewDelegate协议，使用管理的Component为UICollectionView提供数据源，使用每一个Component的Layout为UICollectionView提供UI布局，内部参考IGListKit，使用`NSMutableSet`来保存注册的Cell和SupplementaryView，这样在Component就可以直接使用其dataSource的一系列dequeueReusable...方法获取对应的cell或者supplementaryView：

``` objective-c

- (__kindof UICollectionViewCell *) collectionView:(__kindof UICollectionView *)collectionView dequeueReusableCell:(NSMutableSet *)registeredCellIdentifiers withReuseIdentifier:(NSString *)reuseIdentifier cellClass:(Class)cellClass atIndexPath:(NSIndexPath *)indexPath{
    
    if (![registeredCellIdentifiers containsObject:reuseIdentifier]) {
        [registeredCellIdentifiers addObject:reuseIdentifier];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}
```

Component只要DataSource为其提供注册好的可复用的Cell和SupplementaryView，因此两者的联系是通过`QLLiveModuleDataSourceAble`协议弱化了具体类，Component的子类只需要重写`-cellForItemAtIndex:`方法就可以选择使用何种cell，以及将具体索引下的数据交给cell来更新界面：

``` objective-c

// in some subclass of Component .m
- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    YYYOneCCell * ccell = [self.dataSource dequeueReusableCellOfClass:YYYOneCCell.class forComponent:self atIndex:index];
    [ccell setupWithData:[self dataAtIndex:index]];
    return ccell;
}
```

通过Module传递给DataSource，DataSource传递给Component，三者共用UICollectionView和UIViewController，因此在Component中可以使用UIViewController来做一些业务，这一点是和IGListKit一致的。

Layout中根据`insets`、`lineSpacing`、`interitemSpacing`、`distribution`、`itemRatio`会计算出来具体的itemSize，并且根据index进行缓存，每一个Component可以设置自己的Layout，这些设置会在DataSource中作为UICollectionView的数据源和代理进行布局使用。其中distribution和itemRatio分别表示一屏横向上可以显示的个数以及cell的宽高比，同时为具备灵活性，还提供了`QLLiveComponentLayoutDelegate`来让Component进行自定义itemSize。

todo 图片

### OrthogonalScroll

常规的垂直方向展示功能已经不能满足多变的需求，像App Store中那种既可以纵向滑动又可以横向滑动的效果越来越受欢迎。在开发实现中更多使用的是在需要横向滑动的cell中添加一个UICollectionView子视图，然后由这个cell来实现具体的数据源和代理，略显麻烦。

在iOS12之后，系统提供了一个关于UICollectionView的layout：`UICollectionViewCompositionalLayout`，这个layout可以设置丰富多样的布局样式，但是由于系统的限制，iOS12以下的系统不能使用，这在实际业务开发中就决定了这个功能组件暂时不会被大面积使用。不过，好在社区中有根据系统的API自己实现了一套iOS12以下也可以用的`IBPCollectionViewCompositionalLayout`，由于这个Layout功能太多，并没有直接拿来用，这里只是参考了其中的一些实现逻辑，借鉴的就是实现OrthogonalScroll效果的部分。

这里使用了一个巧方法做了`嵌套CollectionView`和`原始CollectionView`之间的数据源和代理的转换，使得在一个横向滑动的Component中配置cell和在纵向的Component中配置cell看起来是一样的。对Component的`arrange`属性设置为`QLLiveComponentArrangeHorizontal`之后，就表示该Component是可以横向滑动的，DataSource会为该Component所在的索引处自动注册一个私有的UICollectionViewCell子类：`QLOrthogonalScrollerEmbeddedCCell`，并且这个cell中有一个已经添加的私有UICollectionView子类：`QLOrthogonalScrollerEmbeddedScrollView`为其子视图，对该Component注册的cell其实是给QLOrthogonalScrollerEmbeddedScrollView注册的，使用`QLOrthogonalScrollerSectionController`来为私有CollectionView实现数据源和代理方法，将对应的方法交给SectionController的`collectionView`属性的数据源和代理。

``` objective-c
@interface QLOrthogonalScrollerSectionController: NSObject

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic) QLOrthogonalScrollerEmbeddedScrollView *scrollView;
@property (nonatomic) NSInteger sectionIndex;

- (instancetype)initWithSectionIndex:(NSInteger)sectionIndex
                      collectionView:(UICollectionView *)collectionView
                          scrollView:(QLOrthogonalScrollerEmbeddedScrollView *)scrollView;

- (__kindof UICollectionViewCell *) dequeueReusableCell:(Class)cellClass
                                    withReuseIdentifier:(NSString *)reuseIdentifier
                                            atIndexPath:(NSIndexPath *)indexPath;
@end

```

### usage

使用上可以参考`XXXHomeModuleViewController.m`文件中的代码，使用QLLiveModule的子类表示当前业务场景，使用QLLiveComponent的子类实现具体模块，然后将component添加到module中即可
：

``` objective-c

// in YYYHomeModule.m
- (void) setupComponents{
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.arrange = QLLiveComponentArrangeHorizontal;
        comp.layout.itemRatio = [QLLiveComponentItemRatio fixedValue:40];
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:6];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            [cell setupWithData:data];
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#CB2EFF"];
        }];
        [comp addDatas:@[@"#swift#",@"#java#",@"#js#",@"#vue#",@"#ruby#",@"#css#",@"#go#"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYOneComponent * comp = [YYYOneComponent new];
        comp.layout.insets = UIEdgeInsetsMake(0, 5, 5, 5);
        comp.layout.distribution = [QLLiveComponentDistribution distributionValue:4];
        [comp setBSetupCell:^(YYYOneCCell *cell, id data) {
            [cell setupWithData:data];
            // 由于复用，所以这段代码下载setupWithData下面
            cell.oneLabel.textColor = [UIColor colorWithHexString:@"#B2E7F9"];
        }];
        [comp addDatas:@[@"晴天",@"阴天",@"雨天",@"大风",@"雷电",@"冰雹",@"大雪",@"小雪"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        // 这个component是用来做标签效果的，
        // 如果要定制居左需要在初始化UICollectionView的时候设置对应的layout
        // 将上面的 [[UICollectionViewFlowLayout alloc] init] 进行替换
        YYYTwoComponent * comp = [YYYTwoComponent new];
        [comp addDatas:@[@"NSObject",@"UIView",@"UIImageView",@"UILabel",@"CALayer",@"NSRunloop"]];
        comp;
    })];
    
    [self.dataSource addComponent:({
        YYYThreeComponent * comp = [[YYYThreeComponent alloc] initWithTitle:@"Word"];
        [comp addDatas:@[@"a",@"b",@"c",@"d",@"e"]];
        comp;
    })];
}
```

### 最后

这个解耦完成之后，发现很多模块都可以使用它来完成，当然更多的是手里有锤子，看谁都是钉子的想法在作怪。然后就将本来叫做QLHomeModule、QLHomeDataSource、QLHomeComponent、QLHomeComponentLayout中的Home替换为了Live，并且抽离出来和首页无关的逻辑，虽然只是一个单词的替换，但更多的是表示这个组件可以使用在更多具有类似功能、样式的地方。

目前支持的功能比较有限，像是那种栅栏布局就不好实现，需要进行自定义UICollectionViewLayout，比如结合IBPCollectionViewCompositionalLayout或者系统的UICollectionViewCompositionalLayout来做一个拓展。另外在网络请求中去组装Component的操作，可以替换为使用后端下发的数据来完成，这个就需要结合具体的业务了，可以作为一个拓展方向。
