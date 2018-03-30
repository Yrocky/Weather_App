//
//  MMBackground.h
//  Weather_App
//
//  Created by user1 on 2018/1/3.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMRenderProtocol.h"

@interface MMBackground : NSObject<MMRenderProtocol>
@property (nonatomic ,strong) UIImage * image;
@end
