//
//  MMLiveChatEmojiView.m
//  MMLive
//
//  Created by user1 on 2018/10/23.
//  Copyright © 2018年 memezhibo. All rights reserved.
//

#import "MMLiveChatEmojiView.h"
#import "NSArray+Sugar.h"
#import "MMLiveEmojiManager.h"
#import "UIView+MHCommon.h"
#import <Masonry/Masonry.h>
#import "UIColor+Common.h"

//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhoneX (IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)
#define  kTabbarSafeBottomMargin         (IS_iPhoneX ? 34.f : 0.f)

static CGFloat kMMChatEmojiContentViewHeight = 180.0f;

static NSInteger kMMChatEmojiRow = 3;
static NSInteger kMMChatEmojiCol = 7;

@interface _MMLiveChatEmojiButton : UIButton
@property (nonatomic ,copy) NSString * emojiText;
+ (instancetype) emojiButton;
+ (instancetype) deleteButton;

- (void) setupEmojiName:(NSString *)emojiImg;
@end

@implementation _MMLiveChatEmojiButton

+ (instancetype) emojiButton{
    
    _MMLiveChatEmojiButton * btn = [_MMLiveChatEmojiButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    return btn;
}

- (void)setEmojiText:(NSString *)emojiText{

    _emojiText = emojiText;
    [self setTitle:emojiText forState:UIControlStateNormal];
}

- (void) setupEmojiName:(NSString *)emojiImg{
    [self setImage:[UIImage imageNamed:emojiImg]
          forState:UIControlStateNormal];
}

+ (instancetype) deleteButton{
    _MMLiveChatEmojiButton * btn = [_MMLiveChatEmojiButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"mm_chat_emoji_delete"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    return btn;
}
@end

@interface _MMLiveChatEmojiContent : NSObject
@property (nonatomic ,copy) NSArray<NSString *> * emojiTexts;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,assign) NSInteger baseIndex;
- (NSString *) emojiImageName:(NSInteger)index;
@end
@implementation _MMLiveChatEmojiContent
- (NSString *) emojiImageName:(NSInteger)index{
    return [NSString stringWithFormat:@"emoji_%@_%ld",self.name,self.baseIndex + index];
}
@end

@interface _MMLiveChatEmojiSegmentContent : NSObject
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSArray<_MMLiveChatEmojiContent *> * contents;
@property (nonatomic ,assign ,readonly) NSInteger pageNumber;
@end

@implementation _MMLiveChatEmojiSegmentContent
- (NSInteger)pageNumber{
    return self.contents.count;
}
@end

@interface _MMLiveChatEmojiContentView : UIView{
    NSArray <_MMLiveChatEmojiButton *>* _emojiButtons;
}

@property (nonatomic ,copy) void (^bDidSelectedEmojiText)(NSString *emojiText);
@property (nonatomic ,copy) void (^bDidSelectedDelete)(void);
- (void) updateEmojiContent:(_MMLiveChatEmojiContent *)content;
@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation _MMLiveChatEmojiContentView

- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat emojiButtonWidth = kScreenWidth / kMMChatEmojiCol;
        CGFloat emojiButtonHeight = kMMChatEmojiContentViewHeight / kMMChatEmojiRow;
        
        for (NSInteger index = 0; index < kMMChatEmojiRow * kMMChatEmojiCol; index ++) {

            _MMLiveChatEmojiButton * emojiButton;
            if (index == kMMChatEmojiRow * kMMChatEmojiCol - 1) {
                emojiButton = [_MMLiveChatEmojiButton deleteButton];
                [emojiButton addTarget:self action:@selector(onDeleteButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            }else{
                emojiButton = [_MMLiveChatEmojiButton emojiButton];
                [emojiButton addTarget:self action:@selector(onEmojiButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            }
            emojiButton.frame = (CGRect){
                (index % kMMChatEmojiCol) * emojiButtonWidth,
                (index / kMMChatEmojiCol) * emojiButtonHeight,
                CGSizeMake(emojiButtonWidth, emojiButtonHeight)
            };
            [self addSubview:emojiButton];
        }
        _emojiButtons = [self.subviews mm_select:^BOOL(__kindof UIView *obj) {
            return [obj isKindOfClass:[_MMLiveChatEmojiButton class]];
        }];
    }
    return self;
}

- (void) updateEmojiContent:(_MMLiveChatEmojiContent *)content{
    
    if (!content) {
        NSLog(@"content is null");
        return;
    }
    [_emojiButtons mm_each:^(_MMLiveChatEmojiButton *obj) {
        obj.hidden = YES;
    }];
    [[_emojiButtons mm_last] setHidden:NO];
    
    [content.emojiTexts mm_eachWithIndex:^(NSString *emojiText, NSInteger index) {
        _MMLiveChatEmojiButton * button = self->_emojiButtons[index];
        button.emojiText = emojiText;
        [button setHidden:NO];
        [button setupEmojiName:[content emojiImageName:index]];
    }];
}

- (void) onEmojiButtonAction:(_MMLiveChatEmojiButton *)button{
    if (self.bDidSelectedEmojiText) {
        self.bDidSelectedEmojiText(button.emojiText);
    }
}
- (void) onDeleteButtonAction:(_MMLiveChatEmojiButton *)button{
    if (self.bDidSelectedDelete) {
        self.bDidSelectedDelete();
    }
    
}
@end

@interface MMLiveChatEmojiContentView : UIScrollView<UIScrollViewDelegate>{
    CGFloat _preContentOffsetX;
    NSInteger _currentIndex;
    NSInteger _currentSegmentIndex;
    NSArray <_MMLiveChatEmojiContent *>* _allEmojiContents;
}

@property (nonatomic ,copy) void (^bDidSelectedEmojiText)(NSString * emojiText);
@property (nonatomic ,copy) void (^bDidChangePageIndex)(NSInteger numberOfPages, NSInteger pageIndex);
@property (nonatomic ,copy) void (^bDidChangeSegmentIndex)(NSInteger segmentIndex);
@property (nonatomic ,copy) void (^bDidSelectedDelete)(void);

- (void) updateEmojiContentViewSegment:(NSInteger)segmentIndex;

@property (nonatomic ,strong) _MMLiveChatEmojiContentView * currentContentView;
@property (nonatomic ,strong) UIImageView * snapshotView;

@property (nonatomic ,copy) NSArray<_MMLiveChatEmojiSegmentContent *> * emojiSegmentContents;

@property (nonatomic ,strong) dispatch_queue_t loadEmojiQueue;
@end

@implementation MMLiveChatEmojiContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = 0;
        _currentSegmentIndex = 0;
        _preContentOffsetX = 0.0f;
        
        self.backgroundColor = [UIColor whiteColor];
        self.loadEmojiQueue = dispatch_queue_create("com.2339.loademoji", DISPATCH_QUEUE_SERIAL);
        
        self.alwaysBounceHorizontal = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.pagingEnabled = YES;

        __weak typeof(self) weakSelf = self;
        //
        self.currentContentView = [_MMLiveChatEmojiContentView new];
        self.currentContentView.bDidSelectedDelete = ^{
            if (weakSelf.bDidSelectedDelete) {
                weakSelf.bDidSelectedDelete();
            }
        };
        self.currentContentView.bDidSelectedEmojiText = ^(NSString *emojiText) {
            if (weakSelf.bDidSelectedEmojiText) {
                weakSelf.bDidSelectedEmojiText(emojiText);
            }
        };
        self.currentContentView.frame = CGRectMake(0, 0, kScreenWidth, kMMChatEmojiContentViewHeight);
        [self addSubview:self.currentContentView];
        
        //
        self.snapshotView = [UIImageView new];
        self.snapshotView.frame = CGRectMake(0, 0, kScreenWidth, kMMChatEmojiContentViewHeight);
        [self addSubview:self.snapshotView];
        
        [self asyncLoadAllEmoji:^{
            // default
            [self.currentContentView updateEmojiContent:self.currentIndexEmojiContent];
            
            if (self.bDidChangePageIndex) {
                self.bDidChangePageIndex(self.emojiSegmentContents[0].pageNumber, 0);
            }
            if (self.bDidChangeSegmentIndex) {
                self.bDidChangeSegmentIndex(0);
            }
        }];
    }
    return self;
}

- (void) syncSnapshot:(void(^)(UIImage *image))result{
    
    if (self.currentContentView){
        CGSize size = self.currentContentView.frame.size;
        UIImage *image = nil;
        UIGraphicsBeginImageContextWithOptions(size,
                                               NO,
                                               [UIScreen mainScreen].scale);
        [self.currentContentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (result) {
            result(image);
        }
    }
    else if (result) {
        result(nil);
    }
}

- (void) asyncLoadAllEmoji:(void(^)(void))mainQueueCb{

    dispatch_async(self.loadEmojiQueue, ^{
        
        NSInteger offset = kMMChatEmojiRow * kMMChatEmojiCol - 1;
        NSMutableArray * tempContents = [NSMutableArray array];
        
        MMLiveEmojiManager * emojiMgr = [MMLiveEmojiManager new];
        [emojiMgr loadEmoji:^{
            
            NSArray <MMLiveEmojiSectionWrap *>* emojiSections = emojiMgr.emojiSections;
            self.emojiSegmentContents = [emojiSections mm_mapWithIndex:^_MMLiveChatEmojiSegmentContent *(MMLiveEmojiSectionWrap *sectionWrap, NSUInteger index) {
                
                _MMLiveChatEmojiSegmentContent * segmentContent = [_MMLiveChatEmojiSegmentContent new];
                segmentContent.name = sectionWrap.name;
                segmentContent.contents = [[sectionWrap.emojiTexts mm_sliceSubarray:offset]
                                           mm_mapWithIndex:^_MMLiveChatEmojiContent *(NSArray *emojiTexts, NSUInteger textsIndex) {
                                               
                                               _MMLiveChatEmojiContent * content = [_MMLiveChatEmojiContent new];
                                               content.name = sectionWrap.name;
                                               content.baseIndex = offset * textsIndex;
                                               content.emojiTexts = emojiTexts;
                                               return content;
                                           }];
                
                [tempContents addObjectsFromArray:segmentContent.contents];
                return segmentContent;
            }];
            
            self->_allEmojiContents = [tempContents copy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.contentSize = CGSizeMake(kScreenWidth * tempContents.count, kMMChatEmojiContentViewHeight);
                });
                
                if (mainQueueCb) {
                    mainQueueCb();
                }
            });
        }];
    });
}

