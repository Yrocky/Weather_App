
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



## 异步加载图片

我们知道，从本地读取图片的时候经常会使用的一个方法是`imageNamed:`，这个方法比较适用于需要重复加载的小图片，因为系统会自动对这个方法缓存加载的图片，效率上会很好。对于我们直播间内部要显示的图片，基本上是不需要重复加载的，也不需要进行缓存，因此这个方法在这里使用可以算是性能上不是很好，作为替换方法可以使用`imageWithContentsOfFile:`来加载图片，它仅加载图片，而不会对图片进行缓存。

然后从图片的加载上分析一下，一般图片从磁盘加载到屏幕上的大体流程为：

1. 使用上面的两个方法从磁盘中加载图片，这时候图片还没有解压缩
2. 将UIImage对象赋值给UIImageView等控件
3. 这个时候一个隐式的CATransaction会捕获到控件的图层树的变化
4. 在主线程下一个run loop到来时，Core Animation提交这个隐式的transaction，在提交的时候可能会涉及到copy操作，copy数据会涉及到一些步骤：
   1. 分配内存缓冲区用于I/O和解压缩操作
   2. `将文件数据从磁盘读取到内存中`
   3. `将压缩的图片数据解码成未压缩的位图(bitmap)形式`，注意，这里是很耗CPU的操作
   4. 最后Core Animation使用未压缩的位图数据渲染控件的图层，显示对应的图片内容

从流程中可以看出来，在使用 UIImage 或 CGImageSource 创建图片时，图片数据并不会立刻解码。图片设置到 UIImageView 或者 CALayer.contents 中去，并且 CALayer 被提交到 GPU 前，CGImage 中的数据才会得到解码。`这一步是发生在主线程的，并且不可避免`。如果想要绕开这个机制，常见的做法是在后台线程先把图片数据绘制到 CGBitmapContext 中，然后从 Bitmap 直接创建图片。

对于这种方式，我做了一个比较，对四个UIImageView分别进行设置图片，每个使用不同的方式：异步绘制图片然后设置image属性、异步绘制图片设置layer.contents、使用imageNamed、使用imageWithContentsOfFile，比较结果如下：

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/optimize_load_image.png?raw=true"  align="center">

</p>

可以看出来，将图片放入异步线程中去绘制，仅仅是在最后主线程中使用图片时有CPU的消耗，并且这个消耗比使用imageWithContentsOfFile设置图片还小，最主要的是这样的做法将CPU的消耗放到了异步线程，不会对主线程有影响。

分类中还为UIButton、UIImageView这些可以设置不同状态下图片的控件添加了一些便利方法，同样是使用异步绘制，主线程设置的方式，通过比较比直接使用imageNamed、imageWithContentsOfFile好很多。由于内部是使用的UIView的异步绘制方法，数据分析就不上了。内部有两种实现方式：一种是使用绘制图片到context中，然后生成对应的图片；另一种是结合SDWebImage与YYKit中的解压缩图片，对图片进行重新编码生成bitmap对象，然后生成图片。目前项目中使用的是第二种。



## 简化属性字符串

在使用属性字符串的时候，不需要写大段的样板代码，简化使用方法


### 1.普通

根据需要一个一个的添加需要的字符串以及对应的属性

```objective-c
// black 16
+ (instancetype) builder;
// { NS...AttributeName : (id)value}
+ (instancetype) builderWithDefaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) appendString:(NSString *)string;
- (HLLAttributedBuilder *(^)(NSString *str)) appendString;

- (HLLAttributedBuilder *) appendString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) appendStringAndStyle;
```

例子：

```objective-c
attString = [[[[[HLLAttributedBuilder builder]
                    appendString:@"nihao"]
                   appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                    NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                    NSUnderlineStyleAttributeName:@1}]
                  appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                    NSStrokeWidthAttributeName:@1}]
                 attributedString];
```
<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/normal.png?raw=true"  align="center">
</p>


### 2.支持 NSTextAttachment

属性字符串中除了常规的字符串还可以添加图片，添加图片使用的是NSTextAttachment类，可以结合上面的普通字符串使用。

```
- (HLLAttributedBuilder *) appendAttachment:(NSTextAttachment *)attachment;
- (HLLAttributedBuilder *(^)(NSTextAttachment *))appendAttachment;
```

