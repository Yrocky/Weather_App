//
//  MMLiveEmojiManager.m
//  MMLive
//
//  Created by user1 on 2018/10/31.
//  Copyright © 2018年 memezhibo. All rights reserved.
//

#import "MMLiveEmojiManager.h"
#import "NSArray+Sugar.h"
#import "HLLAttributedBuilder.h"

@implementation MMLiveEmojiSectionWrap

+ (instancetype) emojiTextWrapWith:(nullable NSString *)prefix name:(NSString *)name{
    return [[self alloc] initWithPrefix:prefix name:name];
}

- (instancetype) initWithPrefix:(NSString *)prefix name:(NSString *)name{
    self = [super init];
    if (self) {
        _prefix = prefix;
        _name = name;
    }
    return self;
}

- (NSString *) emojiImageName:(NSInteger)index{
    if (self.isGif) {
        return [NSString stringWithFormat:@"emoji_gif_%@_%ld",self.name,(long)index];
    }
    return [NSString stringWithFormat:@"emoji_%@_%ld",self.name,(long)index];
}
@end

@interface MMLiveEmojiManager ()

@property (nonatomic ,strong) MMLiveEmojiSectionWrap * normalEmojiWrap;
@property (nonatomic ,strong) MMLiveEmojiSectionWrap * memeEmojiWrap;
@property (nonatomic ,strong) MMLiveEmojiSectionWrap * privilegeEmojiWrap;
@property (nonatomic ,strong) MMLiveEmojiSectionWrap * vipEmojiWrap;

@property (nonatomic ,strong) dispatch_queue_t loadEmojiQueue;
@end

@implementation MMLiveEmojiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.loadEmojiQueue = dispatch_queue_create("com.2339.loademoji", DISPATCH_QUEUE_SERIAL);
        
//        [self asyncLoadEmojiResult:nil];
    }
    return self;
}

- (NSString *) replaceEmojiTextForEmojiImageWith:(NSString *)message{
    
    /*
     emojiTexts = "/大哭12而/mok好的/l色色色/v美人你好"
     separatedEmojiTexts = ["","大哭12而","mok好的","l色色色","v美人你好"]
     
     最坏的情况是，每一个表情(/l色)要遍历当前分类(privilege)下所有的emojiText(假如privilege下有80个)
     
     有待改进
    */
    __block NSString * replacedMessage = message;
    NSArray <NSString *>* separatedEmojiTexts = [message componentsSeparatedByString:@"/"];
    [[separatedEmojiTexts mm_select:^BOOL(NSString *obj) {
//        return !NSStringIsNULL(obj);
        return obj != nil && obj.length;
    }] mm_each:^(NSString *obj) {
        MMLiveEmojiSectionWrap * emojiWrap = [self emojiTextsArrayContainsSepartedText:obj];
        [emojiWrap.emojiTexts mm_eachWithIndex:^(NSString *emojiText, NSInteger index) {
            
            replacedMessage = [RX(emojiText) replaceMatchedStringsWith:^NSString * _Nonnull(NSString * _Nonnull matchedString) {
                return [NSString stringWithFormat:@"[%@,%d]",[emojiWrap emojiImageName:index],emojiWrap.isGif];
            } inString:replacedMessage];
        }];
    }];
    NSLog(@"replacedMessage:%@",replacedMessage);
    return replacedMessage;
}

- (MMLiveEmojiSectionWrap *) emojiTextsArrayContainsSepartedText:(NSString *)text{
    
    if ([text hasPrefix:self.memeEmojiWrap.prefix]) {// 么么的表情
        return self.memeEmojiWrap;
    }else if ([text hasPrefix:self.privilegeEmojiWrap.prefix]){// 特权
        return self.privilegeEmojiWrap;
    } else if ([text hasPrefix:self.vipEmojiWrap.prefix]){// vip
        return self.vipEmojiWrap;
    }else{// 普通
        return self.normalEmojiWrap;
    }
}
- (void) loadEmoji:(void(^)())cb{
    [self asyncLoadEmojiResult:^{
        if (cb) {
            cb();
        }
    }];
}
- (void) asyncLoadEmojiResult:(void(^)(void))result{
    
    dispatch_async(self.loadEmojiQueue, ^{
        
        NSString * emojiPath = [[NSBundle mainBundle] pathForResource:@"MMEmojiText" ofType:@"plist"];
        NSArray<NSArray *> * emojiTexts = [NSArray arrayWithContentsOfFile:emojiPath];
        
        self.normalEmojiWrap = [MMLiveEmojiSectionWrap emojiTextWrapWith:nil
                                                                   name:@"normal"];
        self.normalEmojiWrap.isGif = YES;
        self.normalEmojiWrap.emojiTexts = [emojiTexts objectAtIndex:0];
        
        self.memeEmojiWrap = [MMLiveEmojiSectionWrap emojiTextWrapWith:@"m"
                                                                 name:@"meme"];
        self.memeEmojiWrap.isGif = YES;
        self.memeEmojiWrap.emojiTexts = [emojiTexts objectAtIndex:1];
        
        self.privilegeEmojiWrap = [MMLiveEmojiSectionWrap emojiTextWrapWith:@"l"
                                                                      name:@"privilege"];
        self.privilegeEmojiWrap.isGif = NO;
        self.privilegeEmojiWrap.emojiTexts = [emojiTexts objectAtIndex:2];
        
        self.vipEmojiWrap = [MMLiveEmojiSectionWrap emojiTextWrapWith:@"v"
                                                                name:@"vip"];
        self.vipEmojiWrap.isGif = YES;
        self.vipEmojiWrap.emojiTexts = [emojiTexts objectAtIndex:3];
        
        self.emojiSections = @[self.normalEmojiWrap,self.memeEmojiWrap,self.privilegeEmojiWrap,self.vipEmojiWrap];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result();
            }
        });
    });
}

- (NSArray<NSString *>*) allEmojiTexts{
    
    NSMutableArray * allEmojiTexts = [NSMutableArray array];
    [self.emojiSections mm_each:^(MMLiveEmojiSectionWrap *obj) {
        [allEmojiTexts addObjectsFromArray:obj.emojiTexts];
    }];
    return allEmojiTexts.copy;
}
@end
