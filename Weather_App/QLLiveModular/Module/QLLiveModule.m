//
//  QLLiveModule.m
//  BanBanLive
//
//  Created by rocky on 2020/7/9.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "QLLiveModule.h"
#import <YTKNetwork/YTKNetwork.h>

@implementation QLLiveModule

- (instancetype)init{
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString *)name{
    return [self initWithName:name viewController:nil];
}

- (instancetype)initWithName:(NSString *)name
              viewController:(nullable UIViewController *)viewController{
    self = [super init];
    if (self) {
        _name = name;
        
        _index = 1;
        _pageSize = 20;
        _isRefresh = YES;
        
        _shouldLoadMore = YES;
        
        _dataSource = [QLLiveModuleDataSource new];
        
        self.viewController = viewController;
    }
    return self;
}

- (void) refresh{
    
    self.dataSource.viewController = self.viewController;
    _isRefresh = YES;
    [self resetIndex];
    [self fetchModuleDataFromService];
}

- (void) loadMore{
    if (self.shouldLoadMore) {
        _isRefresh = NO;
        [self fetchModuleDataFromService];
    }
}

- (void)setViewController:(UIViewController *)viewController{
    self.dataSource.viewController = viewController;
}

- (UIViewController *)viewController{
    return self.dataSource.viewController;
}

- (void)setCollectionView:(UICollectionView *)collectionView{
    self.dataSource.collectionView = collectionView;
}

- (UICollectionView *)collectionView{
    return self.dataSource.collectionView;
}

- (BOOL)empty{
    return [self.dataSource empty];
}

#pragma mark - private

- (void)fetchModuleDataFromService{
    
    YTKRequest * request = [self fetchModuleRequest];
//    request.successOnMainQueue = NO;
    [request startWithCompletionBlockWithSuccess:^(YTKRequest * _Nonnull request) {
        if (_isRefresh) {
            [self.dataSource clear];
        }
        [self parseModuleDataWithRequest:request];
        [self increaseIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self wrapperSuccessUpdateForDelegate];
        });
    } failure:^(YTKRequest * _Nonnull request) {
        [self wrapperFailUpdateForDelegate:request.error];
    }];
}

- (void) resetIndex{
    _index = 1;
}

- (void) increaseIndex{
    _index ++;
}

#pragma mark - private M

- (void) wrapperSuccessUpdateForDelegate{
    if ([self.delegate respondsToSelector:@selector(liveModuleDidSuccessUpdateComponent:)]) {
        [self.delegate liveModuleDidSuccessUpdateComponent:self];
    }
}

- (void) wrapperFailUpdateForDelegate:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(liveModule:didFailUpdateComponent:)]) {
        [self.delegate liveModule:self didFailUpdateComponent:error];
    }
}

@end

@implementation QLLiveModule (SubclassingOverride)

- (__kindof YTKRequest *)fetchModuleRequest{
    return nil;
}

- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request{

}

- (UIView *) blankPageView{
    return nil;
}

@end

@implementation QLLiveCompositeModule

- (instancetype)initWithName:(NSString *)name viewController:(nullable UIViewController *)viewController{
    
    self = [super initWithName:name viewController:viewController];
    if (self) {
        _innerModules = [NSMutableArray array];
    }
    return self;
}

- (void)addModule:(__kindof QLLiveModule *)module{
    [_innerModules addObject:module];
}

- (NSArray<__kindof QLLiveModule *> *)modules{
    return [NSArray arrayWithArray:_innerModules];
}

@end
