//
//  KXBeautyMainViewController.m
//  KXLive
//
//  Created by ydd on 2019/11/6.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyMainViewController.h"
#import "KXBeautyView.h"
#import "KXBeautyFilterView.h"
#import "KXFaceBeautyModelManager.h"
#import "KXBeautySlider.h"
#import "KXFilterCellModel.h"
#import "FUManager.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "KXMoreBeautyView.h"
#import "HLLAlert.h"

@interface KXBeautyMainViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) KXBeautyView *beautyView;

@property (nonatomic, strong) KXBeautyFilterView *filterView;

@property (nonatomic, strong) UIView *filterSliderView;
@property (nonatomic, strong) KXBeautySlider *filterSlider;
@property (nonatomic, strong) UILabel *filterNameLabel;

@property (nonatomic ,strong) KXMoreBeautyView * moreBeautyView;
@end

@implementation KXBeautyMainViewController

-(void)dealloc{
    NSLog(@"KXBeautyMainViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initFilerSlider];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.filterSliderView.mas_bottom);
    }];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setImage:[UIImage imageNamed:@"meiyan_reset"] forState:UIControlStateNormal];
//    [resetBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 14, 16, 30)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
//    [resetBtn setTitleEdgeInsets:UIEdgeInsetsMake(14, 32, 14, 0)];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [resetBtn setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
    resetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(45);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(resetBtn.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"美颜";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.bgView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(line.mas_bottom).mas_offset(16);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"更多设置" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"meiyan_gdBack"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 70, 6, 0)];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#AAAAAA"] forState:UIControlStateNormal];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];;
    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.bgView).mas_offset(-14);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.bgView addSubview:self.beautyView];
    [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(116);
    }];
    
    [self.bgView addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.beautyView.mas_bottom).mas_equalTo(23);
        make.height.mas_equalTo(75);
    }];
    
    [self.bgView addSubview:self.moreBeautyView];
    [self.moreBeautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).mas_offset([UIScreen mainScreen].bounds.size.width);
        make.width.width.top.bottom.equalTo(self.bgView);
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask  = maskLayer;
}