- (_MMLiveChatEmojiContent *) currentIndexEmojiContent{
    return _allEmojiContents[_currentIndex];
}

- (_MMLiveChatEmojiContent *) nextIndexEmojiContent{
    
    if (_currentIndex + 1 < _allEmojiContents.count) {
        return _allEmojiContents[_currentIndex + 1];
    }
    return nil;
}

- (_MMLiveChatEmojiContent *) preIndexEmojiContent{
    
    if (_currentIndex - 1 >= 0) {
        return _allEmojiContents[_currentIndex - 1];
    }
    return nil;
}

- (void) currentNumberOfPagesAndNumberIndex{
    
    BOOL outLoop = NO;
    NSInteger sum = 0 ,index = 0;
    
    while (!outLoop) {
        sum += self.emojiSegmentContents[index].pageNumber;
        index ++;
        outLoop = sum >= (_currentIndex + 1);
    }
    NSInteger numberOfPages = self.emojiSegmentContents[index - 1].pageNumber;
    NSInteger numberIndex = 0;
    
    if (sum >= _currentIndex) {
        numberIndex = - sum + _currentIndex + numberOfPages;
    }else{
        numberIndex = _currentIndex;
    }
    
    if (self.bDidChangePageIndex) {
        self.bDidChangePageIndex(numberOfPages, numberIndex);
    }
    
    _currentSegmentIndex = index - 1;
    if (self.bDidChangeSegmentIndex) {
        self.bDidChangeSegmentIndex(index - 1);
    }
}

