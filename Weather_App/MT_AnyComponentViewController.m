//
//  MT_AnyComponentViewController.m
//  Weather_App
//
//  Created by rocky on 2020/12/5.
//  Copyright © 2020 Yrocky. All rights reserved.
//

#import "MT_AnyComponentViewController.h"
#import "MT_AnyComponent.h"
#import "UIColor+Common.h"
#import <Masonry/Masonry.h>
#import "MMPickerView.h"
#import "NSArray+Sugar.h"

#import "MT_Renderer.h"
#import "MT_UITableViewAdapter.h"
#import "MT_UITableViewReloadDataUpdater.h"
#import "MT_ComponentHelper.h"

@interface DataForm : NSObject
@property (nonatomic ,copy) NSString * address;
@property (nonatomic ,copy) NSArray<NSString *> * addressOptions;
@property (nonatomic ,copy) NSString * payType;
@property (nonatomic ,copy) NSArray<NSString *> * goods;
@property (nonatomic ,assign) BOOL useInsurance;
@property (nonatomic ,copy) NSString * remark;

@property (nonatomic ,assign) BOOL isOpenAddress;
@end
// 地址
@interface Address : NSObject<MT_Component>{
    NSString *_address;
}
@property (class, readonly) Address *(^create)(NSString * address);
@end

@interface AddressPicker : NSObject<MT_Component>{
    NSArray<NSString *> * _addresses;
}
@property (class, readonly) AddressPicker *(^create)(NSArray<NSString *> * addresses);
@property (nonatomic ,copy) void(^bDidSelected)(NSString *address);

@end

// 支付方式
@interface Pay : NSObject<MT_Component>{
    NSString *_payType;
}
@property (class, readonly) Pay *(^create)(NSString * payType);
@end

// 商品信息
@interface Goods : NSObject<MT_Component>{
    NSString *_goodsInfo;
}
@property (class, readonly) Goods *(^create)(NSString * goodsInfo);
@end

// 准时宝
@interface Insurance : NSObject<MT_Component>{
    BOOL _use;
}
@property (class, readonly) Insurance *(^create)(BOOL use);
@property (nonatomic ,copy) void(^bToggle)(BOOL isOn);

@end

// 备注
@interface Remark : NSObject<MT_Component>{
    NSString * _remark;
}
@property (class, readonly) Remark *(^create)(NSString * remark);
@end

@interface MT_AnyComponentViewController ()
@property (nonatomic ,copy) NSArray * components;
@end

@interface MT_AnyComponentViewController ()
@property (nonatomic ,strong) UITableView * tableView;

// renderer
@property (nonatomic ,strong) MT_Renderer * renderer;

// dataForm
@property (nonatomic ,strong) DataForm * dataForm;
@end

@implementation MT_AnyComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectZero
                      style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = ({
        UIView * headerView = UIView.new;
        headerView.frame = CGRectMake(0, 0, 0, 0.01);
        headerView;
    });
    self.tableView.tableFooterView = ({
        UIView * footerView = UIView.new;
        footerView.frame = CGRectMake(0, 0, 0, 0.01);
        footerView;
    });
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior =
        UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    // dataForm
    self.dataForm = [DataForm new];
    self.dataForm.address = @"徐汇区";
    self.dataForm.addressOptions = @[
        @"黄浦区",@"徐汇区",
        @"闵行区",@"浦东区",
        @"松江区",@"宝山区"
    ];
    self.dataForm.payType = @"AliPay";
    self.dataForm.useInsurance = YES;
    self.dataForm.remark = @"your remark info";
    self.dataForm.goods = @[
        @"iPhone 6 256G red",
        @"iPhone 6s 256G red",
        @"iPhone 7 256G red",
        @"iPhone 7 Plus 256G red",
        @"iPhone 8 256G red",
        @"iPhone 8s 256G red",
        @"iPhone 8 Plus 256G red",
        @"iPhone XR 256G red",
        @"iPhone X 256G red",
        @"iPhone XS 256G red",
        @"iPhone XS Max 256G red",
        @"iPhone 11 256G red",
        @"iPhone 11 Pro 256G red",
        @"iPhone 11 Pro Max 256G red",
        @"iPhone 12 mini 256G red",
        @"iPhone 12 256G white",
        @"iPhone 12 Pro Max 256G black"
    ];

    
    // init
    self.renderer = [[MT_Renderer alloc] initWithAdaper:({
        MT_UITableViewAdapter * adapter =
        MT_UITableViewAdapter.new;
        [adapter setBDidSelect:^(MT_TableViewSelectionContext * _Nonnull context) {
            [context.tableView deselectRowAtIndexPath:context.indexPath animated:YES];
        }];
        adapter;
    }) updater:({
        MT_UITableViewReloadDataUpdater.new;
    })];
    self.renderer.target = self.tableView;
    
    // render
    [self render];
}

