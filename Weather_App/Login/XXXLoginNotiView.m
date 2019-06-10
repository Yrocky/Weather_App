//
//  XXXLoginNotiView.m
//  Weather_App
//
//  Created by 洛奇 on 2019/6/6.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXLoginNotiView.h"
#import "Masonry.h"

@implementation XXXLoginNotiView

- (void)dealloc{
    NSLog(@"dealloc XXXLoginNotiView");
}

+ (instancetype) notiWith:(NSString *)text{
    return [[self alloc] initWith:text];
}

- (instancetype) initWith:(NSString *)text{
    self = [super initWithFrame:(CGRect){
        CGPointZero,
        [UIApplication sharedApplication].keyWindow.frame.size.width,
        40
    }];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        _time = 2.5;
        
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.text = text;
        [self addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(10);
            make.top.equalTo(self).mas_offset(10);
            make.right.equalTo(self).mas_offset(-10);
            make.bottom.equalTo(self).mas_offset(-10);
            make.height.mas_greaterThanOrEqualTo(30);
        }];
    }
    return self;
}

///<默认2.5s消失
- (instancetype) dismissAfter:(NSTimeInterval)time{
    _time = time;
    return self;
}

- (void) show{
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.superview.mas_safeAreaLayoutGuideTop).mas_offset(12);
        } else {
            make.top.mas_equalTo(self.superview.mas_top).mas_offset(12);
        }
        make.right.equalTo(self.superview).mas_offset(-12);
    }];
    [self setNeedsLayout];
    
    [self.layer setValue:@(self.frame.size.height) forKeyPath:@"transform.translation.y"];
    [UIView animateWithDuration:0.25 animations:^{
        [self.layer setValue:@(0) forKeyPath:@"transform.translation.y"];
        [self layoutIfNeeded];
    }];
    
    __block UIView * fakeSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            fakeSelf.alpha = 0.0f;
        } completion:^(BOOL finished) {        
            [fakeSelf removeFromSuperview];
            fakeSelf = nil;
        }];
    });
}
@end
