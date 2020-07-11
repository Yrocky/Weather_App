//
//  ALBookDemoViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2018/12/3.
//  Copyright © 2018 Yrocky. All rights reserved.
//

#import "ALBookDemoViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "MMConversation.h"
#import "UIView+AutoLayoutSupport.h"
#import "NSArray+Sugar.h"

@interface ALDebugView : UIView
@property (nonatomic ,copy) NSString * name;
@end

@implementation ALDebugView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}
+ (instancetype) debugView:(NSString *)name{
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.name = name;
    }
    return self;
}
- (void) addBorderLine{
    UIColor * color = [UIColor randomColor];
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
}
- (void)setName:(NSString *)name{
    _name = name;
    self.mas_key = name;
    self.restorationIdentifier = name;
}

@end

@interface ALShadowView : UIImageView
@end

@implementation ALShadowView

- (instancetype)initWithImage:(nullable UIImage *)image{
    
    self = [super initWithImage:image];
    if (self) {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = false;
//        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
//        self.layer.borderColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5].CGColor;
    }
    return self;
}

///<一般在使用一个有阴影或者有装饰的image的时候，这些装饰没有在布局的时候被考虑进去，就会导致
- (UIEdgeInsets)alignmentRectInsets{
//    CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return UIEdgeInsetsMake(0, 0, -3, 3);// 如果设置了size为{100,40},最后呈现的尺寸为{103,37},也就是说{width+left+right, height+top+bottom}
//    return UIEdgeInsetsMake(0, 0, 3, 3);
}

@end

@interface ALBookDemoViewController ()

@property (nonatomic ,strong) UIImageView * imageView;
@property (nonatomic ,strong) UILabel * label;
@property (nonatomic ,strong) ALDebugView * oneView;
@end

@implementation ALBookDemoViewController

- (void)loadView{
    [super loadView];
//    self.view = [ALDebugView debugView:@"self.view"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self nonatomicNoneCrashMethod];
//    [self nonatomicCarshMethod];
//    [self atomicNoneCrashMethod];
    
    [self layout];
    return;
    {
        self.oneView = [ALDebugView debugView:@"oneView"];
        [self.view addSubview:self.oneView];
        [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_offset(0);
            make.height.mas_equalTo(self.oneView.mas_width);
            make.right.mas_offset(-20).priorityLow();
        }];
    }
    if (0){
        self.label = [UILabel new];
        self.label.text = @"sfsdfsdfsfsdfsdfsdfsdfsdfsddsfsdsdsdsfsdfsdfsfsdfsdfsdfsdfsdfsddsfsdsdsdsfsdfsdfsfsdfsdfsdfsdfsdfsddsfsdsdsdsfsdfsdfsfsdfsdfsdfsdfsdfsddsfsdsdsd";
        self.label.textColor = [UIColor orangeColor];
        self.label.numberOfLines = 0;
        self.label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(200);
        }];
        
        ALDebugView * bottomView = [ALDebugView debugView:@"topView"];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.label.mas_bottom);
            make.left.equalTo(self.label.mas_left);
        }];
        
        self.oneView = [ALDebugView debugView:@"oneView"];
        [self.view addSubview:self.oneView];
        [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_offset(0);
            make.height.mas_equalTo(self.oneView.mas_width);
            make.right.mas_equalTo(self.view.mas_centerX).mas_offset(0);
        }];
        NSLog(@"self.label.constraints:%@",self.label.constraints);
        NSLog(@"self.view.constraints:%@",self.view.constraints);
    }
    
    if(0){
        ALDebugView * leftView = [ALDebugView debugView:@"leftView"];
        [self.view addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(100);
            make.top.equalTo(self.view).mas_offset(100);
        }];
        
        ALDebugView * topView = [ALDebugView debugView:@"topView"];
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(leftView.mas_top);
            make.left.equalTo(leftView.mas_right);
        }];
        