例子：

```objective-c
NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
attachment.image = [UIImage imageNamed:@"red_dot"];
attachment.bounds = CGRectMake(0, 0, 9, 9);

 attString = [[[[[[[HLLAttributedBuilder builder]
                      appendAttachment:attachment]
                     appendString:@"nihao"]
                    appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                     NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                     NSUnderlineStyleAttributeName:@1}]
                   appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                     NSStrokeWidthAttributeName:@1}]
                  appendAttachment:attachment]
                 attributedString];
```

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/attachment.png?raw=true"  align="center">
</p>


### 3.支持查找设置

一种情形是，已有一个字符串，需要对其中的某一些字符串进行属性字符串设置，支持精确匹配以及正则表达式匹配，并且可以结合上面的`-append..`方法一起使用。


```objective-c
+ (instancetype) builderWithString:(NSString *)originalString;
+ (instancetype) builderWithString:(NSString *)originalString defaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) configString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle;
```

例子：

```objective-c
NSString * display = @"hello = nihao = Hello = 你好 = nihao";
    attString = [[[[[[[HLLAttributedBuilder builderWithString:display]
                      configString:@"hello" forStyle:@{NSUnderlineColorAttributeName:[UIColor redColor],
                                                       NSUnderlineStyleAttributeName:@1,
                                                       NSForegroundColorAttributeName:[UIColor orangeColor]}]
                     configString:@"nihao" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                      NSStrokeWidthAttributeName:@1}]
                    configString:@"H" forStyle:@{NSBackgroundColorAttributeName:[UIColor greenColor]}]
                   appendAttachment:attachment]
                  appendString:@"娃大喜"]
                 attributedString];
```

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/config.png?raw=true"  align="center">
</p>


使用正则表达式进行属性字符串设置


``` objective-c
NSString * a = @"a[bc]d(you)A[BCD]1【大家好】2a[gs]34(me)";
NSAttributedString * attS = AttBuilderWith(a).
    configStringAndStyle(@"(?<=\\[)[^\\]]+",@{NSForegroundColorAttributeName:[UIColor orangeColor]}).
    attributedStr();
```

> 以上的正则中用了**零宽断言**的语法 http://www.ibloger.net/article/31.html

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/rx.png?raw=true"  align="center">
</p>

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

由于上面的实现方式有一个使用上的瑕疵，因此下面考虑了优化，甚至重新使用新的方式来实现滑动。由于当时觉得使用UIScrollView来实现需要计算各种位移，处理起来可控性会更高一些，另外无限滑动这种操作的原型可以想象成一个双向循环链表，这样，当前界面的前一个和后一个都可以通过双向循环链表这个数据结构来很方便的获取，而不需要像上一个版本的那样，去拼接一个**循环的数据**。

