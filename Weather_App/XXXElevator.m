//
//  XXXElevator.m
//  Weather_App
//
//  Created by skynet on 2019/12/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXElevator.h"

#pragma mark - state

@class XXXElevatorContext;
// 抽象状态类
@interface XXXElevatorState : NSObject<XXXElevatorBehavior>{
    __strong XXXElevatorContext *_context;
}

- (void) setupContext:(XXXElevatorContext *)context;

@end

@interface XXXElevatorOpeningState : XXXElevatorState

@end


@interface XXXElevatorClosingState : XXXElevatorState

@end


@interface XXXElevatorRuningState : XXXElevatorState

@end


@interface XXXElevatorStopingState : XXXElevatorState

@end

#pragma mark - context

@interface XXXElevatorContext : NSObject<XXXElevatorBehavior>{
    XXXElevatorState *_currentState;
}

@property (readonly, strong, nonatomic) XXXElevatorOpeningState * openingState;
@property (readonly, strong, nonatomic) XXXElevatorClosingState * closingState;
@property (readonly, strong, nonatomic) XXXElevatorRuningState * runingState;
@property (readonly, strong, nonatomic) XXXElevatorStopingState * stopingState;

- (void) updateState:(XXXElevatorState *)state;
- (XXXElevatorState *) state;

- (void) changeStateToOpening;
- (void) changeStateToClosing;
- (void) changeStateToRuning;
- (void) changeStateToStoping;
@end

#pragma mark - Client

@interface XXXElevator ()
@property (nonatomic ,strong) XXXElevatorContext * context;
@end

@implementation XXXElevator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.context = [XXXElevatorContext new];
    }
    return self;
}

// 操作
- (void) open{
    [self.context open];
}
- (void) close{
    [self.context close];
}
- (void) run{
    [self.context run];
}
- (void) stop{
    [self.context stop];
}

@end

@implementation XXXElevatorContext

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _closingState = [XXXElevatorClosingState new];
        _openingState = [XXXElevatorOpeningState new];
        _runingState = [XXXElevatorRuningState new];
        _stopingState = [XXXElevatorStopingState new];
        
        // 电梯的初始状态是关闭的
        [self updateState:self.closingState];
    }
    return self;
}

- (void) updateState:(XXXElevatorState *)state{
    _currentState = state;
    [_currentState setupContext:self];
}

- (XXXElevatorState *) state{
    return _currentState;
}

// 操作
- (void) open{
    [_currentState open];
}
- (void) close{
    [_currentState close];
}
- (void) run{
    [_currentState run];
}
- (void) stop{
    [_currentState stop];
}

// 状态
- (void) changeStateToOpening{
    [self updateState:self.openingState];
    [self.state open];
}
- (void) changeStateToClosing{
    [self updateState:self.closingState];
    [self.state close];
}
- (void) changeStateToRuning{
    [self updateState:self.runingState];
    [self.state run];
}
- (void) changeStateToStoping{
    [self updateState:self.stopingState];
    [self.state stop];
}
@end

@implementation XXXElevatorState

- (void)setupContext:(XXXElevatorContext *)context{
    _context = context;
}
- (void)open{
    
}
- (void)close{
    
}
- (void)run{
    
}
- (void)stop{
    
}
@end

// 开启状态是怎么来的，在这个状态下又可以做什么
// 是由open这个操作产生的，它可以做的只有关闭
@implementation XXXElevatorOpeningState

- (void)close{
    [_context changeStateToClosing];
}
- (void)open{
    // 这里有具体的业务处理，暂时使用log表示
    NSLog(@"[Elevator] 电梯门打开");
}
- (void)run{
    // 开着的状态是不可以run的，空方法
    NSLog(@"[Elevator] 电梯处于停止状态，不可以在关闭了");
}
- (void) stop{
    // 开着的状态是不可以stop的，空方法
    NSLog(@"[Elevator] 电梯处于打开状态，不可以停止");
}
@end

// 关闭状态是怎么来的，在这个状态下又可以做什么
// 在关闭状态下可以open，可以run，还可以stop
@implementation XXXElevatorClosingState

- (void) open{
    [_context changeStateToOpening];
}

- (void) close{
    NSLog(@"[Elevator] 电梯门关闭");
}

- (void) run{
    [_context changeStateToRuning];
}

- (void) stop{
    [_context changeStateToStoping];
}

@end

// 关闭状态是怎么来的，在这个状态下又可以做什么
@implementation XXXElevatorRuningState

- (void) open{
    // 在运行的电梯是不可以打开的
    NSLog(@"[Elevator] 电梯处于运行状态，不可以开门");
}

- (void) close{
    //运行的电梯也是不可以关闭的
    NSLog(@"[Elevator] 电梯处于运行状态，不可以关闭");
}

- (void) run{
    NSLog(@"[Elevator] 电梯运行");
}

- (void) stop{
    [_context changeStateToStoping];
}

@end


@implementation XXXElevatorStopingState

- (void) open{
    [_context changeStateToOpening];
}

- (void) close{
    // 在停止的电梯本身已经处于了关闭，抛出异常
    NSLog(@"[Elevator] 电梯处于停止状态，不可以在关闭了");
}

- (void) run{
    [_context changeStateToRuning];
}

- (void) stop{
    NSLog(@"[Elevator] 电梯停止");
}

@end
