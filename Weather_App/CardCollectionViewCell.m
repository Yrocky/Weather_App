//
//  CardCollectionViewCell.m
//  Weather_App
//
//  Created by 洛奇 on 2019/3/22.
//  Copyright © 2019年 Yrocky. All rights reserved.
//

#import "CardCollectionViewCell.h"
#import "Masonry.h"
#import "UIColor+Common.h"
//#import "UIImageView+WebCache.h"

@interface CardCollectionViewCell ()
@property (nonatomic ,strong) UILabel * label;
@property (strong, nonatomic) UIVisualEffectView *coverEffectView;
@property (strong, nonatomic) UIImageView *coverImageView;

@end

@implementation CardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor randomColor];
        
        self.coverImageView = [UIImageView new];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.coverEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.contentView addSubview:self.coverEffectView];
        
        self.label = [UILabel new];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.coverEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.coverImageView.image = nil;
}

- (void) setupCoverImageWith:(NSString *)imageUrl name:(NSString *)name{
    self.label.text = name;
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

+ (NSString *) cellIdentifier{
    return @"CardCollectionViewCell.identifier";
}
@end