> 这个思路的灵感来自于[这个仓库](https://github.com/poos/SXCycleView)，结合上一个版本然后整理出来直播间无限滑动原型。

### MMCycleLinkedList

这个方案中，双向循环链表示其中的核心，它需要担当数据的处理部分的任务，并且要保证内存的合理释放。这个类是在`MMLinkedList`的基础上创建的，并且添加了一些和业务相关的接口：

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

另外，将无限滚动视图的功能使用`RoomDataSourceHandler`协议抽象了一下，这样方便在控制器中方便的进行切换两种方案。控制器部分基本上不需要大改动，只需要将循环试图替换一下就可以了。

## WebView

基于常用的webView业务逻辑封装成一个`MMWebView`，内部使用`WKWebView`实现，将使用`WKWebView`过程中遇到的[一些问题](https://mp.weixin.qq.com/s/rhYKLIbXOsUJC_n6dt9UfA?)进行集中处理，对外部暴露简单的接口逻辑，并且提供一个和js交互的逻辑层。

主要的功能有与js交互的接口、安全执行js脚本、cookie的处理、文件跨域、清理缓存等等，具体的代码内部已经注释的很详细，下面仅对遇到的问题做一个摘要。

### WKScriptMessageHandler 导致的内存泄漏

先看一下形成的原因：

```mermaid
graph LR;

A[MMWebView] -- strong --> B[WKWebView]
B -- copy --> C[WKWebViewConfiguration]
C -- strong -->D[WKUserContentController]
D -- strong -addScriptMessageHandler: name:--> A
A -. weak 使用userContentController属性 .-> D
```

本来是不知道系统的`-addScriptMessageHandler: name:`方法会将传入的hanlder进行持有，这才形成了上面的循环引用，观看`WKUserContentController`的源码会发现内部实现如下：

```c++
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name{
    auto handler = WebKit::WebScriptMessageHandler::create(std::make_unique<ScriptMessageHandlerDelegate>(self, scriptMessageHandler, name), name, API::UserContentWorld::normalWorld());
    if (!_userContentControllerProxy->addUserScriptMessageHandler(handler.get()))
        [NSException raise:NSInvalidArgumentException format:@"Attempt to add script message handler with name '%@' when one already exists.", name];
}
```

这段代码中使用`WebScriptMessageHandler`调用`create方法`接受传入的参数，下面看一下这个类关于该函数的相关文件：

```c++
// in WebScriptMessageHandler.h
class WebScriptMessageHandler : public RefCounted<WebScriptMessageHandler>, public Identified<WebScriptMessageHandler>  {
public:
    static Ref<WebScriptMessageHandler> create(std::unique_ptr<Client>, const String& name, API::UserContentWorld&);
private:
    WebScriptMessageHandler(std::unique_ptr<Client>, const String&, API::UserContentWorld&);

    std::unique_ptr<Client> m_client;
    String m_name;
    Ref<API::UserContentWorld> m_world;
};

// in WebScriptMessageHandler.mm
Ref<WebScriptMessageHandler> WebScriptMessageHandler::create(std::unique_ptr<Client> client, const String& name, API::UserContentWorld& world)
{
    return adoptRef(*new WebScriptMessageHandler(WTFMove(client), name, world));
}
WebScriptMessageHandler::WebScriptMessageHandler(std::unique_ptr<Client> client, const String& name, API::UserContentWorld& world)
    : m_client(WTFMove(client))
    , m_name(name)
    , m_world(world)
{
}
```

在WebScriptMessageHandler的public声明了这个create函数，然后其实现中是通过new一个`WebScriptMessageHandler`对象，调用下面的构造函数

```c++
WebScriptMessageHandler::WebScriptMessageHandler(std::unique_ptr<Client> client, const String& name, API::UserContentWorld& world)
```

进行初始化，将参数赋值到对象的属性里。因此，可以断定，`WKUserContentController`确实在`-addScriptMessageHandler: name:`方法持有了入参，也就形成了上面的循环引用。

这里引入一个中间类`MMScriptMessageHandler`来打破循环引用：

```mermaid
graph TD;

A[MMWebView] -- strong --> B[WKWebView]
B -- copy --> C[WKWebViewConfiguration]
C -- strong -->D[WKUserContentController]
A -- strong -->E[BBanScriptMessageHandler]
D -- strong -addScriptMessageHandler: name:--> E
A -. weak 使用userContentController属性 .-> D
```

### plugin

借鉴[这篇文章中](https://lvwenhan.com/ios/462.html)的方法来实现一套插件机制，核心原理为

* 使用`WKUserContentController`的`-addScriptMessageHandler: name:`方法进行native注册，web中通过`window.webkit.messageHandlers.MMWebViewPlugin.postMessage(null)`使用js进行发消息，从而完成js和native的交互
* 使用`WKWebView`的`-evaluateJavaScript: completionHandler:`方法完成native和js的交互
* 通过`-userContentController: didReceiveScriptMessage:`回调函数创建插件，并执行相应的native调js方法

下面是在使用过程中遇到问题的一个场景，概述下为`web需要通过native获取一个值来进行下一步操作`，其实就是js要同步获取native的回调，具体过程如下：

```js
// in index.html
function js_share_qq2(){
    var a = 0;//js需要native来获取最新的a
    console.log('0,'+getNowFormatDate());
    function shareQQOnSuccess(successMsg){
        // 由于这个方法是执行webKit.postMessage方法的，因此会有一个不及时性，对于`知晓操作之后native反馈的结果`的需求来说没有问题，但如果是要`通过操作获取native的数据`这样的需求就不行了
        a = 10;
        console.log('10,'+getNowFormatDate())
        alert(successMsg.success)
    };
    function shareQQError(e){
        alert(e)
    };

    //Share.qq2('this is for QQ', shareQQOnSuccess, shareQQError); //输出顺序为 0-100-10
    Share.qq3('this is for QQ', shareQQOnSuccess, shareQQError);// 输出顺序 0-10-100
    console.log('100,'+getNowFormatDate())
    console.log(a);//js要在这里使用最新的a值
};

// in Share.js
Share = {
    // 有回调的方法，可以将分享的结果通知js
    qq2: function (msg, onSuccess, onError) {
        Queue.push(Task.init(Queue.length, onSuccess, onError));
        // 这里异步执行
        window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMSharePlugin', functionName: 'qq2', data: msg, taskId: Queue.length - 1});
    },
	  //为了和qq2方法做对比，区别是内部直接调用onSuccess函数
    qq3: function (msg, onSuccess, onError) {
        onSuccess(msg);
    }
}

// inMMSharePlugin.m
- (void) qq2{
    NSString * msg = [NSString stringWithFormat:@"Your share to qq <%@> is SUCCESS",self.data];
    [self callback:@{@"success":msg}];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(sharePlugin:didShareSuccess:)]) {
        [self.delegate sharePlugin:self didShareSuccess:@{@"success":msg}];
    }
}
```

从打印的顺序中会发现，如果使用webKit的postMessage方法，得到的并不是想要的结果，而使用直接js调用则是正确的结果。因此，这种插件的机制仅仅适用于两方交互，js传递给native消息这样的场景，而不适用于交互的时候native给js传递数据，如果要解决这样的问题，可以使用[味儿精的方案](https://juejin.im/post/5a537686f265da3e4674ec7a#heading-16)使用拦截弹窗。

通过重写`runJavaScriptTextInputPanelWithPrompt`代理方法在内部进行消息的传递和处理，在native对js传递过来的数据进行处理之后返回字符串给js，

```objective-c

// in js
function js_load_prompt(){
    var data = {
        action:'modif',
        params:'name=rocky',
    };
    var jsonData = JSON.stringify(data);
    //发起弹框
    let result = prompt(jsonData);
    console.log(result)
}

// in MMWebView.m
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
    if ([self JSPromptIsTargetSyncMessageWithPrompt:prompt]){
        completionHandler(({
            [self.messageHandler handleSyncMessageWithData:({
                [MMWebView use_yy_dictionaryWithJSON:prompt];
            })];
        }));
    }else{
        completionHandler(@"");
    }
}

// in MMScriptMessageHandler.m
- (NSString *) handleSyncMessageWithData:(NSDictionary *)data{

    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([self.delegate respondsToSelector:@selector(messageHandler:didReceiveSyncMessage:)]) {
            return [self.delegate messageHandler:self didReceiveSyncMessage:data];
        }
    }
    return @"";
}

// in XXXController.m
- (NSString *)messageHandler:(MMScriptMessageHandler *)msgHandler didReceiveSyncMessage:(NSDictionary *)message{
    NSString * name = message[@"action"];
    if ([name isEqualToString: @"modif"]) {
        return @"2222222";
    }
    if ([name isEqualToString:@"add"]) {
        return @"33333";
    }
    
    return @"";
}
```

这种方式需要web端和移动端需要约定好数据格式，比如js给`prompt`弹框传递的参数需要两端统一，这里只是使用action作为一个实例。

## Responder Chain

在直播间中对视图进行解耦的时候，遇到的一个问题。

因为是将具体业务视图放到对应的contentView中，并且这些业务视图的事件接收方还是当前视图控制器，就会造成事件的传递需要透过contentView这一层。

如果中间只有contentView这一层还好，可以使用一个多余的delegate或者block将事件转换一下，但如果业务视图自己中也有其他的子控件需要传递事件到视图控制器，那就不止一层了。在软件开发中，只有变和不变，在这里就是如果他有一层，那么就可能有n多层，为了一层提出的方案在n多层中就会显得不那么适用，因为这样并没有解决根本问题。

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/responder_chain_contentviews.png?raw=true"  align="center">
</p>

当然是用通知可以无视事件触发层和处理层之间的距离，但是，通知在我看来不是一个很好的UI通信方式，并且满天飞的通知很难管理。

### normal

先说一下以前都是怎么处理多层事件传递的，主要有两种方式。

第一种做法是为contentView添加一个代理，这个代理继承至其子视图们的代理，由于协议是可以多继承，因此可以这么写，但是这样就会暴露这个contentView内部的子视图，不符合封装的特性，没有很好的体现这个contentView的封装性。

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/responder_chain_normal_1.png?raw=true"  align="center">
</p>

这样的做法比较省心，不需要写很多的无用代理方法，缺点就是上面提到的暴露了内部的类。

另一种做法是在contentView内部对子视图做一个代理传递，自己统一代理协议的接口：

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/responder_chain_normal_2.png?raw=true"  align="center">
</p>

内部将子视图的代理回调方法传递给自己的代理：

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/responder_chain_normal_3.png?raw=true"  align="center">
</p>

这个做法的好处一个是代理接口统一，另外就是可以在子视图的代理回调里面做一些contentView的业务处理，灵活性更高一些。

缺点就是需要写好多代理方法以及传递子视图的代理给contentVIew的代理，并且如果嵌套层级过深写起来就会很不优雅。

那么有没有一个很优雅的方法来解决这个难题呢？

### Responder Chain

这个方案是从[casatwy](https://casatwy.com/responder_chain_communication.html)那里看到的，基于响应链来实现，具体介绍可以参考作者的文章，主要思路是为UIResponder添加一个分类方法，将要传递的数据交给其nextResponder，直到多层传递之后的控制器，控制器可以重写该分类方法来实现具体的业务逻辑。

由于在响应链中事件的传递是自上而下的，也就是先从点击的控件开始再到其所在的contentView，然后再到LivingRoomVC。

这里和代理不同的是使用字符串而不是回调方法做约束，这就需要事件方和业务方约定好方法名，需要额外的维护一个事件名表，作者使用策略模式抽象出来一个EventProxy来处理事件名以及逻辑。但是出于抽离业务逻辑，使用一个XXXEventProxy基类来将设定策略的通用方法进行封装，业务EventProxy只需要设定具体的策略即可：

```objective-c

@interface XXXLivingRoomEvnetProxy ()
@property (nonatomic ,weak) XXXLivingRoomViewController * controller;
@end
@implementation XXXLivingRoomEvnetProxy

-(instancetype)initWithController:(__kindof UIViewController *)controller{
    self = [super init];
    if (self) {
        self.controller = controller;
        _eventStrategy = [NSSet setWithArray:({
            @[NSValueFromEventAndMethod(@"sub-view-button-click",
                                        @selector(onSubViewButtonClick))];
        })];
    }
    return self;
}

- (void) onSubViewButtonClick{
    
}
```

这里没有使用字典来保存策略，而是使用了一个集合，查找效率上会有一些影响，但是这样方便了抽象成结构体来表示策略。另外作者对这个方案还只是一个雏形，很多边界条件没有考虑，比如为NSInvocation设置参数的非法校验等，修改之后的EventProxy基类中主要的方法如下：

``` objective-c
- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    
    __block NSDictionary * strongUserInfo = userInfo;
    [self.eventStrategy enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
        XXXEventWrap event = XXXEventWrapFromNSValue(obj);
        if ([event.name isEqualToString:eventName]) {
            NSInvocation *invocation = [self createInvocationWithSelector:event.method];
            if (invocation) {
                if (invocation.methodSignature.numberOfArguments > 2) {                
                    [invocation setArgument:&strongUserInfo atIndex:2];
                }
                [invocation invoke];
            }
            *stop = YES;
        }
    }];
}
```

具体的逻辑请参考`XXXLivingRoomViewController`类文件。

### 最后

使用了这样的方法可以极大的减少多层级视图带来的通信成本，减少代理的层层传递，避免通知满天飞等等。除了上面提到的事件名是字符串不好维护之外，还有一个问题是，它不能解决反向数据代理，比如深层的UI需要控制器通过代理（确切点叫数据源）来返回数据。不过好在比较深层级的事件传递大多是点击响应，数据都是从上（子视图）到下（控制器）的，这点儿弊端相较于改模式提供的便利是可以忽略的。


