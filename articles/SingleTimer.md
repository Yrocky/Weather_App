##  SingleTimer

在业务中难免会遇到多处使用定时器的需求，创建多个定时器并不现实，本案提供一种多个业务共用一个定时器的方案。

### TimerObserver

每一个需要定时器的业务抽象成`TimerObserver`，他只需要提供一个唯一id，以及定时器的回调即可，没有多余的事件回调。在`-onTimer`中，业务方只需要更新自身提供的计数变量（counter）即可，方法简单就会更方便对接现有业务。

``` Objective-C

@protocol TimerObserver <NSObject>

- (NSString *) uniqueId;

@optional
- (void) onTimer;
@end
```

### SingleTimer

`SingleTimer`是对定时器的抽象，通过`-addTimerObserver:`添加需要定时器的业务方观察者，在内部只有不少于一个观察者的情况下才会开启定时器，如果通过`-removeTimerObserver:`移除观察者之后，观察者数量为0则会自动停止定时器。

``` Objective-C
@interface SingleTimer : NSObject

- (instancetype) initWithInterval:(NSTimeInterval)intervalValue;

- (void) addTimerObserver:(id<TimerObserver>)observer;
- (void) removeTimerObserver:(id<TimerObserver>)observer;
@end

```

业务方可能是模型，也可能是视图，如果它需要定时器，只需要遵守`TimerObserver`即可。使用起来大概如下：

``` Objective-C
// in some ViewContrller.m

- (void) onAdd{
    [self.timer addTimerObserver:self];
}

#pragma mark - TimerObserver

- (NSString *)uniqueId{
    return @"Home-ViewController";
}

- (void)onTimer{
    self.counter ++;
    self.displayLabel.text = [NSString stringWithFormat:@"%ld",(long)self.counter];
}
```
SingleTimer内部由定时器`_SingleInnerTimer`来执行定时打点任务，本质上是对NSTimer的封装，增加了`pause`和`restart`功能。`_TimerCollection`负责对观察者的存储，它并不是直接存储`id<TimerObserver>`，而是存储`_TimerObserver`这个私有类的实例。并且通过为NSObject提供一个`disposeBag`来存储一个token（`_TimerToken`），在`id<TimerObserver>`销毁的时候（调用dealloc）执行token的`onDispose`回调，在内部移除`_TimerCollection`存储的观察者。

```Objective-C

// in SingleTimer.m

- (void) addTimerObserver:(id<TimerObserver>)observer{
    
    __weak typeof(self) weakSelf = self;

    __block _TimerObserver * innerObserver = [_TimerObserver new];
    innerObserver.object = observer;
    
    _TimerToken * token = [[_TimerToken alloc] initWithKey:key];
    token.onDispose = ^(NSString *uniqueId) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf removeObserverForKey:uniqueId];
    };
    [innerObserver.object.disposeBag addToken:token];
    [_collection addObserver:innerObserver forKey:key];
}

```

