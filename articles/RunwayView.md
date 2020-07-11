## 跑道视图

直播间跑道的一个使用情况是会有大量的数据被放入到跑道池中，但是手机屏幕上展示的仅仅是2-3条，同一个时刻有可能会有n多个只能是视图在屏幕外面，但是这时候他们已经被创建好了，这就严重的影响了直播间的流畅度，CPU消耗严重，手机发热，如果数量过多的话，迟早会造成内存不足，引起崩溃。

先说一下跑道视图的具体实现思路：

> 每当直播间socket收到跑道的推送，就创建一个展示视图，然后放入跑道中进行展示。使用多线程中的queue和operation的思想，将跑道形容成：每一个具体展示的视图为operation，他们之间通过一个queue来控制，每一个operation内部通过CADisplayLink来记录视图的位移，展示完成之后通知queue进行视图的管理。由于每一个operation中会创建一个CADisplayLink并加入到runloop中，这也是导致卡顿的一点。

现在看来，有两个问题：视图的创建没有限制，视图的添加也没有限制。如果要优化功能组件，可以通过增加一个阀值、一个缓存来实现减少CPU消耗的目的。阀值用来控制最大数量创建视图，缓存用来对已经接收到的跑道数据进行记录，缓存更像是一个队列。最好的情况是在异步对视图进行创建与数据渲染，但是这显然是不可能的，因为UIKit的控件不是线程安全的，不允许在非主线程中创建、修改、添加。

目前展示的跑道内容视图是在接收到socket的时候根据数据创建的，内容视图中有许多的子控件也需要跟随这创建，并且这些内容中会有动图出现，也不好使用异步绘制图片的方式进行优化。具体的从socket到展示的流程如下：

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/optimize_render_runway.png?raw=true"  align="center">

</p>

由于我们的目的是要按照需要（在阀值内的消耗完了再创建等待的部分）创建，因此需要创建和展示这两部分可以进行通信：创建的根据展示的进程来决定是否要根据socket中的数据创建视图。这样需要使用单例来协调两者，另外，在创建singleLineView的时候是根据socket中的数组数据创建对应个数的控件（UILabel或者UIImageView），这样对于跑道这种数量会很大的视图来说，又增加了一些CPU的消耗。

这里使用一个跑道管理单例，内部维护两个队列：一个作为要创建视图，记为queue；一个用来存储socket推送的json数据，记为cache。queue设置最大容量，在达到最大容量以后再接收的json数据就放入cache中，等一条跑道视图展示完成之后，将queue中最前面的数据移除，从cache中获取最前面的数据，加入到queue末尾。这样可以保证创建的跑道视图最多不会超过阀值，从而减轻了一些CPU消耗。

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/optimize_runway_manager.png?raw=true"  align="center">

</p>

