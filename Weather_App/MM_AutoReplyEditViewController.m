//
//  MM_AutoReplyEditViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/9/18.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MM_AutoReplyEditViewController.h"

@implementation MM_AutoReplyItem
@synthesize regex;
@synthesize reply;
@synthesize valid;
@synthesize createTime;

- (instancetype)init
{
    self = [super init];
    if (self) {
        valid = YES;
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:regex forKey:@"mm_regex"];
    [aCoder encodeObject:reply forKey:@"mm_reply"];
    [aCoder encodeBool:valid forKey:@"mm_valid"];
    [aCoder encodeObject:createTime forKey:@"mm_createTime"];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.regex =[aDecoder decodeObjectForKey:@"mm_regex"];
        self.reply = [aDecoder decodeObjectForKey:@"mm_reply"];
        self.valid = [aDecoder decodeBoolForKey:@"mm_valid"];
        self.createTime = [aDecoder decodeObjectForKey:@"mm_createTime"];
    }
    return self;
}
@end

@interface MM_EditItemView : UIView

@property (nonatomic ,strong) UILabel * textLabel;
@property (nonatomic ,strong) UITextView * contentView;
@end

@implementation MM_EditItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.textLabel];
        
        self.contentView = [[UITextView alloc] init];
        self.contentView.tintColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.37 green:0.71 blue:0.33 alpha:1.00];
        self.contentView.textColor = [UIColor whiteColor];
        self.contentView.font = [UIFont systemFontOfSize:15];
        [self addSubview:_contentView];
    }
    return self;
}

- (void) configText:(NSString *)text content:(NSString *)content{
    self.textLabel.text = text;
    self.contentView.text = content;
}

-(void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    CGFloat offset = 20;
    self.textLabel.frame = (CGRect){
        offset,0,
        frame.size.width - 2 * offset,30
    };
    self.contentView.frame = (CGRect){
        self.textLabel.frame.origin.x,
        CGRectGetMaxY(self.textLabel.frame) + 0,
        CGRectGetWidth(self.textLabel.frame),
        CGRectGetHeight(frame) - CGRectGetMaxY(self.textLabel.frame) - 0
    };
}
@end

@interface MM_AutoReplyEditViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) MM_AutoReplyItem * item;
@property (nonatomic ,strong) UIScrollView * editContentView;
@property (nonatomic ,strong) MM_EditItemView * regexItemView;
@property (nonatomic ,strong) MM_EditItemView * replyItemView;
@end

@implementation MM_AutoReplyEditViewController

- (instancetype) initWithItem:(id)item{

    self = [super init];
    self.item = item;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:0 target:self action:@selector(rightBarItemClick:)];
    
    self.editContentView = [[UIScrollView alloc] init];
    self.editContentView.delegate = self;
    self.editContentView.showsVerticalScrollIndicator = NO;
    self.editContentView.frame = self.view.bounds;
    [self.view addSubview:self.editContentView];
    
    //
    self.regexItemView = [[MM_EditItemView alloc] init];
    self.regexItemView.frame = (CGRect){
        0,20,
        CGRectGetWidth(self.editContentView.frame),
        65
    };
    [self.regexItemView configText:@"匹配规则"
                           content:self.item.regex];
    [self.editContentView addSubview:self.regexItemView];
    
    //
    self.replyItemView = [[MM_EditItemView alloc] init];
    self.replyItemView.frame = (CGRect){
        0,CGRectGetMaxY(self.regexItemView.frame) + 10,
        CGRectGetWidth(self.editContentView.frame),
        150
    };
    [self.replyItemView configText:@"自动回复的内容"
                           content:self.item.reply];
    [self.editContentView addSubview:self.replyItemView];
    self.editContentView.contentSize = (CGSize){
        self.editContentView.frame.size.width,
        MAX(CGRectGetMaxY(self.replyItemView.frame), CGRectGetMaxY(self.editContentView.frame)) - 63
    };
    
    if (self.item) {
        [self.regexItemView.contentView becomeFirstResponder];
        self.navigationItem.rightBarButtonItem.title = @"Save";
    }
}

- (void) rightBarItemClick:(UIBarButtonItem *)barItem{
    
    if (self.regexItemView.contentView.text.length && self.replyItemView.contentView.text.length) {
        
        MM_AutoReplyItem * item;
        if (self.item) {
            item = self.item;
            item.regex = self.regexItemView.contentView.text;
            item.reply = self.replyItemView.contentView.text;
            [MM_PlistMgr mm_updateItem:item];
        }else{
            item = [[MM_AutoReplyItem alloc] init];
            item.regex = self.regexItemView.contentView.text;
            item.reply = self.replyItemView.contentView.text;
            item.createTime = [NSDate date];
            [MM_PlistMgr mm_addOneItem:item];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAutoReplyAddItemDone:)]) {
            [self.delegate onAutoReplyAddItemDone:item];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        NSLog(@"请输入有效的信息");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate M

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}
@end

@implementation MM_PlistMgr

+ (NSString *) mm_path{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"MM_AutoReplyDataBase.plist"];;
}

+ (NSArray *) mm_loadData{

    if (![self mm_path]) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:[self mm_path] contents:nil attributes:nil];
        return [NSMutableArray array];
    }
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:[self mm_path]];
    return [array copy];
}

+ (BOOL) mm_updateItem:(MM_AutoReplyItem *)item{

    if (item) {
        
        NSMutableArray * array = [NSMutableArray arrayWithArray:[self mm_loadData]];
        
        NSInteger index = 0;
        BOOL have = NO;
        for (NSData *dataRecord in array) {
            
            MM_AutoReplyItem * item_ = [NSKeyedUnarchiver unarchiveObjectWithData:dataRecord];
            if ([item.createTime isEqualToDate:item_.createTime]) {
                have = YES;
                break;
            }
            index ++;
        }
        if (have && index < array.count) {
            [array replaceObjectAtIndex:index withObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
            return [array writeToFile:[self mm_path] atomically:YES];
        }
    }
    return NO;
}

+ (BOOL) mm_addOneItem:(MM_AutoReplyItem *)item{

    if (item) {
        
        NSMutableArray * array = [NSMutableArray arrayWithArray:[self mm_loadData]];
        [array addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
        return [array writeToFile:[self mm_path] atomically:YES];
    }
    return NO;
}

+ (BOOL) mm_deleteItem:(MM_AutoReplyItem *)item{

    if (item ) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:[self mm_loadData]];
        for (NSData * dataRecord in array) {
            MM_AutoReplyItem * item_ = [NSKeyedUnarchiver unarchiveObjectWithData:dataRecord];
            if ([item_.createTime isEqualToDate:item.createTime]) {
                [array removeObject:dataRecord];
                return [array writeToFile:[self mm_path] atomically:YES];
            }
        }
    }
    return NO;
}

@end
