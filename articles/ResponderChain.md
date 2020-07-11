
## Responder Chain

在直播间中对视图进行解耦的时候，遇到的一个问题。

因为是将具体业务视图放到对应的contentView中，并且这些业务视图的事件接收方还是当前视图控制器，就会造成事件的传递需要透过contentView这一层。

如果中间只有contentView这一层还好，可以使用一个多余的delegate或者block将事件转换一下，但如果业务视图自己中也有其他的子控件需要传递事件到视图控制器，那就不止一层了。在软件开发中，只有变和不变，在这里就是如果他有一层，那么就可能有n多层，为了一层提出的方案在n多层中就会显得不那么适用，因为这样并没有解决根本问题。

<p align="center">
  <img src="https://github.com/Yrocky/Weather_App/blob/master/img/responder_chain_contentviews.png?raw=true"  align="center">
</p>

当然使用通知可以无视事件触发层和处理层之间的距离，但是，通知在我看来不是一个很好的UI通信方式，并且满天飞的通知很难管理。

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

这个方案是从[casatwy](https://casatwy.com/responder_chain_communication.html)那里看到的，基于响应链来实现，具体介绍可以参考作者的文章。主要思路是为UIResponder添加一个分类方法，将要传递的数据交给其nextResponder，直到多层传递之后的控制器，控制器可以重写该分类方法来实现具体的业务逻辑。

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

使用了这样的方法可以极大的减少多层级视图带来的通信成本，减少代理的层层传递，避免通知满天飞等等。除了上面提到的事件名是字符串不好维护之外，还有一个问题是，它不能解决反向数据代理，比如深层的UI需要控制器通过代理（确切点叫数据源）来返回数据。不过好在比较深层级的事件传递大多是点击响应，数据都是从上（子视图）到下（控制器）的，这点儿弊端相较于该模式提供的便利是可以忽略的。


