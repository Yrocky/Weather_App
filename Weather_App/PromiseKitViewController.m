//
//  PromiseKitViewController.m
//  Weather_App
//
//  Created by meme-rocky on 2019/1/21.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "PromiseKitViewController.h"
#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/PMKUIKit.h>
#import <PromiseKit/PMKFoundation.h>
#import "Masonry.h"
#import "XXXGushiciRequest.h"
#import <Bolts/Bolts.h>

@interface PromiseKitViewController ()

@end

@implementation PromiseKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __block UIImageView * imageView = UIImageView.new;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self getgusici];

//    [[XXXGushiciRequest new] startWithCompletionBlockWithSuccess:^(XXXGushiciRequest * request) {
//        NSLog(@"origin gushici:%@",request.gushici);
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"origin error:%@",request.error);
//    }];
    
    return;
    NSURLRequest * r = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://img-blog.csdn.net/20170809135909929?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvSGVsbG9fSHdj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast"]];
    [[NSURLSession sharedSession] promiseDataTaskWithRequest:r].then(^(id response){
        // response is probably an NSDictionary deserialized from JSON
        NSLog(@"respone:%@",response);
        NSLog(@"number-100");
        imageView.image = response;
        return @(100);
    }).then(^(NSNumber * number){
        NSLog(@"number-10:%@",number);
        if (number.intValue == 100) {
            NSError * err = [NSError errorWithDomain:@"weather_app" code:1000 userInfo:nil];
            return [AnyPromise promiseWithValue:err];
        }
        return [AnyPromise promiseWithValue:@(10)];;
    }).then(^(NSNumber * number){
        NSLog(@"number-1:%@",number);
        return @(1);
    }).catch(^(NSError *error){
        NSLog(@"error:%@",error);
    });
    
    [self getgusici];
}


- (void) getgusici{
    
    ///由于`XXXGushiciRequest`重写了`mapModelWithJsonData:`方法，
    ///返回了`XXXGushiciWrap`类型的数据，因此这里的then可以直接使用
    [[XXXGushiciRequest new] startPromise].then(^(XXXGushiciWrap * wrap){
        NSLog(@"[Promise]gushici:%@ contents:%@",wrap,wrap.contents);
    }).catch(^(NSError * error){
        NSLog(@"[Promise]error:%@",error);
    });
    
    ///使用YTK提供的处理数据的方法`requestCompletePreprocessor`，将json转成模型，在这里进行使用
    
    [[XXXGushiciRequest new]
     startWithCompletionBlockWithSuccess:^(XXXGushiciRequest * request) {
        NSLog(@"[Origin] gushici:%@",request.gushici);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"[Origin] error:%@",request.error);
    }];
    
    [[self asyncFetchGushiciList] continueWithBlock:^id _Nullable(BFTask<XXXGushiciWrap *> * _Nonnull t) {
        if (t.isCancelled) {
            NSLog(@"[BFTask] is cancelled");
        } else if (t.error) {
            NSLog(@"[BFTask] error:%@",t.error);
        } else if (t.result) {
            NSLog(@"[BFTask] result:%@",t.result);
        }
        return nil;
    }];
}

- (BFTask<XXXGushiciWrap *> *) asyncFetchGushiciList{
    
    BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
    
    [[XXXGushiciRequest new]
     startWithCompletionBlockWithSuccess:^(XXXGushiciRequest * request) {
        [tcs setResult:request.gushici];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [tcs setError:request.error];
    }];
    return tcs.task;
}

- (BFTask<XXXGushiciWrap *> *) asyncFetchGushiciList2{
    
    __block BFTask * task;
    // 不可以这么使用，因为task需要在异步进行初始化，所以返回的为nil
    [[XXXGushiciRequest new] startWithCompletionBlockWithSuccess:^(XXXGushiciRequest * request) {
        task = [BFTask taskWithResult:request.gushici];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        task = [BFTask taskWithError:request.error];
    }];
    NSLog(@"asyncFetchGushiciList2:%@",task);
    return task;
}


@end