- (void) render{
    @weakify(self);
    [self.renderer renderWith:@[
        ({
        MT_Section * section = [MT_Section new];
        section.cells = @[
            MT_CellNode.create(Address.create(self.dataForm.address)),
            MT_CellNode.create(AddressPicker.create(self.dataForm.addressOptions)),
        ];
        section;
    }),
        ({
        MT_Section * section = [MT_Section new];
        section.header = MT_ViewNode.create(MT_Spacing.create(10));
        section.cells = @[
            MT_CellNode.create(Pay.create(self.dataForm.payType)),
        ];
        section;
    }),
        ({
        MT_Section * section = [MT_Section new];
        section.header = MT_ViewNode.create(MT_Spacing.create(20));
        section.cells = [self.dataForm.goods mm_map:^MT_CellNode *(NSString *obj) {
            return MT_CellNode.create(Goods.create(obj));
        }];
        section.footer = MT_ViewNode.create(MT_Spacing.create(20));
        section;
    }),
        ({
        Insurance * insurance = Insurance.create(self.dataForm.useInsurance);
        [insurance setBToggle:^(BOOL isOn) {
            @strongify(self);
            self.dataForm.useInsurance = isOn;
//            [self.renderer ];
        }];
        MT_Section * section = [MT_Section new];
        section.cells = @[
            MT_CellNode.create(insurance),
            MT_CellNode.create(Remark.create(self.dataForm.remark))
        ];
        section;
    }),
    ]];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.tableView performBatchUpdates:nil completion:nil];
}

@end

@implementation Address

+ (Address *(^)(NSString *))create{
    return ^Address*(NSString * address){
        Address * me = [Address new];
        me->_address = address;
        return me;
    };
}

- (UILabel *)renderContent{
    UILabel * content = [UILabel new];
    content.textColor = [UIColor randomColor];
    content.font = [UIFont systemFontOfSize:17];
    content.textAlignment = NSTextAlignmentLeft;
    return content;
}

- (void)renderInContent:(UILabel *)content {
    content.text = _address;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetWidth(bounds), 50);
}

- (void)layoutContent:(UILabel *)content inContainer:(UIView *)container{
}
@end

@implementation Pay

+ (Pay *(^)(NSString *))create{
    return ^Pay*(NSString * payType){
        Pay * me = [Pay new];
        me->_payType = payType;
        return me;
    };
}

- (UIView *)renderContent {
    UILabel * content = [UILabel new];
    content.textColor = [UIColor randomColor];
    content.font = [UIFont systemFontOfSize:17];
    content.textAlignment = NSTextAlignmentLeft;
    return content;
}

- (void)renderInContent:(UILabel *)content {
    content.text = _payType;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetHeight(bounds), 44);
}

- (void)contentDidSelected:(id<MT_Content>)content{
    
    @weakify(self);
    NSArray * payTypes = @[@"WechatPay",@"AliPay",@"Bank Card"];
    MMPickerViewConfig * config = [MMPickerViewConfig config];
    config.columns = 1;
    [config defaultSelect:^NSUInteger(NSUInteger column) {
        @strongify(self);
        return [payTypes indexOfObject:self->_payType];
    }];
    [config configRowAt:^NSArray<NSString *> * _Nullable(NSUInteger cloumn) {
        return payTypes;
    }];
    [config monitorSelect:^(NSUInteger column, NSUInteger row, id  _Nullable data) {
        @strongify(self);
        self->_payType = data;
    }];
    MMPickerView * pickerView = [[MMPickerView alloc] initWithConfig:config];
    [pickerView setupInterface:({
        MMPickerViewInterface.interface;
    })];
    [pickerView show];
}
@end

@interface AddressPickerContent : UIView<
MT_Content,
UIPickerViewDelegate,
UIPickerViewDataSource>{
    UIPickerView * _pickerView;
}

