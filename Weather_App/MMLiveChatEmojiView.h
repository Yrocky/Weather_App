//
//  MMLiveChatEmojiView.h
//  MMLive
//
//  Created by user1 on 2018/10/23.
//  Copyright © 2018年 memezhibo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MMLiveChatEmojiView;
@protocol MMLiveChatEmojiViewDelegate <NSObject>

- (void) chatEmojiView:(MMLiveChatEmojiView *)view didSelectedEmojiText:(NSString *)emojiText;
- (void) chatEmojiViewDidDeleteEmojiText:(MMLiveChatEmojiView *)view;

@end

@interface MMLiveChatEmojiView : UIView

@property (nonatomic ,weak) id<MMLiveChatEmojiViewDelegate> delegate;

+ (CGFloat) emojiViewHeight;
@end

NS_ASSUME_NONNULL_END
