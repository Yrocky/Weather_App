//
//  HSBaseCellModel.h
//  HSSetTableView
//
//  Created by hushaohui on 2017/4/18.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HSBaseCellModel;
typedef void(^ClickActionBlock)(__kindof HSBaseCellModel *model);

@interface HSBaseCellModel : NSObject

/**
 基础属性
 */
@property (nonatomic,  copy,readonly)   NSString   *identifier;  ///<唯一标识符(更新会用到)
@property (nonatomic,  copy,readonly)   NSString   *cellClass;  ///<该模型绑定的cell类名
@property (nonatomic, assign)           UITableViewCellSelectionStyle   selectionStyle;//选中cell效果
@property (nonatomic, assign)           CGFloat    cellHeight;  ///<cell高度(默认有高度)
@property (nonatomic, assign)           CGFloat separateHeight;  ///<分割线高度
@property (nonatomic, strong)           UIColor *separateColor;  ///<分割线颜色
@property (nonatomic, assign)           UIEdgeInsets separatorInset;  ///<分割线边距
@property (nonatomic,  copy)            ClickActionBlock actionBlock;///<cell点击事件

@property (nonatomic ,strong) id data;///< 携带的数据

@end
