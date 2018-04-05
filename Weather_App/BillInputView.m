//
//  BillInputView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillInputView.h"
#import "Masonry.h"
#import "UIColor+Common.h"

@interface BillInputView ()

@property (strong, nonatomic) UIImageView * categoryImageView;
@property (strong, nonatomic) UILabel * categoryNameLabel;
@property (strong, nonatomic) UILabel * amountLabel;
@property (strong, nonatomic) UIView * cursorView;

@end

@implementation BillInputView

- (void)dealloc{

    [self.amountLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
        
        self.categoryImageView = [[UIImageView alloc] init];
        self.categoryImageView.backgroundColor = [UIColor randomColor];
        [self addSubview:self.categoryImageView];
        [self.categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
            make.width.mas_equalTo(self.categoryImageView.mas_height);
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(16);
        }];
        
        self.categoryNameLabel = [[UILabel alloc] init];
        self.categoryNameLabel.textAlignment = NSTextAlignmentLeft;
        self.categoryNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        self.categoryNameLabel.text = @"Category-Name";
        self.categoryNameLabel.textColor = [UIColor randomColor];
        [self addSubview:self.categoryNameLabel];
        [self.categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.categoryImageView.mas_right).mas_offset(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.textAlignment = NSTextAlignmentRight;
//        self.amountLabel.text = @"12364576";
        self.amountLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightRegular];
        self.amountLabel.textColor = [UIColor colorWithHexString:@"4A4A4A"];
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.mas_right).mas_offset(-20);
            make.left.mas_equalTo(self.categoryNameLabel.mas_right).mas_offset(5);
        }];
        
        self.cursorView = [[UIView alloc] init];
        self.cursorView.backgroundColor = [UIColor colorWithHexString:@"E84357"];
        self.cursorView.layer.masksToBounds = YES;
        self.cursorView.layer.cornerRadius = 2;
        [self addSubview:self.cursorView];
        [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(32);
            make.right.mas_equalTo(self.mas_right).mas_offset(-16);
        }];
        
        [self.amountLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        self.amountLabel.text = @"125";
    }
    return self;
}

- (void) updateInputCategoryWith:(id)category{
    
}
- (void) updateInputAmountViewWith:(NSString *)amount{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"text"]) {
        NSString * newValue = change[NSKeyValueChangeNewKey];
        self.cursorView.hidden = newValue.length == 0;
    }
}
@end
