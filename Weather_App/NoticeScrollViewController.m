//
//  NoticeScrollViewController.m
//  Weather_App
//
//  Created by 洛奇 on 2019/5/23.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "NoticeScrollViewController.h"
#import "XXXNoticeScrollView.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "XXXAutoScrollImageView.h"
#import "XXXHomeModule.h"

@interface NoticeScrollViewController ()<XXXNoticeScrollViewDelegate>{
    NSInteger _addIndex;
    NSInteger _removeIndex;
    CGRect _origFrame;
}

@property (nonatomic ,strong) UILabel * oneView;
@property (nonatomic ,strong) UILabel * otherView;
@property (nonatomic ,strong) UILabel * thirdView;

@property (nonatomic ,strong) XXXNoticeScrollView * scrollView;
@end

@implementation NoticeScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<XXXHomeService> service = [[ALContext sharedContext] findService:@protocol(XXXHomeService)];
    [service doSomething];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oneView = [UILabel new];
    self.oneView.text = @"oneeeeeeeeeeeView";
    self.oneView.numberOfLines = 0;
    self.oneView.restorationIdentifier = @"1-oneView";
    self.oneView.backgroundColor = [UIColor redColor];
    
    self.otherView = [UILabel new];
    self.otherView.text = @"oooooooootherView";
    self.otherView.numberOfLines = 0;
    self.otherView.restorationIdentifier = @"2-otherView";
    self.otherView.backgroundColor = [UIColor orangeColor];
    
    self.thirdView = [UILabel new];
    self.thirdView.text = @"thrrrrrrrrrridView";
    self.thirdView.numberOfLines = 0;
    self.thirdView.restorationIdentifier = @"3-thridView";
    self.thirdView.backgroundColor = [UIColor purpleColor];
    
    UIButton * removeButton = [UIButton new];
    removeButton.backgroundColor = [UIColor redColor];
    [removeButton addTarget:self action:@selector(onRemove)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeButton];
    
    UIButton * addButton = [UIButton new];
    addButton.backgroundColor = [UIColor greenColor];
    [addButton addTarget:self action:@selector(onAdd)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.bottom.equalTo(self.view).mas_offset(-100);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(removeButton);
        make.top.equalTo(removeButton);
//        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_centerX).mas_offset(0);
    }];
    
    if (1){
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2.5];
        scrollView.delegate = self;
//        scrollView.canGestureScroll = YES;
//        scrollView.direction = XXXNoticeScrollDirectionHorizontal;
        [scrollView addContentViews:@[self.oneView,self.otherView,self.thirdView]];
