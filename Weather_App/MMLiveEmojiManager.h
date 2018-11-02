//
//  MMLiveEmojiManager.h
//  MMLive
//
//  Created by user1 on 2018/10/31.
//  Copyright © 2018年 memezhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLiveEmojiSectionWrap : NSObject

@property (nonatomic ,assign) BOOL isGif;

@property (nonatomic ,copy ,readonly) NSString * prefix;
@property (nonatomic ,copy ,readonly) NSString * name;
@property (nonatomic ,copy) NSArray<NSString *> * emojiTexts;
+ (instancetype) emojiTextWrapWith:(nullable NSString *)prefix name:(NSString *)name;
@end

@interface MMLiveEmojiManager : NSObject

@property (nonatomic ,strong) NSArray<MMLiveEmojiSectionWrap *> * emojiSections;

///<将消息中包含有表情的字符进行替换，比如：/色 --> [emoji_normal_23,NO] 其中的NO表示这个图片不是gif
- (NSString *) replaceEmojiTextForEmojiImageWith:(NSString *)message;

- (NSArray<NSString *>*) allEmojiTexts;

- (void) loadEmoji:(void(^)())cb;
@end

NS_ASSUME_NONNULL_END
