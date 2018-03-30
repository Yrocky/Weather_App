//
//  MMContent.h
//  Weather_App
//
//  Created by user1 on 2018/1/3.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMText.h"
#import "MMBackground.h"

@interface MMContent : NSObject<MMRenderProtocol>

@property (nonatomic ,strong) MMText * title;
@property (nonatomic ,strong) MMText * detail;
@property (nonatomic ,strong) MMBackground * bg;
@property (nonatomic ,strong) NSString * template;
@end
