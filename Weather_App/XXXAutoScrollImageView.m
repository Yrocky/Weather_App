//
//  XXXAutoScrollImageView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/31.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXAutoScrollImageView.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "UIImageView+AFNetworking.h"
#import "MMNoRetainTimer.h"

@interface XXXAutoScrollImageView ()
@property (nonatomic ,strong) UIScrollView * contentView;
@property (nonatomic ,strong) UIImageView * internalImageView;
@property (nonatomic ,strong) MMNoRetainTimer * timer;
@end

@implementation XXXAutoScrollImageView

- (instancetype) initWithDirection:(XXXAutoScrollDirection)direction{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _direction = direction;
        
        self.contentView = [UIScrollView new];
        self.contentView.backgroundColor = [UIColor randomColor];
        [self addSubview:self.contentView];
        
        self.internalImageView = [UIImageView new];
        self.internalImageView.backgroundColor = [UIColor randomColor];
        [self.contentView addSubview:self.internalImageView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.internalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        
        self.timer = [MMNoRetainTimer scheduledTimerWithTimeInterval:2
                                                              target:self
                                                            selector:@selector(onTimer:)
                                                            userInfo:nil repeats:YES];
        [self.timer pause];
    }
    return self;
}

- (void) setupImage:(NSString *)imageName{
    self.internalImageView.image = [UIImage imageNamed:imageName];
}

- (void) setupImage:(NSString *)imageUrl placeholder:(NSString *)placeholder{
    [self.internalImageView setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:placeholder]];
}

- (void)start{
    [self.timer restart];
}

- (void)pause{
    [self.timer pause];
}

#pragma mark - action

- (void) onTimer:(MMNoRetainTimer *)timer{
    
    // timer暂停
    [timer pause];
    
    // 进行动画
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        // 动画结束之后重新开始timer
        [timer restart];
    }];
    
}
@end