//        [scrollView addContentView:self.oneView];
//        [scrollView addContentView:self.thirdView];
        self.scrollView = scrollView;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(300);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(20);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(20);
            }
        }];
    }
    if(0){
        UILabel * oneView = [UILabel new];
        oneView.restorationIdentifier = @"1-oneView";
        oneView.text = @"oneeeeeeeeeeeView";
        oneView.backgroundColor = [UIColor redColor];
        
        UILabel * otherView = [UILabel new];
        otherView.restorationIdentifier = @"2-otherView";
        otherView.text = @"oooooooootherView";
        otherView.backgroundColor = [UIColor orangeColor];
        
        UILabel * thirdView = [UILabel new];
        thirdView.restorationIdentifier = @"3-thridView";
        thirdView.text = @"thrrrrrrrrrridView";
        thirdView.backgroundColor = [UIColor purpleColor];
        
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2];
        scrollView.delegate = self;
        scrollView.duration = 2;
        scrollView.direction = XXXNoticeScrollDirectionVertical;
        [scrollView addContentViews:@[oneView,otherView,thirdView]];
        
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(120);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(120);
            }
        }];
    }
    if (0){
        UIView * oneView = [UIView new];
        oneView.restorationIdentifier = @"oneView";
        oneView.backgroundColor = [UIColor redColor];
        
        XXXNoticeScrollView * scrollView = [[XXXNoticeScrollView alloc] initWithTimeInterval:2];
        scrollView.delegate = self;
        scrollView.duration = 4;
//        scrollView.direction = XXXNoticeScrollDirectionHorizontal;
        [scrollView addContentViews:@[oneView]];
        
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(30);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(160);
            } else {
                make.top.equalTo(self.view.mas_top).mas_offset(160);
            }
        }];
    }
    
    {
        XXXAutoScrollImageView * scrollView = [[XXXAutoScrollImageView alloc] initWithDirection:XXXAutoScrollDirectionVertical];
        scrollView.layer.cornerRadius = 5;
        scrollView.layer.masksToBounds = YES;
        scrollView.duration = 20.0f;
//        [scrollView setupImage:@"sunset"];
        [scrollView setupImage:@"http://out8i00tg.bkt.clouddn.com/FpwfCXsZMGOWXKv6mj1PigOoDQU5"
                   placeholder:@"sunset"];
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(20);
            make.right.equalTo(self.view).mas_offset(-20);
            make.height.mas_equalTo(100);
            make.top.equalTo(self.view.mas_centerY);
        }];
    }
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(onPan:)];
//    [self.view addGestureRecognizer:pan];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _origFrame = self.scrollView.frame;
    
}
- (void) onPan:(UIPanGestureRecognizer *)gesture{
    
    CGFloat offset = 0.0f;
    CGFloat velocity = 0.0f;
    CGPoint movePoint = CGPointZero;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            movePoint = [gesture translationInView:gesture.view];
            offset = movePoint.y;
            
//            CGPoint location = [recognizer locationInView:self.view];
//
//            if (location.y < 0 || location.y > self.view.bounds.size.height) {
//                return;
//            }
//            CGPoint translation = [recognizer translationInView:self.view];
//
//            NSLog(@"当前视图在View的位置:%@----平移位置:%@",NSStringFromCGPoint(location),NSStringFromCGPoint(translation));
//            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
            [gesture setTranslation:CGPointZero inView:gesture.view];
            
            
            
//            if (self.direction == XXXNoticeScrollDirectionVertical) {
//                ///<正是向下，负是向上
//                velocity = [gesture velocityInView:gesture.view].y;
//            } else if (self.direction == XXXNoticeScrollDirectionHorizontal) {
//                ///<正是向右，负是向左
//                offset = movePoint.x;
//                velocity = [gesture velocityInView:gesture.view].x;
//            }
            [self changeContentViewWithGestureOffset:offset];
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
//            [self endChangeContentViewWithGestureOffset:offset velocity:velocity];
            break;
        default:
            break;
    }
}

- (void) changeContentViewWithGestureOffset:(CGFloat)offset{
    _origFrame.origin.y += offset;
    NSLog(@"[gesture] move offset:%f frame:%@",offset,NSStringFromCGRect(_origFrame));
    
    self.scrollView.frame = _origFrame;
}

- (void) onAdd{
    
    _removeIndex = 0;
    if (_addIndex == 0) {
        [self.scrollView addContentView:self.oneView];
    }
    if (_addIndex == 1) {
        [self.scrollView addContentView:self.otherView];
    }
    if (_addIndex == 2) {
        [self.scrollView addContentView:self.thirdView];
    }
    _addIndex ++;
}

- (void) onRemove{
    
    _addIndex = 0;
    if (_removeIndex == 0) {
        [self.scrollView removeContentView:self.oneView];
    }
    if (_removeIndex == 1) {
        [self.scrollView removeContentView:self.otherView];
    }
    if (_removeIndex == 2) {
        [self.scrollView removeContentView:self.thirdView];
    }
    _removeIndex ++;
}
#pragma mark - XXXNoticeScrollViewDelegate

- (void) noticeScrollView:(XXXNoticeScrollView *)view didSelected:(UIView *)contentView at:(NSInteger)index{
    NSLog(@"[Timer] didSelectedAt:%d",index);
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
