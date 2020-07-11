//
//  EmojiViewController.m
//  Weather_App
//
//  Created by user1 on 2018/11/2.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "EmojiViewController.h"
#import "MMLiveChatEmojiView.h"
#import <Masonry/Masonry.h>

@interface EmojiViewController ()

@property (nonatomic ,strong) MMLiveChatEmojiView * emojiView;
@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.emojiView = [MMLiveChatEmojiView new];
    [self.view addSubview:self.emojiView];
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo([MMLiveChatEmojiView emojiViewHeight]);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
