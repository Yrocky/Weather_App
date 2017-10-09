//
//  MMAssetsCellModel.h
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "HSCustomCellModel.h"
#import "HSCustomTableViewCell.h"

@interface MMAssetsCellModel : HSCustomCellModel

@property (nonatomic ,strong) NSString * handleText;
@property (nonatomic ,strong) UIColor * handleTextColor;

@property (nonatomic ,strong) UIColor * handleBgColor;

@property (nonatomic ,copy) void(^bAssetsHandle)();

- (instancetype)initWithTitle:(NSString *)title handleButtonActoin:(ClickActionBlock)block;
@end

@interface MMAssetsCell : HSCustomTableViewCell


@end
