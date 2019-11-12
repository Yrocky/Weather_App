//
//  KXBeautyFilterView.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyFilterView.h"
#import "KXBeautyFilterCell.h"
#import "KXFaceBeautyModelManager.h"
#import "Masonry.h"

@interface KXBeautyFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <KXFilterCellModel*>*dataArr;

@end

@implementation KXBeautyFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)reloadData:(NSArray <KXFilterCellModel *> *)array
{
    self.dataArr = array;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KXFilterCellModel *model = self.dataArr[indexPath.item];
    KXBeautyManager.beautyModel.selectedFilter = model.filter;
    KXBeautyManager.curfilterModel = model;
    [self.collectionView reloadData];
    if (self.seletedFilterBlock) {
        self.seletedFilterBlock(model);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KXBeautyFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.cellModel = self.dataArr[indexPath.item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = [KXBeautyFilterCell cellSize];
        flow.minimumLineSpacing = 14;
        flow.minimumInteritemSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KXBeautyFilterCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
    
}

@end
