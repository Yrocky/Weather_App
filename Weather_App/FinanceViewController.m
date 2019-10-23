//
//  FinanceViewController.m
//  Weather_App
//
//  Created by skynet on 2019/8/29.
//  Copyright © 2019 Yrocky. All rights reserved.
//

#import "FinanceViewController.h"
#import "UIView+AsyncDrawImage.h"
#import "UIColor+Common.h"
#import "Masonry.h"
#import "NSUserDefaults+MM_Common.h"
#import "NSArray+Sugar.h"

static NSString * financesKey = @"finances-365";
static int total = 365;

@interface FinanceViewController ()
@property (nonatomic ,strong) UIButton * saveButton;
@property (nonatomic ,strong) UIButton * ganerateButton;

@property (nonatomic ,strong) UILabel * totalLabel;
@property (nonatomic ,strong) UILabel * moneyLabel;
@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Finance";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"0";
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:130];
    [self.view addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(-150);
    }];
    
    self.totalLabel = [UILabel new];
    NSArray * finances = MM_UserDefaults.mm_objectValue(financesKey);
    if (finances.count == total) {
        self.totalLabel.text = [NSString stringWithFormat:@"finished"];
    } else {
        self.totalLabel.text = [NSString stringWithFormat:@"finance progress:%lu/%d",(unsigned long)finances.count,total];
    }
    self.totalLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:20];
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.centerX.equalTo(self.moneyLabel);
    }];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton asyncDrawBackgroundImageWithColor:[UIColor colorWithHexString:@"#FC2D5F"]
                                              forState:UIControlStateNormal];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(onSave:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    
    
    self.ganerateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ganerateButton asyncDrawBackgroundImageWithColor:[UIColor colorWithHexString:@"#3AB4F8"]
                                              forState:UIControlStateNormal];
    [self.ganerateButton setTitle:@"Gener" forState:UIControlStateNormal];
    [self.ganerateButton addTarget:self action:@selector(onGanerate:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ganerateButton];
    
    [self.ganerateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(30);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
        } else {
            make.bottom.equalTo(self.view).mas_offset(-50);
        }
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view.mas_centerX).mas_offset(-15);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-30);
        make.bottom.equalTo(self.ganerateButton);
        make.height.mas_equalTo(self.ganerateButton);
        make.width.equalTo(self.ganerateButton);
    }];
}

#pragma mark - Action

- (void) onSave:(UIButton *)button{
    
    NSArray<NSNumber *> * finances = MM_UserDefaults.mm_objectValue(financesKey);
    if (!finances) {
        finances = [NSArray new];
    }
    int count = self.moneyLabel.text.intValue;
    if (!finances.mm_have(@(count)) && count) {
        NSMutableArray * tmp = [finances mutableCopy];
        [tmp addObject:@(count)];
        MM_UserDefaults.mm_addObject(financesKey,tmp.copy);
    }
    
    if (count == 0) {
        self.totalLabel.text = [NSString stringWithFormat:@"finished"];
    } else {
        finances = MM_UserDefaults.mm_objectValue(financesKey);
        self.totalLabel.text = [NSString stringWithFormat:@"finance progress:%lu/%d",(unsigned long)finances.count,total];
    }
    NSLog(@"finances:%@",finances);
}

- (void) onGanerate:(UIButton *)button{

    int count;
    NSArray<NSNumber *> * finances = MM_UserDefaults.mm_objectValue(financesKey);
    if (finances && [finances isKindOfClass:[NSArray class]] && finances.count) {
        count = [self randomWithFinances:finances];
    } else {
        count = [self random];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (int) randomWithFinances:(NSArray<NSNumber *>*)finances{
    
    int count = [self random];
    if (finances.count >= total) {
        return 0;
    }
    if (finances.mm_have(@(count))) {
        count = [self randomWithFinances:finances];
    }
    return count;
}

-(int)random{
    
    int from = 1;
    int to = total;
    return (int)(from + (arc4random() % (to - from + 1)));
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
