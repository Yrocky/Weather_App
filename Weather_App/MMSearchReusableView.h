//
//  MMSearchReusableView.h
//  memezhibo
//
//  Created by user1 on 2017/7/12.
//  Copyright © 2017年 Xingaiwangluo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kSearchHeaderViewIdentifier = @"MMSearchHeaderView";
static NSString * const kSearchFooterViewIdentifier = @"MMSearchFooterView";

@interface MM_SearchHeaderView : UICollectionReusableView

@property (nonatomic ,strong) UIView * backgroundView;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UIButton * handleButton;

- (void) setHandleText:(NSString *)text;
@end

@interface MM_SearchFooterView : UICollectionReusableView

@end

@interface MMTagCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end