- (void) updateEmojiContentViewSegment:(NSInteger)segmentIndex{
    
    NSInteger index = 0;
    _MMLiveChatEmojiContent * emojiContent = self.emojiSegmentContents[segmentIndex].contents[0];
    index = [_allEmojiContents indexOfObject:emojiContent];

    // TODO:这一部分的实现有逻辑漏洞，暂时这么写
    NSInteger _index = 0;
    if (index - 1 == -1) {
        _index = 1;
    }else if (_currentSegmentIndex > segmentIndex){
        _index = index - 1 + 2;
    }else{
        _index = index - 1;
    }
    _currentIndex = _index;
    _preContentOffsetX = self.contentOffset.x;
    _currentSegmentIndex = segmentIndex;
    
    [self setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
    if (self.bDidChangePageIndex) {
        self.bDidChangePageIndex(self.emojiSegmentContents[segmentIndex].pageNumber, 0);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= 0 && offsetX <= (_allEmojiContents.count - 1) * kScreenWidth) {

        if (offsetX >= _preContentOffsetX) {
            [self.currentContentView updateEmojiContent:self.nextIndexEmojiContent];
            self.currentContentView.x = (_currentIndex + 1) * kScreenWidth;
        }else{
            [self.currentContentView updateEmojiContent:self.preIndexEmojiContent];
            self.currentContentView.x = (_currentIndex - 1) * kScreenWidth;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _preContentOffsetX = scrollView.contentOffset.x;
    _currentIndex = scrollView.contentOffset.x / kScreenWidth;
    
    //
    self.currentContentView.x = _currentIndex * kScreenWidth;
    [self.currentContentView updateEmojiContent:self.currentIndexEmojiContent];
    
    //
    self.snapshotView.hidden = YES;
    self.snapshotView.x = _currentIndex * kScreenWidth;
    
    //
    [self currentNumberOfPagesAndNumberIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self syncSnapshot:^(UIImage *image) {
        self.snapshotView.image = image;
    }];
    self.snapshotView.hidden = NO;
}

@end

@interface _MMLiveChatEmojiSegmentItemView : UIButton{
    UIView * _sepView;
}
+ (instancetype) segmentItemViewWith:(NSString *)imageName;
- (void) showSepView:(BOOL)show;
@end

@implementation _MMLiveChatEmojiSegmentItemView

+ (instancetype) segmentItemViewWith:(NSString *)imageName{

    _MMLiveChatEmojiSegmentItemView * v = [_MMLiveChatEmojiSegmentItemView buttonWithType:UIButtonTypeCustom];
    [v setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//        [self setBackgroundColor:[UIColor colorWithHexString:@"#F7F8FC"] forState:UIControlStateSelected];
        
        _sepView = [UIView new];
        _sepView.backgroundColor = [UIColor colorWithHexString:@"#A2A2A3"];
        [self addSubview:_sepView];
        
        [_sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(15);
        }];
        [self showSepView:YES];
    }
    return self;
}

- (void) showSepView:(BOOL)show{
    _sepView.hidden = !show;
}
@end

@interface MMLiveChatEmojiSegmentView : UIView{
    UIScrollView * _contentView;
    UIButton * _sendButton;
    NSMutableArray <_MMLiveChatEmojiSegmentItemView *>* _segmentItems;
    NSInteger _currentSegmentIndex;
}
@property (nonatomic ,assign) BOOL showSendButton;
@property (nonatomic ,copy) void (^bDidSelectedSegmentIndex)(NSInteger segmentIndex);

- (void) changeSegmentIndexTo:(NSInteger)index;
@end

@implementation MMLiveChatEmojiSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.mas_equalTo(self);
            make.right.mas_equalTo(self.mas_right).mas_offset(-(80));
        }];
        
        _segmentItems = [NSMutableArray arrayWithArray:[[@[@"normal",@"meme",@"privilege",@"vip"] mm_map:^id(id obj) {
            return [NSString stringWithFormat:@"mm_chat_emoji_%@",obj];
        }] mm_mapWithIndex:^_MMLiveChatEmojiSegmentItemView *(NSString * obj, NSUInteger index) {
            _MMLiveChatEmojiSegmentItemView * itemView = [_MMLiveChatEmojiSegmentItemView segmentItemViewWith:obj];
            [itemView addTarget:self action:@selector(onSegmentItemAction:)
               forControlEvents:UIControlEventTouchUpInside];
            itemView.tag = index + 100;
            [self->_contentView addSubview:itemView];
            return itemView;
        }]];
        _contentView.contentSize = CGSizeMake(_segmentItems.count * 64, (48));
        [_segmentItems mm_eachWithIndex:^(_MMLiveChatEmojiSegmentItemView *obj, NSInteger index) {
            if (index == 0) {
                obj.selected = YES;
            }
            if (index == self->_segmentItems.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{                
                    [obj showSepView:NO];
                });
            }
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self->_contentView);
                make.width.mas_equalTo(64);
                make.height.mas_equalTo(48);
                if (index > 0) {
                    UIView * preView = self->_segmentItems[index - 1];
                    make.left.mas_equalTo(preView.mas_right);
                }else{
                    make.left.mas_equalTo(self->_contentView.mas_left);
                }
            }];
        }];
    }
    return self;
}