- (void)initFilerSlider
{
    [self.view addSubview:self.filterSliderView];
    [self.filterSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    [self.filterSliderView addSubview:self.filterNameLabel];
    [self.filterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
    }];
    
    UIButton *beautySwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    beautySwitch.backgroundColor = [UIColor clearColor];
    [beautySwitch addTarget:self action:@selector(switchTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    [beautySwitch addTarget:self action:@selector(switchTouchUpAction:) forControlEvents:UIControlEventTouchCancel];
    [beautySwitch addTarget:self action:@selector(switchTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [beautySwitch addTarget:self action:@selector(switchTouchUpAction:) forControlEvents:UIControlEventTouchUpOutside];
    [self.filterSliderView addSubview:beautySwitch];
    [beautySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.filterNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    UIImageView *filterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meiyan_mydb"]];
    filterImage.contentMode = UIViewContentModeScaleAspectFill;
    filterImage.clipsToBounds = YES;
    filterImage.userInteractionEnabled = YES;
    [self.filterSliderView addSubview:filterImage];
    [filterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.filterNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _filterSlider = [[KXBeautySlider alloc] initWithFrame:(CGRect){
        90, 18,
        [UIScreen mainScreen].bounds.size.width - 90 - 64, 18
    }
                                                   Height:16 type:KXSliderType_def];
    _filterSlider.tipsColor = [UIColor whiteColor];
    _filterSlider.tipLabel.font = [UIFont systemFontOfSize:18];
    _filterSlider.progressDidChanged = ^(CGFloat progress) {
        KXBeautyManager.curfilterModel.value = progress;
    };
    
    [self.filterSliderView addSubview:self.filterSlider];
    
    [self.beautyView reloadData:[KXBeautyManager.beautyArray subarrayWithRange:NSMakeRange(0, 4)]];
    [self.filterView reloadData:KXBeautyManager.filterArray];
    [self updateFilterSliderView];
    self.filterSlider.progress = KXBeautyManager.beautyModel.selectedFilterLevel;
    
}

- (void)switchTouchDownAction:(UIButton *)btn
{
    [FUManager shareManager].closeBeauty = YES;
}
- (void)switchTouchUpAction:(UIButton *)btn
{
    [FUManager shareManager].closeBeauty = NO;
}

- (void)resetAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    [[[[HLLAlertUtil title:@"确认将所有参数恢复默认吗？"] addCancelButton:@"取消"]
      addButton:^(NSInteger index) {
        [KXBeautyManager.beautyModel setDefaultModel];
        KXBeautyManager.beautyArray = nil;
        [weakSelf.beautyView reloadData:[KXBeautyManager.beautyArray subarrayWithRange:NSMakeRange(0, 4)]];
        KXBeautyManager.filterArray = nil;
        [weakSelf.filterView reloadData:KXBeautyManager.filterArray];
        weakSelf.filterSliderView.hidden = YES;
        weakSelf.filterSlider.progress = KXBeautyManager.beautyModel.selectedFilterLevel;
    } title:@"确认" style:UIAlertActionStyleDefault] showIn:self];
}

- (void)moreBtnAction:(UIButton *)btn
{
    self.filterSliderView.alpha = 0;
    if (self.bPopupCanToushMaskDismiss) {
        self.bPopupCanToushMaskDismiss(NO);
    }
    [self.moreBeautyView reloadData];
    [self showMoreBeautyView:YES];
}

- (void) showMoreBeautyView:(BOOL)show{
    
    [self.moreBeautyView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (show) {
            make.left.equalTo(self.bgView).mas_offset(0);
        } else {
            make.left.equalTo(self.bgView).mas_offset([UIScreen mainScreen].bounds.size.width);
        }
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateFilterSliderView
{
    KXFilterCellModel *model = KXBeautyManager.curfilterModel;
    if ([model.filter isEqualToString:@"origin"]) {
        self.filterSliderView.hidden = YES;
    } else {
        self.filterNameLabel.text = model.name;
        self.filterSliderView.hidden = NO;
        self.filterSlider.progress = model.value;
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.mas_key = @".bgView";
        _bgView.restorationIdentifier = @".bgView";
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (KXBeautyView *)beautyView
{
    if (!_beautyView) {
        _beautyView = [[KXBeautyView alloc] init];
    }
    return _beautyView;
}

- (KXBeautyFilterView *)filterView
{
    if (!_filterView) {
        _filterView = [[KXBeautyFilterView alloc] init];
        __weak typeof(self) weakSelf = self;
        _filterView.seletedFilterBlock = ^(KXFilterCellModel *model) {
            [weakSelf updateFilterSliderView];
        };
    }
    return _filterView;
}

- (UIView *)filterSliderView
{
    if (!_filterSliderView) {
        _filterSliderView = [[UIView alloc] init];
    }
    return _filterSliderView;
}


- (UILabel *)filterNameLabel
{
    if (!_filterNameLabel) {
        _filterNameLabel = [[UILabel alloc] init];
        _filterNameLabel.textAlignment = NSTextAlignmentCenter;
        _filterNameLabel.font = [UIFont systemFontOfSize:14];
        _filterNameLabel.textColor = [UIColor whiteColor];
    }
    return _filterNameLabel;
}
- (KXMoreBeautyView *)moreBeautyView{
    if (!_moreBeautyView) {
        _moreBeautyView = [KXMoreBeautyView new];
        __weak typeof(self) weakSelf = self;
        [_moreBeautyView setBBackAction:^{
           [weakSelf showMoreBeautyView:NO];
            if (weakSelf.bPopupCanToushMaskDismiss) {
                weakSelf.bPopupCanToushMaskDismiss(YES);
            }
            [weakSelf.beautyView reloadData:[KXBeautyManager.beautyArray subarrayWithRange:NSMakeRange(0, 4)]];
            weakSelf.filterSliderView.alpha = 1;
        }];
    }
    return _moreBeautyView;
}
@end
