//
//  HSSwitchCellModel.m
//  HSSetTableView
//
//  Created by hushaohui on 2017/4/19.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSSwitchCellModel.h"
#import "HSSetTableViewControllerConst.h"

@implementation HSSwitchCellModel

- (instancetype)initWithTitle:(NSString *)title switchType:(BOOL)on switchBlock:(switchBlock)block
{
    if(self = [super initWithTitle:title actionBlock:nil]){
        self.switchBlock = [block copy];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showArrow = NO;
        self.on = on;
        self.onTintColor = [UIColor colorWithHexString:@"#00BF9A"];
    }
    return self;
}

- (NSString *)cellClass
{
    return HSSwitchCellModelCellClass;
}
@end
