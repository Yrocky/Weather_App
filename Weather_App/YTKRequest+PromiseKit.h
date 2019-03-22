//
//  YTKRequest+PromiseKit.h
//  Weather_App
//
//  Created by meme-rocky on 2019/1/21.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "YTKRequest.h"
#import <PromiseKit/AnyPromise.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTKRequest (PromiseKit)

- (AnyPromise *)startPromise;

///用于将原始数据进行映射，返回业务中需要的数据结构，一般都是模型化
- (id) mapModelWithJsonData:(id)jsonData;
@end

@interface XXXRequest<__covariant ResultType> : YTKRequest
- (ResultType) mapModelWithJsonData:(id)jsonData;
@end
NS_ASSUME_NONNULL_END
