//
//  XXXSectionLayoutData.m
//  BanBanLive
//
//  Created by rocky on 2020/12/8.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "XXXSectionLayoutData.h"

@interface XXXSectionLayoutData ()
@property (nonatomic ,strong) NSMutableArray<XXXKinfOfLayoutData *> * innerLayoutDatas;
@end

@implementation XXXSectionLayoutData

- (void) removeAllLayoutDatas{
    [self.innerLayoutDatas removeAllObjects];
}

- (void) addLayoutData:(XXXCellLayoutData *)layoutData{
    if (layoutData) {
        [self.innerLayoutDatas addObject:layoutData];
    }
}

- (NSArray<XXXKinfOfLayoutData *> *)layoutDatas{
    if (!_innerLayoutDatas) {
        _innerLayoutDatas = [NSMutableArray new];
    }
    return _innerLayoutDatas;
}
@end
