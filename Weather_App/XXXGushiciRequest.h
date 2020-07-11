//
//  XXXGushiciRequest.h
//  Weather_App
//
//  Created by meme-rocky on 2019/1/22.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YTKRequest+PromiseKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXGushiciWrap : NSObject

@property (nonatomic ,copy) NSString * author;

@property (nonatomic ,copy) NSString * category;
@property (nonatomic ,copy ,readonly) NSArray<NSString *>* categorys;

@property (nonatomic ,copy) NSString * content;
@property (nonatomic ,copy ,readonly) NSArray<NSString *>* contents;

@property (nonatomic ,copy) NSString * origin;

@end


@interface XXXGushiciRequest : YTKRequest

@property (nonatomic ,strong ,readonly) XXXGushiciWrap * gushici;
@end

NS_ASSUME_NONNULL_END
