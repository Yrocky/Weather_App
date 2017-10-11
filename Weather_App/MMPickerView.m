//
//  MMPickerView.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/9.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMPickerView.h"

#define kToolBarHeight  44
#define kPickerViewHeight  250

@interface MMPickerViewConfig ()

@property (nonatomic ,copy) NSUInteger (^defaultSelect)(NSUInteger);
@property (nonatomic ,copy) NSArray * (^rowDataAtColumn)(NSUInteger);
@property (nonatomic ,copy) void (^updateData)(NSUInteger, NSUInteger, id);
@property (nonatomic ,copy) NSArray * (^origRowDataAtColumn)(NSUInteger);
@end
@implementation MMPickerViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUInteger (^defaultCallback)(NSUInteger) = ^ NSUInteger (NSUInteger column){
            return 0;
        };
        self.defaultSelect = defaultCallback;
    }
    return self;
}
- (void)defaultSelect:(NSUInteger (^)(NSUInteger))callback{
    
    if (callback) {
        self.defaultSelect = callback;
    }
}

- (void) configRowAt:(NSArray <NSString *>*(^)(NSUInteger))callBack{
    
    if (callBack) {
        [self configRowAt:callBack displayText:nil];
    }
}

- (void) configRowAt:(NSArray <id>*(^)(NSUInteger))callBack displayText:(NSString *(^)(id,NSUInteger))callBack2{
    
    NSArray * (^rowDataAtColumn)(NSUInteger) = ^ NSArray *(NSUInteger column){
        
        NSArray * columnDataArray = callBack(column);
        NSMutableArray * datas = [NSMutableArray arrayWithCapacity:columnDataArray.count];
        [columnDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * displayText = callBack2(obj,column);
            if (displayText) {
                [datas addObject:displayText];
            }
        }];
        return [datas copy];
    };
    self.rowDataAtColumn = callBack2 ? rowDataAtColumn : callBack;
    self.origRowDataAtColumn = callBack;
}

- (void)monitorSelect:(void (^)(NSUInteger, NSUInteger, id))callback{
    
    if (callback) {
        self.updateData = callback;
    }
}
@end

@implementation MMDatePickerViewConfig
@end

@implementation MMPickerViewInterface

+ (instancetype _Nullable ) interface{
    
    MMPickerViewInterface * i = [[MMPickerViewInterface alloc] init];
    i.bgColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    i.title = @"";
    i.titleFont = [UIFont systemFontOfSize:14];
    i.titleColor = [UIColor grayColor];
    i.cancelText = @"取消";
    i.cancelTextColor = [UIColor blackColor];
    i.cancelTextFont = [UIFont systemFontOfSize:15];
    i.doneText = @"确定";
    i.doneTextColor = [UIColor blackColor];
    i.doneTextFont = [UIFont systemFontOfSize:15];
    return i;
}
@end

@interface _MMPickerViewToolBar : UIView

@property (nonatomic ,strong) UIView * lineView;
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UIButton * cancelButton;
@property (nonatomic ,strong) UIButton * doneButton;
@end

@implementation _MMPickerViewToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.doneButton];
        
        [self _setupAutoLayout];
    }
    return self;
}

- (void) _setupAutoLayout{
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1/[UIScreen mainScreen].scale]];
    
}

@end

@interface MMPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,CAAnimationDelegate>

@property (nonatomic ,strong) UIView * bgView;
@property (nonatomic ,strong) UIToolbar * toolBar;
@property (strong, nonatomic) IBOutlet UIPickerView *commonPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic ,strong ,readwrite) MMPickerViewConfig * config;

@end

@implementation MMPickerView

- (void)dealloc{
    
    NSLog(@"MMSportRulePickView dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        
        //
        self.bgView = [[UIView alloc] initWithFrame:frame];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonHandle)];
        tap.numberOfTapsRequired = 1;
        [self.bgView addGestureRecognizer:tap];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        //
        self.toolBar = [[UIToolbar alloc] initWithFrame:(CGRect){
            0,frame.size.height - kToolBarHeight - kPickerViewHeight,
            frame.size.width,kToolBarHeight
        }];
        self.toolBar.barStyle = UIBarStyleDefault;
        [self addSubview:self.toolBar];
        
        UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonHandle)];
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"确定    " style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonHandle)];
        UIBarButtonItem * flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolBar.items = @[cancel,flexible,done];
    }
    return self;
}
- (instancetype)initWithConfig:(MMPickerViewConfig *)config{
    
    self = [self init];
    if (self) {
        
        config.pickerView = self;
        self.config = config;
        
        //
        self.commonPickerView = [[UIPickerView alloc] initWithFrame:(CGRect){
            0,CGRectGetMaxY(self.toolBar.frame),
            CGRectGetWidth(self.toolBar.frame),kPickerViewHeight
        }];
        self.commonPickerView.backgroundColor = [UIColor whiteColor];
        self.commonPickerView.delegate = self;
        self.commonPickerView.dataSource = self;
        [self addSubview:self.commonPickerView];
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
    
    [self dismiss];
    if ([self.config isKindOfClass:[MMDatePickerViewConfig class]]) {
        ((MMDatePickerViewConfig *)self.config).date = self.datePickerView.date;
    }
    if (self.bCancelAction) {
        self.bCancelAction(self);
    }
}

- (void) sureButtonHandle{
    
    [self dismiss];
    if ([self.config isKindOfClass:[MMDatePickerViewConfig class]]) {
        ((MMDatePickerViewConfig *)self.config).date = self.datePickerView.date;
    }
    if (self.bDoneAction) {
        self.bDoneAction(self);
    }
}

#pragma mark - API M

- (void)setupInterface:(MMPickerViewInterface *)interface{
    
    
}

- (void)update{
    
    [self.commonPickerView reloadAllComponents];
}

- (void) updateColumn:(NSUInteger)column{
    
    [self.commonPickerView reloadComponent:column];
    [self.commonPickerView selectRow:0 inComponent:column animated:YES];
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
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
@end
