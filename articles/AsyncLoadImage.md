
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

