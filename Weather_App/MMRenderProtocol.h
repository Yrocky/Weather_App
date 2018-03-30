//
//  MMRenderProtocol.h
//  Weather_App
//
//  Created by user1 on 2018/1/3.
//  Copyright © 2018年 Yrocky. All rights reserved.
//
//
// 根据json渲染以及生成json的操作内部都是基于YYModel做的

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MMRenderProtocol <NSObject>

@required

/// 根据json数据渲染对应的对象，返回-1表示不是json类型
- (int) renderWithJson:(NSString *)json;

/// 根据对象生辰一个json字符串
- (NSString *) toJson;
@end