@property (nonatomic ,copy) void(^bDidSelected)(NSString *address)
;
@property (nonatomic ,copy) NSArray<NSString *> * addresses;
@end

@implementation AddressPicker

+ (AddressPicker *(^)(NSArray<NSString *> *))create{
    return ^AddressPicker*(NSArray<NSString *> *addresses){
        AddressPicker * addressPicker = [AddressPicker new];
        addressPicker->_addresses = addresses;
        return addressPicker;
    };
}
- (AddressPickerContent *)renderContent{
    return AddressPickerContent.new;
}

- (void)renderInContent:(AddressPickerContent *)content{
    content.addresses = _addresses;
    content.bDidSelected = self.bDidSelected;
}

- (BOOL)shouldRenderNext:(AddressPicker *)next inContent:(AddressPickerContent *)content{
    return _addresses != next->_addresses;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetWidth(bounds), 150);
}
@end

@implementation AddressPickerContent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setAddresses:(NSArray<NSString *> *)addresses{
    _addresses = addresses;
    [_pickerView reloadAllComponents];
}

#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.addresses.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.addresses[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.bDidSelected) {
        self.bDidSelected(self.addresses[row]);
    }
}

@end

@implementation Goods

+ (Goods *(^)(NSString *))create{
    return ^Goods*(NSString * goodsInfo){
        Goods * me = [Goods new];
        me->_goodsInfo = goodsInfo;
        return me;
    };
}

- (UIView *)renderContent {
    UILabel * content = [UILabel new];
    content.textColor = [UIColor randomColor];
    content.font = [UIFont systemFontOfSize:17];
    content.textAlignment = NSTextAlignmentLeft;
    return content;
}

- (void)renderInContent:(UILabel *)content {
    content.text = _goodsInfo;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetHeight(bounds), 60);
}
@end

@interface InsuranceContent : UIView<MT_Content>{
    UILabel * _titleLabel;
    UISwitch * _switch;
}
@property (nonatomic ,copy) void(^bToggle)(BOOL isOn);
- (void) setupTitle:(NSString *)title isOn:(BOOL)isOn;
@end

@implementation Insurance

+ (Insurance *(^)(BOOL))create{
    return ^Insurance*(BOOL use){
        Insurance * me = [Insurance new];
        me->_use = use;
        return me;
    };
}

- (InsuranceContent *)renderContent {
    InsuranceContent * content = [InsuranceContent new];
    return content;
}

- (void)renderInContent:(InsuranceContent *)content {
    NSString * title = _use ? @"使用准时宝" : @"不使用准时宝";
    [content setupTitle:title isOn:_use];
    content.bToggle = self.bToggle;
//    [content setBToggle:^(BOOL isOn) {
//        self->_use = isOn;
//    }];
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetHeight(bounds), 44);
}

- (BOOL)shouldRenderNext:(Insurance *)next inContent:(InsuranceContent *)content{
    return _use != next->_use;
}
@end

@implementation InsuranceContent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor randomColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _switch = [UISwitch new];
        [_switch addTarget:self action:@selector(onSwitch:)
          forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switch];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(12);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(self);
        }];
        
        [_switch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 40));
            make.right.equalTo(self).mas_offset(-12);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void) setupTitle:(NSString *)title isOn:(BOOL)isOn{
    _titleLabel.text = title;
    _switch.on = isOn;
}

- (void) onSwitch:(UISwitch *)mySwitch{
    if (self.bToggle) {
        self.bToggle(mySwitch.isOn);
    }
}
@end

@implementation Remark

+ (Remark *(^)(NSString *))create{
    return ^Remark*(NSString * remark){
        Remark * me = [Remark new];
        me->_remark = remark;
        return me;
    };
}

- (UIView *)renderContent {
    UILabel * content = [UILabel new];
    content.textColor = [UIColor randomColor];
    content.font = [UIFont systemFontOfSize:17];
    content.textAlignment = NSTextAlignmentLeft;
    return content;
}

- (void)renderInContent:(UILabel *)content {
    content.text = _remark;
}

- (CGSize)referenceSizeInBounds:(CGRect)bounds{
    return CGSizeMake(CGRectGetHeight(bounds), 100);
}
@end

@implementation DataForm

@end
