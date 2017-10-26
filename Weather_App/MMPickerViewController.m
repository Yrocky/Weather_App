//
//  MMPickerViewController.m
//  Weather_App
//
//  Created by user1 on 2017/10/20.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMPickerViewController.h"

#define kToolBarHeight  44
#define kPickerViewHeight  250

@interface MMPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,CAAnimationDelegate>

@property (nonatomic ,strong) UIView * bgView;
@property (nonatomic ,strong) UIToolbar * toolBar;
@property (strong, nonatomic) IBOutlet UIPickerView *commonPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic ,strong ,readwrite) MMPickerViewConfig * config;


@end

@implementation MMPickerViewController

- (void)dealloc{
    
    NSLog(@"MMPickerView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect frame = [UIScreen mainScreen].bounds;
//        self.frame = frame;
        
        //
        self.bgView = [[UIView alloc] initWithFrame:frame];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonHandle)];
        tap.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:tap];
        self.view.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.bgView];
        
        //
        self.toolBar = [[UIToolbar alloc] initWithFrame:(CGRect){
            0,frame.size.height - kToolBarHeight - kPickerViewHeight,
            frame.size.width,kToolBarHeight
        }];
        self.toolBar.barStyle = UIBarStyleDefault;
        [self.view addSubview:self.toolBar];
        
        UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithCustomView:[self buttonView:@"    取消" action:@selector(cancelButtonHandle)]];
        
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithCustomView:[self buttonView:@"确定    " action:@selector(sureButtonHandle)]];
        
        UIBarButtonItem * title = [[UIBarButtonItem alloc] initWithCustomView:[self titleView:@""]];
        
        UIBarButtonItem * flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolBar.items = @[cancel,flexible,title,flexible,done];
    }
    return self;
}

- (UIView *) titleView:(NSString *)text{
    
    UILabel * l = [UILabel new];
    l.textColor = [UIColor lightGrayColor];
    l.font = [UIFont systemFontOfSize:13];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = text;
    return l;
}
- (UIView *) buttonView:(NSString *)text action:(SEL)action{
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:15];
    [b setTitle:text forState:UIControlStateNormal];
    [b addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return b;
}
- (instancetype)initWithConfig:(MMPickerViewConfig *)config{
    
    self = [self init];
    if (self) {
        
//        config.pickerView = self;
        self.config = config;
        
        //
        self.commonPickerView = [[UIPickerView alloc] initWithFrame:(CGRect){
            0,CGRectGetMaxY(self.toolBar.frame),
            CGRectGetWidth(self.toolBar.frame),kPickerViewHeight
        }];
        self.commonPickerView.backgroundColor = [UIColor whiteColor];
        self.commonPickerView.delegate = self;
        self.commonPickerView.dataSource = self;
        [self.view addSubview:self.commonPickerView];
    }
    return self;
}

- (instancetype)initWithDatePickerConfig:(MMDatePickerViewConfig *)config{
    
    self = [self init];
    if (self) {
        
        config.pickerView = self;
        self.config = config;
        
        //
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:(CGRect){
            0,CGRectGetMaxY(self.toolBar.frame),
            CGRectGetWidth(self.toolBar.frame),kPickerViewHeight
        }];
        self.datePickerView.backgroundColor = [UIColor whiteColor];
        self.datePickerView.datePickerMode = config.datePickerMode;
        self.datePickerView.countDownDuration = config.countDownDuration;
        self.datePickerView.date = config.date ? config.date : [NSDate date];
        self.datePickerView.minimumDate = config.minimumDate ;
        self.datePickerView.maximumDate = config.maximumDate ;
        [self addSubview:self.datePickerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.config.rowDataAtColumn(component).count;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return self.config.columns;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.config.rowDataAtColumn(component)[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.config.updateData && self.config.origRowDataAtColumn) {
        self.config.updateData(component, row, self.config.origRowDataAtColumn(component)[row]);
    }
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel * cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:17];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    cityLabel.frame = CGRectMake(0, 0, screenWidth, 30);
    
    return cityLabel;
}

#pragma mark -
#pragma mark Action M

- (void) cancelButtonHandle{
    
    if ([self.config isKindOfClass:[MMDatePickerViewConfig class]]) {
        ((MMDatePickerViewConfig *)self.config).date = self.datePickerView.date;
    }
    __weak typeof(self) weakSelf = self;
    if (self.bCancelAction) {
        self.bCancelAction(weakSelf);
    }
    [self dismiss];
}

- (void) sureButtonHandle{
    
    if ([self.config isKindOfClass:[MMDatePickerViewConfig class]]) {
        ((MMDatePickerViewConfig *)self.config).date = self.datePickerView.date;
    }
    __weak typeof(self) weakSelf = self;
    if (self.bDoneAction) {
        self.bDoneAction(weakSelf);
    }
    [self dismiss];
}

#pragma mark - API M

- (void)setupInterface:(MMPickerViewInterface *)interface{
    
    self.toolBar.backgroundColor = interface.bgColor;
    
    UIButton * cancel = self.toolBar.items[0].customView;
    UILabel * title = self.toolBar.items[2].customView;
    UIButton * done = self.toolBar.items[4].customView;
    
    [cancel setTitle:[NSString stringWithFormat:@"    %@",interface.cancelText] forState:UIControlStateNormal];
    [cancel setTitleColor:interface.cancelTextColor forState:UIControlStateNormal];
    cancel.titleLabel.font = interface.cancelTextFont;
    
    [done setTitle:[NSString stringWithFormat:@"%@    ",interface.doneText] forState:UIControlStateNormal];
    [done setTitleColor:interface.doneTextColor forState:UIControlStateNormal];
    done.titleLabel.font = interface.doneTextFont;
    
    title.text = interface.title;
    title.textColor = interface.titleColor;
    title.font = interface.titleFont;
}

- (void)update{
    
    [self.commonPickerView reloadAllComponents];
}

- (void) updateColumn:(NSUInteger)column{
    
    [self.commonPickerView reloadComponent:column];
    [self.commonPickerView selectRow:0 inComponent:column animated:YES];
}

- (void)showIn:(UIView *)view{
    
    [view addSubview:self];
    
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, CGRectGetMaxY(self.superview.frame))];
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.center];
    
    CAAnimationGroup * animation = [CAAnimationGroup animation];
    animation.duration = 0.45;
    animation.animations = @[positionAnimation];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self.layer addAnimation:animation forKey:@"showAnimation"];
    
    for (NSUInteger column = 0; column < self.config.columns; column ++) {
        NSUInteger row = self.config.defaultSelect(column);
        [self.commonPickerView selectRow:row inComponent:column animated:YES];
        if (self.config.updateData && self.config.origRowDataAtColumn) {
            self.config.updateData(column, row, self.config.origRowDataAtColumn(column)[row]);
        }
    }
}
- (void)show{
    
    [self showIn:[UIApplication sharedApplication].keyWindow];
}

- (void)dismiss{
    
    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, CGRectGetMaxY(self.superview.frame))];
    
    CAAnimationGroup * animation = [CAAnimationGroup animation];
    animation.duration = 0.45;
    animation.animations = @[positionAnimation];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"dismissAnimation"];
}

#pragma mark - CAAnimationDelegate M

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