//        ALDebugView * fakeOneView = [ALDebugView debugView:@"fakeView"];
//        [fakeOneView addBorderLine];
//        [self.view addSubview:fakeOneView];
//        [fakeOneView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(leftView.mas_right).mas_offset(10);
//            make.top.mas_equalTo(topView.mas_bottom).mas_offset(10);
//            make.right.mas_equalTo(self.view).mas_offset(-10);
//            make.height.mas_equalTo(fakeOneView.mas_width);
//        }];
        
        self.oneView = [ALDebugView debugView:@"oneView"];
        [self.view addSubview:self.oneView];
        [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).mas_offset(10);
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.view).mas_offset(-10);
            make.height.mas_equalTo(self.oneView.mas_width);
        }];
    }
    if (0) {
        
        ALDebugView * leftView = [ALDebugView debugView:@"leftView"];
        [self.view addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(100);
            make.top.equalTo(self.view).mas_offset(100);
        }];
        
        ALDebugView * topView = [ALDebugView debugView:@"topView"];
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(leftView.mas_top);
            make.left.equalTo(leftView.mas_right);
        }];
        
        ALDebugView * fakeOneView = [ALDebugView debugView:@"fakeView"];
        [fakeOneView addBorderLine];
        [self.view addSubview:fakeOneView];
        [fakeOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).mas_offset(10);
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(100);
        }];
        
        self.oneView = [ALDebugView debugView:@"oneView"];
        [self.view addSubview:self.oneView];
        [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).mas_offset(10);
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(100);
        }];
        
        ALDebugView * rightView = [ALDebugView debugView:@"rightView"];
        [self.view addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.oneView.mas_right).mas_offset(10);
            make.bottom.equalTo(self.oneView);
        }];
        
        ALDebugView * bottomView = [ALDebugView debugView:@"bottomView"];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.oneView.mas_bottom).mas_offset(10);
            make.right.equalTo(self.oneView);
        }];
        
        NSLog(@"oneView.constraints:%@",self.oneView.constraints);///<视图到目前为止所有的约束
        NSLog(@"self.view.constraints:%@",self.view.constraints);
        
        ///<这个谓词在这里是针对与数组中的元素来说的，
        ///<由于constraints内部装的是`NSLayoutConstraint`类，
        ///<因此可以使用这个类的某些属性以及对应的值来进行filter
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeLeft];
        
        [[self.view.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *obj) {
            NSLog(@"\n  filter obj:%@",obj);
        }];
        
        predicate = [NSPredicate predicateWithFormat:@"secondItem = %@ && secondAttribute = %d && class == %@", self.oneView, NSLayoutAttributeRight,[NSLayoutConstraint class]];
        [[self.view.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *obj) {
            NSLog(@"\n  filter right obj:%@",obj);
        }];
        ///<这里有个问题，那就是与oneView有关的约束有12个，胆其中只有4个是以oneView为firstItem，也就是说其余的8个都是依赖于oneView的约束，那么，是否需要将secondItem也为oneView的约束也找出来然后进行修改`constant`呢？大可不必，因为按照Auto Layout的特性，如果修改了以oneView为firstItem的4个约束，其余依赖于它的视图就会按照依赖条件改变位置
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button setTitle:@"Hide" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onHideAction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
//        make.centerY.equalTo(self.view);
        make.top.mas_equalTo(self.oneView.mas_bottom).mas_offset(50);
        make.right.equalTo(self.view.mas_centerX).mas_offset(-10);
    }];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onShowAction)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.mas_equalTo(self.oneView.mas_bottom).mas_offset(50);
        make.left.equalTo(self.view.mas_centerX).mas_offset(10);
    }];
    
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
}

- (void) onHideAction{
    NSLog(@"oneView.constraints:%@",self.oneView.constraints);

    [UIView animateWithDuration:3 animations:^{
//        [self.oneView ADKHide];
//        [self.oneView ADKHideRightConstraint];
//        [self.oneView ADKUnhideViewWidth];
//        [self.oneView ADKHideBottomConstraint];
//        [self.oneView ADKHideRightConstraint];
        [self.oneView ADKHideLeftConstraint];
//        [self.label ADKHideViewHeight];
        
//        [self.label ADKHideLeftConstraint];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        NSLog(@"self.view.constraints:%@",self.view.constraints);
        NSLog(@"self.oneView.constraints:%@",self.oneView.constraints);
        NSLog(@"self.label.constraints:%@",self.label.constraints);
    }];
}

