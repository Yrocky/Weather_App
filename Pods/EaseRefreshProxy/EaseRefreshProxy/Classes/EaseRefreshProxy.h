//
//  EaseRefreshProxy.h
//  Weather_App
//
//  Created by rocky on 2020/7/10.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseRefreshProxy : NSObject{
    __weak UIScrollView *_scrollView;
    
    BOOL _isRefresh;
    
    NSInteger _size;
    NSInteger _index;
}

@property (nonatomic ,weak ,readonly) UIScrollView * scrollView;

@property (nonatomic ,assign ,readonly) BOOL isRefresh;

@property (nonatomic ,assign ,readonly) NSInteger size;
@property (nonatomic ,assign ,readonly) NSInteger index;

- (instancetype) initWithScrollView:(UIScrollView *)scrollView;

- (void) setupPageOrigIndex:(NSInteger)origIndex andSize:(NSInteger)size;

- (void) addRefresh:(void(^)(NSInteger index))cb;
/// 使用代码主动触发下拉刷新的逻辑
- (void) onRefresh;
- (void) endRefresh;

- (void) addLoadMore:(nullable NSString *)noMoreDataText
            callback:(void(^)(NSInteger index))cb;
/// 主动触发上拉加载的逻辑
- (void) onLoadMore;
- (void) endLoadMore;

- (void) noMoreData;

- (void) endRefreshOrLoadMore;

@end
NS_ASSUME_NONNULL_END
