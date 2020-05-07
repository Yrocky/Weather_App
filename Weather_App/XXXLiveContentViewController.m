//
//  XXXLiveContentViewController.m
//  Weather_App
//
//  Created by skynet on 2019/12/24.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "XXXLiveContentViewController.h"
#import "Masonry.h"
#import "MMDirectionGestureRecognizer.h"

@interface MASConstraintMaker ()
@property (nonatomic ,weak) MAS_VIEW * view;
@end

@interface XXXLiveContentView : UIView{
@private
    UIView * _internalContentView;
    UIView * _internaleSegmentView;
}

/// 恢复到默认状态，主要是contentOffset
- (void) reset;

/// 是否允许滑动
- (void) enableScroll:(BOOL)enable;

@end

@interface XXXLiveContentViewController ()
@property (nonatomic ,strong) UILabel * topView;
@property (nonatomic ,strong) XXXLiveContentView * contentView;
@end

@implementation XXXLiveContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [XXXLiveContentView new];
    [self.view addSubview:self.contentView];
    
    self.topView = [UILabel new];
    self.topView.text = @"sdfetw4y34wtgw4esff4w3rqw3r";
    self.topView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView.superview);
        make.top.equalTo(self.topView.superview);
        make.height.mas_equalTo(30);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.center.equalTo(self.view);
        make.height.mas_equalTo(300);
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

@interface XXXLiveContentView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,assign) BOOL showSegmentView;
@property (nonatomic ,strong) UIView * internalContentView;
@property (nonatomic ,strong) UIScrollView * internalScrollView;
@end

@implementation XXXLiveContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        //
        self.internalScrollView = [[UIScrollView alloc] init];
        self.internalScrollView.userInteractionEnabled = YES;
        self.internalScrollView.backgroundColor = [UIColor clearColor];
        self.internalScrollView.showsHorizontalScrollIndicator = NO;
        self.internalScrollView.showsVerticalScrollIndicator = NO;
        self.internalScrollView.pagingEnabled = YES;
        self.internalScrollView.bounces = NO;
        self.internalScrollView.tag = 20191220;
        self.internalScrollView.contentSize = CGSizeMake(screenWidth * 2, screenHeight);
        [self.internalScrollView setContentOffset:(CGPointMake(screenWidth, 0)) animated:NO];
        [self addSubview:self.internalScrollView];
        [self.internalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        //
        self.internalContentView = [UIView new];
        self.internalContentView.clipsToBounds = YES;
        self.internalContentView.backgroundColor = [UIColor greenColor];
        [self.internalScrollView addSubview:self.internalContentView];
        [self.internalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(self);
            make.left.mas_equalTo(screenWidth);
        }];
        
        _internaleSegmentView = [UIView new];
        _internaleSegmentView.backgroundColor = [UIColor orangeColor];
        
        MMDirectionGestureRecognizer * ges = [[MMDirectionGestureRecognizer alloc] initWithTarget:self action:@selector(onGesture:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
//               @weakify(self)
//               UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//                   @strongify(self)
//                   [self dismissKeybord];
//               }];
//               tap.delegate = self;
//               [_contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s",__func__);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"%s",__func__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s",__func__);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s",__func__);
}

#pragma mark - UIScrollViewDelegate

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(MMDirectionGestureRecognizer *)gestureRecognizer{
    
    return self.internalScrollView.contentOffset.x == self.internalScrollView.bounds.size.width;
}

- (void) onGesture:(MMDirectionGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat offset = gesture.offset;
        NSString * direction = @"";
        if (gesture.direction == MMDirectionGestureRecognizerUp) {
            direction = @"up";
            
        }
        if (gesture.direction == MMDirectionGestureRecognizerDown) {
            direction = @"down";
        }
        if (gesture.direction == MMDirectionGestureRecognizerLeft) {
            direction = @"left";
            
        }
        if (gesture.direction == MMDirectionGestureRecognizerRight) {
            direction = @"right";
        }
        
        NSLog(@"direction：%@",direction);
    }else if(gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateFailed){
    }else{
    }
}

- (void) addSubview:(UIView *)view{
    
    if (view.tag == 20191220) {
        [super addSubview:view];
    } else {
        [self.internalContentView addSubview:view];
    }
}

- (void) reset{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self.internalScrollView setContentOffset:(CGPointMake(screenWidth, 0))
                                     animated:NO];
}

- (void) enableScroll:(BOOL)enable{
    self.internalScrollView.scrollEnabled = enable;
}

@end

