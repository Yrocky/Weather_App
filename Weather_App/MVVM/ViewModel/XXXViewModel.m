//
//  XXXViewModel.m
//  Weather_App
//
//  Created by rocky on 2020/10/21.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "XXXViewModel.h"
#import <UIKit/UIKit.h>

@interface XXXSectionLayoutData ()
- (void) removeAllLayoutDatas;
- (void) addLayoutData:(XXXCellLayoutData *)layoutData;
@end

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
        
        _innerLayoutDatas = [NSMutableArray new];

        const char *queue_name = [[NSString stringWithFormat:@"%@_inner_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        inner_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

- (void) operationMustInMainThread{
    
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
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
    
    NSMutableArray<XXXSectionLayoutData *> * layoutDatas = [NSMutableArray new];
    [self _refreshModelWithResultSet:self.service.resultSet
            correspondingLayoutDatas:layoutDatas];
    
    self.error = error;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 回到主线程，将cellLayoutDatas数据交给UI使用
        [_innerLayoutDatas makeObjectsPerformSelector:@selector(removeAllLayoutDatas)];
        [_innerLayoutDatas removeAllObjects];
        if (layoutDatas.count) {
            [_innerLayoutDatas addObjectsFromArray:layoutDatas];
        }
        
        if (completion) {
            completion(self.layoutDatas,error);
        }
    });
}

#pragma mark - Operation

#pragma mark Section

- (void) addSection:(XXXSection *)section{
    if (section) [self addSections:@[section]];
}

- (void) addSections:(NSArray<XXXSection *> *)sections{
    if (sections.count == 0) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        // 1.更新resultSet的数据
        [self.service.resultSet addSections:sections];
        
        // 2.根据resultSet更新layoutDatas中的数据
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) insertSection:(XXXSection *)section atIndex:(NSInteger)index{
    if (!section || index >= self.service.resultSet.data.count) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet insertSection:section atIndex:index];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) deleteSectionAtIndex:(NSInteger)index{
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet deleteSectionAtIndex:index];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) removeAllItems{
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet removeAllItems];
        [_innerLayoutDatas removeAllObjects];
    }];
}
- (XXXSection *) sectionAtIndex:(NSInteger)index{
    [self operationMustInMainThread];
    __block XXXSection * section;
    [self sync_invoke:^{
        section = self.service.resultSet[index];
    }];
    return section;
}

#pragma mark Item

- (void) addItem:(XXXModel)item forSection:(NSInteger)section{
    if (item) [self addItem:item forSection:section];
}
- (void) addItems:(NSArray<XXXModel> *)items forSection:(NSInteger)section{
    if (items.count == 0 || section >= self.service.resultSet.data.count) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet addItems:items forSection:section];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) insertItem:(XXXModel)item atIndexPath:(NSIndexPath *)indexPath{
    if (!item) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet insertItem:item atIndexPath:indexPath];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= self.service.resultSet.data.count) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet deleteItemAtIndexPath:indexPath];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}
- (void) removeAllItemsForSection:(NSInteger)section{
    if (section >= self.service.resultSet.data.count) return;
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet[section] removeAllItems];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

- (XXXModel) itemAtIndexPath:(NSIndexPath *)indexPath{
    [self operationMustInMainThread];
    __block XXXModel model;
    [self sync_invoke:^{
        model = [self.service.resultSet itemAtIndexPath:indexPath];
    }];
    return model;
}

- (void) replaceItemAtIndexPath:(NSIndexPath *)indexPath withItem:(XXXModel)item{
    
    if (!item ||
        indexPath.section >= self.service.resultSet.data.count ||
        indexPath.row >= self.service.resultSet[indexPath.section].list.count) {
        return;
    }
    [self operationMustInMainThread];
    [self sync_invoke:^{
        [self.service.resultSet deleteItemAtIndexPath:indexPath];
        [self.service.resultSet insertItem:item atIndexPath:indexPath];
        [self _refreshLayoutDatasWithResultSet:self.service.resultSet];
    }];
}

#pragma mark - private

- (void) _refreshLayoutDatasWithResultSet:(XXXResultSet *)resultSet{
    
    NSMutableArray<XXXSectionLayoutData *> * layoutDatas = [NSMutableArray new];
    [self _refreshModelWithResultSet:resultSet
            correspondingLayoutDatas:layoutDatas];
    [_innerLayoutDatas makeObjectsPerformSelector:@selector(removeAllLayoutDatas)];
    [_innerLayoutDatas removeAllObjects];
    if (layoutDatas.count) {
        [_innerLayoutDatas addObjectsFromArray:layoutDatas];
    }
}

- (void) _refreshModelWithResultSet:(XXXResultSet *)resultSet
           correspondingLayoutDatas:(NSMutableArray<XXXSectionLayoutData *> *)layoutDatas{
    
    for (XXXSection * section in resultSet.data) {
        XXXSectionLayoutData * sectionLayoutData =
        [XXXSectionLayoutData new];
        
        for (XXXModel model in section.list) {
        
            if (model.layoutData == nil) {
                
                XXXCellLayoutData * layoutData = [self refreshCellDataWithMetaData:model];
                layoutData.metaData = model;
                
                model.layoutData = layoutData;
            }
            // 将modelAble转化过后的cellLayoutData保存到viewModel中
            [sectionLayoutData addLayoutData:model.layoutData];
        }
        [layoutDatas addObject:sectionLayoutData];
    }
}

#pragma mark - override

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
        
        NSMutableArray<XXXSectionLayoutData *> * layoutDatas = [NSMutableArray new];
        [self _refreshModelWithResultSet:self.service.resultSet
                correspondingLayoutDatas:layoutDatas];

        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程，将cellLayoutDatas数据交给UI使用
            [_innerLayoutDatas makeObjectsPerformSelector:@selector(removeAllLayoutDatas)];
            [_innerLayoutDatas removeAllObjects];
            if (layoutDatas.count) {
                [_innerLayoutDatas addObjectsFromArray:layoutDatas];
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

- (NSArray<XXXSectionLayoutData *> *)layoutDatas{
    return _innerLayoutDatas.copy;
}

@end