- (void) onSegmentItemAction:(_MMLiveChatEmojiSegmentItemView *)itemView{
    
    NSInteger index = itemView.tag - 100;
    if (self.bDidSelectedSegmentIndex) {
        self.bDidSelectedSegmentIndex(itemView.tag - 100);
    }
    [self changeSegmentIndexTo:index];
}

- (void) changeSegmentIndexTo:(NSInteger)index{
    
    if (_currentSegmentIndex != index) {
        [_segmentItems mm_each:^(_MMLiveChatEmojiSegmentItemView *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                obj.selected = obj.tag == index + 100;
            });
        }];
    }
    
    _currentSegmentIndex = index;
}
@end

@interface MMLiveChatEmojiView ()

@property (nonatomic ,strong) MMLiveChatEmojiContentView * emojiContentView;
@property (nonatomic ,strong) UIPageControl * pageControl;
@property (nonatomic ,strong) MMLiveChatEmojiSegmentView * segmentView;
@end

@implementation MMLiveChatEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        __weak typeof(self) weakSelf = self;
        _emojiContentView = [MMLiveChatEmojiContentView new];
        self.emojiContentView.backgroundColor = [UIColor clearColor];
        self.emojiContentView.showsHorizontalScrollIndicator = NO;
        self.emojiContentView.pagingEnabled = YES;
        self.emojiContentView.bDidSelectedEmojiText = ^(NSString *emojiText) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatEmojiView:didSelectedEmojiText:)]) {
                [weakSelf.delegate chatEmojiView:weakSelf didSelectedEmojiText:emojiText];
            }
        };
        self.emojiContentView.bDidSelectedDelete = ^(){
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatEmojiViewDidDeleteEmojiText:)]) {
                [weakSelf.delegate chatEmojiViewDidDeleteEmojiText:weakSelf];
            }
        };
        self.emojiContentView.bDidChangePageIndex = ^(NSInteger numberOfPages, NSInteger pageIndex) {
            if (weakSelf.pageControl.numberOfPages != numberOfPages) {
                weakSelf.pageControl.numberOfPages = numberOfPages;
            }
            [weakSelf.pageControl setCurrentPage:pageIndex];
        };
        self.emojiContentView.bDidChangeSegmentIndex = ^(NSInteger segmentIndex) {
            [weakSelf.segmentView changeSegmentIndexTo:segmentIndex];
        };
        [self addSubview:self.emojiContentView];
        
        _pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FF356F"];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.numberOfPages = 3;
        [self addSubview:self.pageControl];
        
        _segmentView = [MMLiveChatEmojiSegmentView new];
        self.segmentView.bDidSelectedSegmentIndex = ^(NSInteger segmentIndex) {
            [weakSelf.emojiContentView updateEmojiContentViewSegment:segmentIndex];
        };
        [self addSubview:self.segmentView];
        
        [self.emojiContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(kScreenWidth);
            make.bottom.mas_equalTo(self.pageControl.mas_top);
            make.height.mas_equalTo(kMMChatEmojiContentViewHeight);
            make.top.mas_equalTo(self);
        }];
        
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.segmentView.mas_top);
            make.height.mas_equalTo(20);
        }];
        
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.mas_equalTo(self);
            }
            make.height.mas_equalTo(48);
        }];
    }
    return self;
}
+ (CGFloat) emojiViewHeight{
    return kMMChatEmojiContentViewHeight + 20 + 48 + kTabbarSafeBottomMargin;
}
@end
