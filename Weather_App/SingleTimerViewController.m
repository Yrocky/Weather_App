//
//  SingleTimerViewController.m
//  Weather_App
//
//  Created by rocky on 2021/1/18.
//  Copyright © 2021 Yrocky. All rights reserved.
//

#import "SingleTimerViewController.h"
#import "SingleTimer.h"
#import "UIColor+Common.h"
#import <Masonry/Masonry.h>
#import "XXXBasePopupView.h"

@interface ExampleTimerObj : NSObject
@property (nonatomic ,assign) NSInteger counter;
+ (instancetype) obj:(NSInteger)counter;
@end

@interface ExampleTableViewCell : UITableViewCell
- (void) setupWith:(ExampleTimerObj *)obj;
- (void) onTimer;
@end
@class SubComponentView;
@protocol SubComponentViewDelegate <NSObject>

- (void) subCompoenentView:(SubComponentView *)view shouldBecomeTimerObserver:(BOOL)become;
@end

@interface SubComponentView : XXXBasePopupView<TimerObserver>
@property (nonatomic ,weak) id<SubComponentViewDelegate> delegate;
@end

@interface SingleTimerViewController ()<
TimerObserver,
SubComponentViewDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic ,strong) SingleTimer * timer;
@property (nonatomic ,assign) NSInteger counter;
@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,copy) NSArray<ExampleTimerObj *> * dataSource;
@end

@implementation SingleTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[
        [ExampleTimerObj obj:100],[ExampleTimerObj obj:60],
        [ExampleTimerObj obj:120],[ExampleTimerObj obj:30],
        [ExampleTimerObj obj:130],[ExampleTimerObj obj:80],
        [ExampleTimerObj obj:140],[ExampleTimerObj obj:90],
        [ExampleTimerObj obj:150],[ExampleTimerObj obj:20],
        [ExampleTimerObj obj:180],[ExampleTimerObj obj:120],
        [ExampleTimerObj obj:190],[ExampleTimerObj obj:50],
        [ExampleTimerObj obj:170],[ExampleTimerObj obj:70],
        [ExampleTimerObj obj:160],[ExampleTimerObj obj:90],
        [ExampleTimerObj obj:110],[ExampleTimerObj obj:100],
    ];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:ExampleTableViewCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(self.view).multipliedBy(0.6);
    }];
    
    self.displayLabel = [UILabel new];
    [self.view addSubview:self.displayLabel];
    self.displayLabel.font = [UIFont systemFontOfSize:40];
    self.displayLabel.textColor = [UIColor colorWithHexString:@"#D4666C"];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    self.counter = 0;
    
    self.timer = [[SingleTimer alloc] initWithInterval:1];
    [self.timer addTimerObserver:self];
    
    {
        UIButton * button = [UIButton new];
        [button addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.equalTo(self.displayLabel.mas_left);
            make.centerY.equalTo(self.displayLabel);
        }];
    }
    {
        UIButton * button = [UIButton new];
        [button addTarget:self action:@selector(onShow) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Show" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.equalTo(self.displayLabel.mas_right);
            make.centerY.equalTo(self.displayLabel);
        }];
    }
}

- (void) onAdd{
    [self.timer addTimerObserver:self];
}

- (void) onShow {
    SubComponentView * view = [SubComponentView new];
    view.delegate = self;
    [view showIn:self.view];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExampleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setupWith:self.dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

#pragma mark - SubComponentViewDelegate

- (void) subCompoenentView:(SubComponentView *)view shouldBecomeTimerObserver:(BOOL)become{
    if (become) {
        [self.timer addTimerObserver:view];
    } else {
        [self.timer removeTimerObserver:view];
    }
}

#pragma mark - TimerObserver

- (NSString *)uniqueId{
    return @"dfsggfg";
}

- (void)onTimer{
    self.counter ++;
    for (ExampleTimerObj * obj in self.dataSource) {
        obj.counter --;
    }
    for (ExampleTableViewCell * cell in [self.tableView visibleCells]) {
        [cell onTimer];
    }
}

- (void)setCounter:(NSInteger)counter{
    _counter = counter;
    self.displayLabel.text = [NSString stringWithFormat:@"%ld",(long)counter];
}
@end

@implementation SubComponentView{
    UILabel * _textLabel;
    NSInteger _counter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubContentView];
    }
    return self;
}

- (void)addSubContentView{
    [super addSubContentView];
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont systemFontOfSize:50];
    _textLabel.textColor = [UIColor colorWithHexString:@"#6AA97D"];
    [self.contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.center.equalTo(self.contentView);
    }];
    
    UISwitch * toggle = [[UISwitch alloc] init];
    [toggle addTarget:self action:@selector(onToggle:)
     forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:toggle];
    [toggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).mas_offset(30);
    }];
}

- (void) onToggle:(UISwitch *)toggle{

    if ([self.delegate respondsToSelector:@selector(subCompoenentView:shouldBecomeTimerObserver:)]) {
        [self.delegate subCompoenentView:self shouldBecomeTimerObserver:toggle.isOn];
    }
}

- (XXXPopupMaskColorType)touchMaskViewColorType{
    return XXXPopupMaskColorBlack;
}

- (CGFloat) contentViewFixedHeight{
    return 300;
}

#pragma mark - TimerObserver

- (NSString *)uniqueId{
    return @"dfsggfgsdge";
}

- (void)onTimer{
    _counter += 1;
    _textLabel.text = [NSString stringWithFormat:@"%ld",(long)_counter];
}
@end

@implementation ExampleTableViewCell{
    UILabel * _counterLabel;
    NSInteger _index;
    ExampleTimerObj * _obj;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _counterLabel = [UILabel new];
        _counterLabel.textColor = [UIColor colorWithHexString:@"#6AA97D"];
        _counterLabel.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:_counterLabel];
        [_counterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (void) setupWith:(ExampleTimerObj *)obj{
    _obj = obj;
    [self _setup:obj];
}

- (void) _setup:(ExampleTimerObj *)obj{
    if (_obj.counter <= 0) {
        _counterLabel.text = @"Finished";
    } else {
        _counterLabel.text = [NSString stringWithFormat:@"%ld",(long)_obj.counter];
    }
}

- (void)onTimer{
    [self _setup:_obj];
}
@end

@implementation ExampleTimerObj
+ (instancetype) obj:(NSInteger)counter{
    ExampleTimerObj * obj = [ExampleTimerObj new];
    obj.counter = 120;
    return obj;;
}
@end
