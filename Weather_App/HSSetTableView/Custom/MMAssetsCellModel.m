//
//  MMAssetsCellModel.m
//  HSSetTableViewCtrollerDemo
//
//  Created by user1 on 2017/8/25.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "MMAssetsCellModel.h"
#import "HSSetTableViewControllerConst.h"

@implementation MMAssetsCellModel

- (instancetype)initWithTitle:(NSString *)title handleButtonActoin:(ClickActionBlock)block{

    self = [super initWithCellIdentifier:@"MMAssetsCell" actionBlock:nil];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellHeight = 76;
        
        self.text = title;
        self.detailText = @"0";
        self.bAssetsHandle = block;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellHeight = 76;
        
        self.detailText = @"0";
    }
    return self;
}
@end

@interface MMAssetsCell ()

@property (nonatomic ,strong) MMAssetsCellModel * assetsModel;
@property (nonatomic ,weak) UIButton * handleButton;
@end

@implementation MMAssetsCell

+ (HSBaseTableViewCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView
{
    MMAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        
        //这里重写父类方法 仅仅是因为需要改写下cell样式，实际情况可以自己管理布局
        cell = [[MMAssetsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MMAssetsCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)setupUI
{
    [super setupUI];
    
    //添加switch
    UIButton *handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    handleButton.frame = (CGRect){
        [UIScreen mainScreen].bounds.size.width - 76 - HS_KCellMargin,
        (76 - 32)/2,
        76,32
    };
    
    [handleButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:handleButton];
    handleButton.layer.cornerRadius = 32/2;
    handleButton.layer.borderWidth = 1;
    handleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    handleButton.layer.borderColor = [UIColor colorWithHexString:@"#7C5CF5"].CGColor;
    handleButton.layer.masksToBounds = YES;
    self.handleButton = handleButton;
    
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.textColor = [UIColor colorWithHexString:@"#757C90"];
    
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:28];
    self.detailTextLabel.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
}

- (void)setupDataModel:(HSBaseCellModel *)model
{
    [super setupDataModel:model];
    
    MMAssetsCellModel *cellModel = (MMAssetsCellModel *)model;
    self.assetsModel = cellModel;
    
    [self.handleButton setTitle:cellModel.handleText forState:UIControlStateNormal];
    [self.handleButton setTitleColor:cellModel.handleTextColor forState:UIControlStateNormal];
    self.handleButton.backgroundColor = cellModel.handleBgColor;
    self.textLabel.text = cellModel.text;
    self.detailTextLabel.text = cellModel.detailText;
}

- (void)handleButtonAction:(UIButton *)handleButton
{
    
    if (self.assetsModel.bAssetsHandle) {
        self.assetsModel.bAssetsHandle();
    }
}

@end
