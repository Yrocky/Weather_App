//
//  MMHomeModule.m
//  Weather_App
//
//  Created by skynet on 2020/5/12.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MMHomeModule.h"
#import "NSArray+Sugar.h"
#import <YTKNetwork/YTKNetwork.h>
#import "MMHomeModule+CollectionView.h"
#import <IGListKit/IGListKit.h>

@interface MMHomeModule ()<IGListAdapterDataSource>

@property (nonatomic ,strong) IGListAdapter * adapter;
@end

@implementation MMHomeModule

- (instancetype)init{
    return [self initWithName:@""];
}

- (instancetype) initWithName:(NSString *)name{
    return [self initWithName:name viewController:nil];
}

- (instancetype) initWithName:(NSString *)name viewController:(__kindof UIViewController *)viewController{
    self = [super init];
    if (self) {
        _name = name;
        
        _index = 1;
        _pageSize = 20;
        _isRefresh = YES;
        
        _shouldLoadMore = YES;
        
        _innerComponents = [NSMutableArray new];
        
        self.adapter = [[IGListAdapter alloc] initWithUpdater:IGListAdapterUpdater.new
                                               viewController:viewController];
        self.adapter.dataSource = self;
    }
    return self;
}

- (void) setupCollectionView:(UICollectionView *)collectionView{
    _collectionView = collectionView;
    self.adapter.collectionView = self.collectionView;
}

- (void) refresh{
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

- (void)clear{
    
    @synchronized (_innerComponents) {
        [_innerComponents mm_each:^(id<MMHomeComponentAble> component) {
            [component clear];
        }];
        [_innerComponents removeAllObjects];
    }
}

- (void) addComponent:(id<MMHomeComponentAble>)component{
    if (!component) {
        return;
    }
    if (!self.collectionView) {
        NSLog(@"请先设置当前module的collectionView");
        return;
    }
    @synchronized (_innerComponents) {
        [component prepareCollectionView:self.collectionView];
        [_innerComponents addObject:component];
    }
}

- (void) addComponents:(NSArray<id<MMHomeComponentAble>> *)components{
    [components enumerateObjectsUsingBlock:^(id<MMHomeComponentAble> component, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addComponent:component];
    }];
}

- (void) replaceComponent:(id<MMHomeComponentAble>)component atIndex:(NSInteger)index{
    
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            [_innerComponents replaceObjectAtIndex:index withObject:component];
        }
    }
}

- (id<MMHomeComponentAble>) componentAtIndex:(NSInteger)index{
    id<MMHomeComponentAble> compontent;
    @synchronized (_innerComponents) {
        if (index < _innerComponents.count) {
            compontent = _innerComponents[index];
        }
    }
    return compontent;
}

- (NSArray<id<MMHomeComponentAble>> *) components{
    
    NSArray * components;
    @synchronized (_innerComponents) {
        components = [_innerComponents mm_select:^BOOL(id<MMHomeComponentAble> component) {
            return YES;//!component.empty;
        }];
    }
    return components;
}

- (BOOL)empty{
    BOOL isEmpty = NO;
    @synchronized (_innerComponents) {
        isEmpty = [_innerComponents mm_filter:^BOOL(id<MMHomeComponentAble> comp) {
            return !comp.empty;
        }].count == 0;
    }
    return isEmpty;
}

#pragma mark - private

- (void)fetchModuleDataFromService{
    
    [[self fetchModuleRequest] startWithCompletionBlockWithSuccess:^(YTKRequest * _Nonnull request) {
        if (_isRefresh) {
            [self clear];
        }
        [self parseModuleDataWithRequest:request];
        [self increaseIndex];
        [self wrapperSuccessUpdateForDelegate];
    } failure:^(YTKRequest * _Nonnull request) {
        [self clear];
//        [self wrapperFailUpdateForDelegate:request.errorMessage];
    }];
}

- (void) resetIndex{
    _index = 1;
}

- (void) increaseIndex{
    _index ++;
}

- (void) wrapperSuccessUpdateForDelegate{
    if ([self.delegate respondsToSelector:@selector(homeModuleDidSuccessUpdateComponent:)]) {
        [self.delegate homeModuleDidSuccessUpdateComponent:self];
    }
}

- (void) wrapperFailUpdateForDelegate:(NSString *)errorMessage{
    if ([self.delegate respondsToSelector:@selector(homeModule:didFailUpdateComponent:)]) {
        [self.delegate homeModule:self didFailUpdateComponent:errorMessage];
    }
}

@end

@implementation MMHomeModule (SubclassingOverride)

- (__kindof YTKRequest *)fetchModuleRequest{
    return nil;
}

- (void) parseModuleDataWithRequest:(__kindof YTKRequest *)request{

}

- (BOOL) needPreview{
    return YES;
}

- (UIView *) blankPageView{
    return nil;
}
@end

@implementation MMCompositeHomeModule

- (instancetype)initWithName:(NSString *)name{
    
    self = [super initWithName:name];
    if (self) {
        _innerModules = [NSMutableArray array];
    }
    return self;
}

- (void)addModule:(MMHomeModule *)module{
    [_innerModules addObject:module];
}

- (NSArray<MMHomeModule *> *)modules{
    return [NSArray arrayWithArray:_innerModules];
}

@end
