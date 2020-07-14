//
//  QLLiveModelEnvironment.m
//  Weather_App
//
//  Created by rocky on 2020/7/14.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "QLLiveModelEnvironment.h"

@implementation QLLiveModelEnvironment
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}
- (CGSize) effectiveContentSizeWithInsets:(UIEdgeInsets)insets{
    return (CGSize){
        self.collectionView.bounds.size.width - insets.left - insets.right,
        self.collectionView.bounds.size.height - insets.top - insets.bottom
    };
}
@end
