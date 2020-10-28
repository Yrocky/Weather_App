//
//  XXXViewModel.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXViewModel.h"

@interface XXXViewModel (){
    dispatch_queue_t inner_queue;
}
@property (nonatomic ,strong ,readwrite) NSError * error;
@end

@implementation XXXViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _layoutDatas = [NSMutableArray new];
        
        const char *queue_name = [[NSString stringWithFormat:@"%@_inner_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        inner_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

#pragma mark - Service

- (void)reloadDataWithCompletion:(XXXPrelayoutCompletionBlock)completion{
    
    self.error = nil;
    // 异步发起网络请求
    [self async_invoke:^{
        [self.service reloadDataWithCompletion:^(XXXResultSet * _Nonnull resultSet, NSError * _Nonnull error) {
            [self _handleServiceResultSet:resultSet
                                    error:error
                               completion:completion];
        }];
    }];
}

- (void)loadMoreDataWithCompletion:(XXXPrelayoutCompletionBlock)completion{
    
    self.error = nil;
    [self async_invoke:^{
        [self.service loadMoreDataWithCompletion:^(XXXResultSet * _Nonnull resultSet, NSError * _Nonnull error) {
            [self _handleServiceResultSet:resultSet
                                    error:error
                               completion:completion];
        }];
    }];
}

- (void) _handleServiceResultSet:(XXXResultSet *)resultSet error:(NSError *)error completion:(XXXPrelayoutCompletionBlock)completion{
    
    NSMutableArray * layoutDatas = [NSMutableArray new];
    [self _refreshModelWithResultSet:self.service.resultSet
            correspondingLayoutDatas:layoutDatas];
    
    self.error = error;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 回到主线程，将cellLayoutDatas数据交给UI使用
        [self.layoutDatas removeAllObjects];
        if (layoutDatas.count) {
            [self.layoutDatas addObjectsFromArray:layoutDatas];
        }
        
        if (completion) {
            completion(self.layoutDatas,error);
        }
    });
}

#pragma mark - Operation

- (void) addItem:(XXXModel)item{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet addItem:item];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void)addItems:(NSArray<XXXModel> *)items{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet addItems:items];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void) insertItem:(XXXModel)item atIndex:(NSInteger)index{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet insertItem:item atIndex:index];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void) replaceItemAtIndex:(NSInteger)index withItem:(XXXModel)item{
    
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        XXXModel origin =
        [self.service.resultSet.items objectAtIndex:index];
        [self.service.resultSet deleteItem:origin];
        [self.service.resultSet insertItem:item atIndex:index];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void) deleteItem:(XXXModel)item{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet deleteItem:item];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void) deleteItemAtIndex:(NSInteger)index{
    
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet deleteItemAtIndex:index];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (void) removeAllItems{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self sync_invoke:^{
        [self.service.resultSet removeAllItems];
        [self.layoutDatas removeAllObjects];
    }];
}

- (XXXModel) itemAtIndex:(NSInteger)index{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    __block XXXModel model;
    [self sync_invoke:^{
        model = [self.service.resultSet itemAtIndex:index];
    }];
    return model;
}

- (void) _refreshLayoutDatasWithResultSet:(XXXResultSet *)resultSet{
    
    NSMutableArray * layoutDatas = [NSMutableArray new];
    [self _refreshModelWithResultSet:resultSet
            correspondingLayoutDatas:layoutDatas];
    [self.layoutDatas removeAllObjects];
    if (layoutDatas.count) {
        [self.layoutDatas addObjectsFromArray:layoutDatas];
    }
}

- (void) _refreshModelWithResultSet:(XXXResultSet *)resultSet correspondingLayoutDatas:(NSMutableArray *)layoutDatas{
    
    for (XXXModel item in resultSet.items) {
        if (item.layoutData == nil) {
            
            XXXCellLayoutData * layoutData = [self refreshCellDataWithMetaData:item];
            layoutData.metaData = item;
            
            item.layoutData = layoutData;
        }
        
        // 将modelAble转化过后的cellLayoutData保存到viewModel中
        [layoutDatas addObject:item.layoutData];
    }
}

- (XXXKinfOfLayoutData *) refreshCellDataWithMetaData:(XXXModel)metaData{
    // 子类重写，根据metaData进行布局的计算
    return XXXCellLayoutData.new;
}

#pragma mark - Refresh

- (void) refreshModelWithResultSet:(XXXResultSet *)resultSet{
    [self sync_invoke:^{
        [self _refreshLayoutDatasWithResultSet:resultSet];
    }];
}

- (void) asyncRefreshModelWithResultSet:(XXXResultSet *)resultSet completion:(XXXPrelayoutCompletionBlock)completion{
    [self async_invoke:^{
        NSMutableArray * layoutDatas = [NSMutableArray new];
        [self _refreshModelWithResultSet:resultSet
                correspondingLayoutDatas:layoutDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.layoutDatas removeAllObjects];
            if (layoutDatas.count) {
                [self.layoutDatas addObjectsFromArray:layoutDatas];
            }
            if (completion) {
                completion(self.layoutDatas, nil);
            }
        });
    }];
}

#pragma mark - Private

- (void) sync_invoke:(void(^)(void))block{
    if (block == NULL) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == inner_queue) assert(0);
#pragma clang diagnostic pop
    
    dispatch_sync(inner_queue, block);
}

- (void) async_invoke:(void(^)(void))block{
    if (block == NULL) return;
    dispatch_async(inner_queue, block);
}

@end
