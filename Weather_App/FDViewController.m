//
//  FDViewController.m
//  Weather_App
//
//  Created by Rocky Young on 2017/10/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "FDViewController.h"
#import "Masonry.h"
#import "UIColor+Common.h"
#import "FDContentView.h"
#import "CLTStickyLayout.h"

@interface FDViewController ()<UICollectionViewDataSource,CLTStickyLayoutDelegate,FDContentViewDelegate>

@property (nonatomic ,strong) FDContentView * contentView;
@end

@implementation FDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F5F5"];
    
    self.contentView = [[FDContentView alloc] init];
    [self.view addSubview:self.contentView];
    self.contentView.delegate = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.contentView configCollectionView:^(UICollectionView *collectionView) {
        
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class]
           forCellWithReuseIdentifier:@"cell"];
        [collectionView registerClass:[UICollectionReusableView class]
           forSupplementaryViewOfKind:CLTCollectionElementKindSectionHeader
                  withReuseIdentifier:@"sectionHeader"];
        
        CLTStickyLayout * layout = (CLTStickyLayout *)collectionView.collectionViewLayout;
        layout.delegate = self;
        layout.sectionFooterHeight = 0.0f;
        layout.sectionMargin = UIEdgeInsetsMake(10, 20, 10, 20);
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = self.view.bounds.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom;
    } else {
        height = self.view.bounds.size.height - 0;
    }
    [self.contentView modifContentViewHeight:height];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:CLTCollectionElementKindSectionHeader]) {
        
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:CLTCollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        view.backgroundColor = indexPath.section == 1 ? [UIColor whiteColor] : [UIColor greenColor];
        return view;
    }
    return nil;
}

#pragma mark - CLTStickyLayoutDelegate

- (CGFloat) CLT_stickyLayoutSectionHeaderViewHeight{
    
    return 50;
}

- (CGSize)  CLT_stickyLayoutItemSize{

    return CGSizeMake(1000, 70);
}

#pragma mark - FDContentViewDelegate

- (void)contentViewDidExecuteChangeDisplayType:(FDContentView *)contentView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contentViewDidExecuteChangePrevious:(FDContentView *)contentView{
    
}

- (void)contentViewDidExecuteChangeBehind:(FDContentView *)contentView{
    
    
}
@end
