
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



## 形状礼物效果的实现



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

