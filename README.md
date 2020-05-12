> 这个仓库主要记录工作、学习中遇到的问题以及一些解决方案，比较杂，好在有些已经能够系统性的输出成为共用组件，并且也有对一些方案做下记录。随着越来越多的记录导致这个README变得很臃肿，所以就将其进行了拆分，将专门的解决方案作为单独的文章，虽然从版面上看东西没有那么多了，但是整体上清爽了许多，也方便以后将更多的方案进行落地。


* [跑道试图](https://github.com/Yrocky/Weather_App/blob/master/articles/RunwayView.md)

通过使用两个队列来维护直播间的跑道数量，减少不必要的内存消耗。

* [异步加载图片](https://github.com/Yrocky/Weather_App/blob/master/articles/AsyncLoadImage.md)

在做优化的时候发现，同样的本地图片，不同的加载方式会导致耗时不同，因此对本地图片做了一次异步加载的尝试。

* [属性字符串](https://github.com/Yrocky/Weather_App/blob/master/articles/AttributesStringBuilder.md)

普通的创建属性字符串有些模板化，并且拼接属性字符串也不是很优雅，使用`Builder模式`提供一种便捷的创建属性字符串的方式，除了添加一些便捷操作的api之外，设置字体、颜色之类的还是使用的系统api。

* [无限滑动直播间](https://github.com/Yrocky/Weather_App/blob/master/articles/InfiniteScroll.md)

在直播软件中，这算是一个基础功能，因此也可以作为一个可共用的组件被使用。探讨了几种实现直播间无限滑动的方案，并且最后使用`双向循环链`实现一个数据操作简单的无限滑动直播间组件。

* [WebView](https://github.com/Yrocky/Weather_App/blob/master/articles/AboutWebView.md)

在着手升级了3个项目中的webView组件之后，总结出来了一些业务中常用的功能，然后对`WKWebView`进行分装，将业务中常用的功能集成到自定义的组件中，并且提供`插件机制`来完成和js对接的业务，以及提供`异步`、`同步`两种消息传递机制。

* [基于Responder Chain的事件传递](https://github.com/Yrocky/Weather_App/blob/master/articles/ResponderChain.md)

基于`Responder Chain`来解决开发中多UI层级交互所带来的麻烦，介绍了项目中所使用的方案，然后参考[casatwy](https://casatwy.com/responder_chain_communication.html)的方案完善一些细节。

* [一个解耦首页方案](https://github.com/Yrocky/Weather_App/blob/master/articles/HomeModule.md)

像是首页有多种分类要展示，每一个分类中有有多种样式，并且分类之间可能有共用样式，这样的界面展示方式现在很普遍，新闻资讯中的首页、视频客户端中的首页以及直播软件中首页差不多都是这样的类型。根据在项目中总结的module-component方案，整理出来该解耦方案。


