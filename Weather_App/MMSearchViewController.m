//
//  MMSearchViewController.m
//  Weather_App
//
//  Created by user1 on 2017/10/17.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMSearchDefaultCollectionView.h"
#import <Masonry/Masonry.h>

@interface MM_testObj : NSObject
@property (nonatomic ,copy) void (^cb)(NSString *text);
@end
@implementation MM_testObj
@end

@interface MMSearchViewController ()<MMSearchDefaultCollectionViewDelegate>

@property (nonatomic ,strong) MM_SearchDefaultCollectionView * defaultView;

@end

@implementation MMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    
    MM_testObj * obj = [[MM_testObj alloc] init];
    obj.cb = ^(NSString *text) {
        
    };
    
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 20;
    self.defaultView = [[MM_SearchDefaultCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.defaultView.handleDelegate = self;
    self.defaultView.historyArray = @[@"sdfs",@"sdfdvd",@"rweef"];
    self.defaultView.labelArray = @[@"sdfdsf",@"3r3",@"sdfdfd",@"g3gerg",@"g34gerfergergaerg",@"dgdfgfd",@"dfgdg4",@"dfg34ger",@"g34geg",@"gdt4",@"f34gergd",@"43g3erg",@"g34ger",@"dfg3gr",@"34gf"];
    self.defaultView.recommandArray = @[@"g3gerg",@"dfgdg4",@"dfg34ger",@"[][]jhk",@"g34gerfergergaerg",@"dgdfgfd",@"f34gergd",@"43g3erg",@"g34ger",@"g34geg",@"gdt4",@"dfg3gr",@"34gf"];
    [self.view addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - MMSearchDefaultCollectionViewDelegate

// 清空搜索历史
- (void) searchDefaultCollectionViewDidCleanSearchHistory:(MM_SearchDefaultCollectionView *)collectionView{
    
    
}

// 点击某一个cell
- (void) searchDefaultCollectionView:(MM_SearchDefaultCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
