//
//  KXBeautyView.m
//  KXLive
//
//  Created by ydd on 2019/11/5.
//  Copyright © 2019 ibobei. All rights reserved.
//

#import "KXBeautyView.h"
#import "KXBeautyCell.h"
#import "Masonry.h"

@interface KXBeautyView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <KXBeautyCellModel*>*dataArr;

@end

@implementation KXBeautyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderTouchNotify:) name:@"KXSliderEnded" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderTouchNotify:) name:@"KXSliderBegan" object:nil];
    }
    return self;
}

- (void)sliderTouchNotify:(NSNotification *)notify
{
    if ([notify.name isEqualToString:@"KXSliderBegan"]) {
        self.collectionView.scrollEnabled = NO;
    } else {
        self.collectionView.scrollEnabled = YES;
    }
}


- (void)reloadData:(NSArray <KXBeautyCellModel*>*)dataArr {
    self.dataArr = dataArr;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KXBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.beautyModel = self.dataArr[indexPath.item];
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
        flow.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
        flow.minimumLineSpacing = 6;
        flow.minimumInteritemSpacing = 29;
        flow.itemSize = (CGSize){
            ([UIScreen mainScreen].bounds.size.width - 14-14-29) / 2.0,
            [KXBeautyCell height]
        };
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[KXBeautyCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


@end
