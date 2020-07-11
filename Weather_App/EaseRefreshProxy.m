//
//  EaseRefreshProxy.m
//  Weather_App
//
//  Created by rocky on 2020/7/10.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "EaseRefreshProxy.h"
#import <MJRefresh/MJRefresh.h>

@interface EaseRefreshProxy ()
@property (nonatomic ,assign) NSInteger origIndex;
@end

@implementation EaseRefreshProxy

- (void)dealloc{
    NSLog(@"EaseRefreshProxy dealloc");
}
- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _isRefresh = YES;
        _size = 20;
        _origIndex = _index = 0;
    }
    return self;
}

- (void) setupPageOrigIndex:(NSInteger)origIndex andSize:(NSInteger)size{
    _size = size;
    _origIndex = _index = origIndex;
}

- (void) addRefresh:(void(^)(NSInteger index))cb{
    @weakify(self);
    _scrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self _refresh];
        [self endLoadMore];
        if (cb) {
            cb(self->_index);
        }
    }];
    // 第一次手动刷新
    [self onRefresh];
}

- (void)onRefresh{
    [_scrollView.mj_header executeRefreshingCallback];
}

- (void) endRefresh{
    [self _endRefresh];
    [_scrollView.mj_header endRefreshing];
    
}

- (void) addLoadMore:(NSString *)noMoreDataText callback:(void(^)(NSInteger index))cb{
    @weakify(self);
    MJRefreshBackStateFooter * footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _loadMore];
        if (cb) {
            cb(self->_index);
        }
    }];
    [footer setTitle:noMoreDataText == nil ? @"人家是有底线的" : noMoreDataText
            forState:MJRefreshStateNoMoreData];
    _scrollView.mj_footer = footer;
}

- (void) onLoadMore{
    [_scrollView.mj_footer executeRefreshingCallback];
}

- (void) endLoadMore{
    [_scrollView.mj_footer endRefreshing];
}

- (void) noMoreData{
    [_scrollView.mj_footer endRefreshingWithNoMoreData];
}

- (void) endRefreshOrLoadMore{
    if (_isRefresh) {
        [self endRefresh];
    } else {
        [self endLoadMore];
    }
}

#pragma mark - private

- (void) _refresh{
    _isRefresh = YES;
    _index = _origIndex;
}

- (void) _endRefresh{
    _isRefresh = NO;
    _index = _origIndex;
}

- (void) _loadMore{
    _isRefresh = NO;
    _index ++;
}
@end