- (void) onShowAction{
    
    {
        NSLog(@"self.view.constraints:%@",self.view.constraints);
        NSLog(@"self.oneView.constraints:%@",self.oneView.constraints);
        [UIView animateWithDuration:3 animations:^{
            
            //crash:Mutating a priority from required to not on an installed constraint (or vice-versa) is not supported.  You passed priority 250 and the existing priority was 1000.
//            [self.oneView ADKConstraintForAttribute:NSLayoutAttributeRight].priority = UILayoutPriorityDefaultLow;
//            [self.oneView ADKHideViewWidth];
            [self.oneView ADKUnhideLeftConstraint];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            NSLog(@"self.view.constraints:%@",self.view.constraints);
            NSLog(@"self.oneView.constraints:%@",self.oneView.constraints);
        }];
    }
    if(0){
        [UIView animateWithDuration:3 animations:^{
            //        [self.oneView ADKShow];
            [self.oneView ADKUnhideViewWidth];
            //        [self.oneView ADKUnhideLeftConstraint];
            //        [self.label ADKUnhideViewHeight];
            //        [self.label ADKUnhideLeftConstraint];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            NSLog(@"after show action");
            NSLog(@"label.constraints:%@",self.label.constraints);
            NSLog(@"self.oneView.constraints:%@",self.oneView.constraints);
            NSLog(@"self.view.constraints:%@",self.view.constraints);
        }];
    }
    if(0){
        
        //    [self.oneView ADKHideView:YES withConstraints:ADKLayoutAttributeWidth];
        [UIView animateWithDuration:3 animations:^{
            //        [self.oneView ADKHideView:YES withConstraints:ADKLayoutAttributeWidth];
            //        [self.oneView ADKHideLeftConstraint];
            //        [self.oneView ADKHideViewHeight];
            //        [self.oneView ADKHideTopConstraint];
            
            ///<先不使用分类里面的方法来完成一个约束的修改，先通过获取约束，然后修改数值看能不能达到想要的效果
            ///<将oneView的width约束置为0
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeWidth];
            [[self.oneView.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                //            constraint.constant = 0.0f;
            }];
            
            ///<如果想要将oneView的left约束置为0，就需要通过他的父视图来查找对应的约束
            predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeLeft];
            [[self.view.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                //            constraint.constant = 0.0f;
            }];
            
            ///<这样修改之后，就不可以将约束进行复原，因此一个策略是使用一个变量在视图的生命周期中进行缓存修改之前的值，可以使用一个私有对象来完成这个任务，这个类中提供可以决定一个视图最终位置的几个约束属性：left、right、top、bottom、width、height、leading、training，他们都是CGFloat类型的，用来缓存约束(NSLayoutConstraint)的数值(constant)，
            
            ///<这样根据`NSLayoutAttribute`来获取约束，然后修改约束的值的流程只能一次修改一个约束，因为NSLayoutAttribute枚举不支持与或操作，
            {
                //            [self.oneView ADKHide];
            }
            if (1){
                ///<从上面的例子可以看出来，通过修改约束的constant数值可以完成`隐藏一个视图之后其余依赖视图进行填补位置`的任务，这里模拟一下隐藏oneView，然后其余视图填补他的位置
                predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeWidth];
                [[self.oneView.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                    constraint.constant = 0.0f;
                }];
                predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeHeight];
                [[self.oneView.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                    constraint.constant = 0.0f;
                }];
                predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeLeft];
                [[self.view.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                    constraint.constant = 0.0f;
                }];
                predicate = [NSPredicate predicateWithFormat:@"firstItem = %@ && firstAttribute = %d",self.oneView,NSLayoutAttributeTop];
                [[self.view.constraints filteredArrayUsingPredicate:predicate] mm_each:^(__kindof NSLayoutConstraint *constraint) {
                    constraint.constant = 0.0f;
                }];
                
                //            oneView.left == ALDebugView:leftView.right + 10>",
                //            oneView.top == ALDebugView:topView.bottom + 10>",
                
                //            oneView.left == ALDebugView:leftView.right>",
                //            oneView.top == ALDebugView:topView.bottom>",
            }
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            NSLog(@"after hide width and height constraint");
            NSLog(@"oneView.constraints:%@",self.oneView.constraints);///<视图到目前为止所有的约束
            NSLog(@"self.view.constraints:%@",self.view.constraints);
        }];
    }
}

- (void) layout{
    UIImage * tenShadowImage = [UIImage imageNamed:@"bill_three_shadow"];
    
    ALShadowView * tenShadowView = [[ALShadowView alloc] initWithImage:tenShadowImage];
    [self.view addSubview:tenShadowView];
    [tenShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    UIImageView * tenShadowImageView = [[UIImageView alloc] initWithImage:tenShadowImage];
    tenShadowImageView.backgroundColor = tenShadowView.backgroundColor;
    tenShadowImageView.contentMode = UIViewContentModeScaleAspectFill;
    tenShadowImageView.clipsToBounds = 1;
    [self.view addSubview:tenShadowImageView];
    [tenShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(tenShadowView);
        make.top.mas_equalTo(tenShadowView.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    
    
    ALDebugView * leftView = [ALDebugView new];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(tenShadowView.mas_left);
        make.bottom.height.equalTo(tenShadowView);
    }];
    ALDebugView * rightView = [ALDebugView new];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(tenShadowView.mas_right).mas_offset(tenShadowView.alignmentRectInsets.right);
        make.bottom.height.equalTo(tenShadowView);
    }];
    ALDebugView * topView = [ALDebugView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(tenShadowView.mas_top).mas_offset(-tenShadowView.alignmentRectInsets.top);
        make.left.right.equalTo(tenShadowView);
    }];
    
    ///<自动布局不可以实现基于等分的约束设置
    ALDebugView * oneView = [ALDebugView new];
    [self.view addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        //        make.centerX.mas_equalTo(self.view.mas_width).multipliedBy(0.25);
        make.centerY.mas_equalTo(self.view);
    }];
}
#pragma mark - 单向数据流

- (void) nonatomicCarshMethod{
    MMConversation * model = [MMConversation new];

    ///这里为什么使用while之后就会导致崩溃？
    ///使用while就是表示会一直调用这个属性，因为异步多线程不确定执行的时机，
    ///所以这里是模拟了一个同时访问一个属性
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            model.messages = @[@"1",@"2"];
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            NSLog(@"%@",model.messages);
        }
    });
}

- (void) nonatomicNoneCrashMethod{
    MMConversation * model = [MMConversation new];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        model.messages = @[@"1",@"2"];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",model.messages);
    });
}

- (void) atomicNoneCrashMethod{
    MMConversation * model = [MMConversation new];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            model.names = @[@"1",@"2"];
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            NSLog(@"%@",model.names);
        }
    });
}
@end
